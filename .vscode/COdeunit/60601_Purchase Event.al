codeunit 60601 "Purchase Order Restriction"
{
    SingleInstance = true;
    Permissions = tabledata 121 = m;
    trigger OnRun()
    begin

    end;

    procedure UpdateDate()
    var
        L_PurcRecpt: Record "Purch. Rcpt. Line";
    begin
        L_PurcRecpt.Reset();
        if L_PurcRecpt.FindSet() then begin
            repeat
                L_PurcRecpt.CalcFields("Custom Order Date");
                L_PurcRecpt."Budget Receipt Date" := L_PurcRecpt."Custom Order Date";
                L_PurcRecpt.Modify();
            until L_PurcRecpt.Next() = 0;
        end;
    end;


    var
        myInt: Integer;
        WarningtypeOpion: Text;
        G_CallFromDelte: Boolean;
        G_CalledFrom: Option Creation,Post;




    #Region At the time release+++
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnPerformManualReleaseOnBeforeTestPurchasePrepayment, '', false, false)]
    // local procedure OnPerformManualReleaseOnBeforeTestPurchasePrepayment(var PurchaseHeader: Record "Purchase Header")
    // var
    //     RecUserSetup: Record "User Setup";
    //     L_PurchaseLine: Record "Purchase Line";
    // begin
    //     if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then begin
    //         IF RecUserSetup.GET(USERID) THEN BEGIN
    //             IF NOT RecUserSetup."PO Override MaxQty Calculation" THEN BEGIN
    //                 L_PurchaseLine.Reset();
    //                 L_PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
    //                 L_PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
    //                 L_PurchaseLine.SetRange(Type, L_PurchaseLine.Type::Item);
    //                 if L_PurchaseLine.FindSet() then begin
    //                     repeat
    //                         if L_PurchaseLine."Line Amount" <> 0 then
    //                             CheckMaxOrderamt(L_PurchaseLine);
    //                     until L_PurchaseLine.Next() = 0;
    //                 end;
    //             END;
    //         END ELSE BEGIN
    //             L_PurchaseLine.Reset();
    //             L_PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
    //             L_PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
    //             L_PurchaseLine.SetRange(Type, L_PurchaseLine.Type::Item);
    //             if L_PurchaseLine.FindSet() then begin
    //                 repeat
    //                     if L_PurchaseLine."Line Amount" <> 0 then
    //                         CheckMaxOrderamt(L_PurchaseLine);
    //                 until L_PurchaseLine.Next() = 0;
    //             end;
    //         END;
    //     end;
    // end;
    #EndRegion At the time release+++

    #Region Update Budget Date after posting+++
    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchaseDoc, '', false, false)]
    local procedure OnAfterPostPurchaseDoc(PurchRcpHdrNo: Code[20]; var PurchaseHeader: Record "Purchase Header")
    var
        L_PurchaseRecieptHeader: Record "Purch. Rcpt. Header";
        L_PurchaseRecieptLine: Record "Purch. Rcpt. Line";
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
            L_PurchaseRecieptHeader.Reset();
            L_PurchaseRecieptHeader.SetRange("No.", PurchRcpHdrNo);
            if L_PurchaseRecieptHeader.FindFirst() then begin
                if (IsSameMonth(PurchaseHeader."Order Date", WorkDate()) = true) OR (IsBeforeMonth(PurchaseHeader."Order Date", WorkDate()) = true) then begin
                    L_PurchaseRecieptLine.Reset();
                    L_PurchaseRecieptLine.SetRange("Document No.", L_PurchaseRecieptHeader."No.");
                    if L_PurchaseRecieptLine.FindSet() then begin
                        L_PurchaseRecieptLine.ModifyAll("Budget Receipt Date", PurchaseHeader."Order Date");
                    end;
                end else begin
                    if IsAfterMonth(PurchaseHeader."Order Date", WorkDate()) = true then begin
                        L_PurchaseRecieptLine.Reset();
                        L_PurchaseRecieptLine.SetRange("Document No.", L_PurchaseRecieptHeader."No.");
                        if L_PurchaseRecieptLine.FindSet() then begin
                            L_PurchaseRecieptLine.ModifyAll("Budget Receipt Date", WorkDate());
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure IsSameMonth(OrderDate: Date; PostingDate: Date): Boolean
    begin
        exit(CompareMonth(OrderDate, PostingDate) = 0);
    end;

    procedure IsBeforeMonth(DateToCheck: Date; BaseDate: Date): Boolean
    begin
        // true if DateToCheck is in an earlier month than BaseDate
        exit(CompareMonth(DateToCheck, BaseDate) < 0);
    end;

    procedure IsAfterMonth(DateToCheck: Date; BaseDate: Date): Boolean
    begin
        // true if DateToCheck is in a later month than BaseDate
        exit(CompareMonth(DateToCheck, BaseDate) > 0);
    end;

    procedure CompareMonth(OrderDate: Date; PostingDate: Date): Integer
    var
        M_OrderDate: Integer;
        Y_OrderDate: Integer;
        M_PostingDate: Integer;
        Y_PostingDate: Integer;
    begin
        M_OrderDate := Date2DMY(OrderDate, 2);
        Y_OrderDate := Date2DMY(OrderDate, 3);
        M_PostingDate := Date2DMY(PostingDate, 2);
        Y_PostingDate := Date2DMY(PostingDate, 3);

        if Y_OrderDate < Y_PostingDate then
            exit(-1);
        if Y_OrderDate > Y_PostingDate then
            exit(1);
        // same year -> compare month
        if M_OrderDate < M_PostingDate then
            exit(-1);
        if M_OrderDate > M_PostingDate then
            exit(1);
        exit(0); // same year and month
    end;
    #EndRegion Update Budget Date after posting+++


    #Region Quota Check at the time of posting++
    [EventSubscriber(ObjectType::Codeunit, 90, OnRunOnBeforePostPurchLine, '', false, false)]
    local procedure OnRunOnBeforePostPurchLine(var PurchLine: Record "Purchase Line")
    var
        RecUserSetup: Record "User Setup";
    begin
        if ((PurchLine."Line Amount" <> 0) AND (PurchLine."Document Type" = PurchLine."Document Type"::Order)) then begin
            IF RecUserSetup.GET(USERID) THEN BEGIN
                IF NOT RecUserSetup."PO Override MaxQty Calculation" THEN BEGIN
                    CheckMaxOrderamt(PurchLine, G_CalledFrom::Post);
                END;
            END ELSE BEGIN
                CheckMaxOrderamt(PurchLine, G_CalledFrom::Post);
            END;
        end;
    end;
    #EndRegion Quota Check at the time of posting++

    #Region Quota Check at the time creation of PO++++
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnDeleteOnBeforeTestStatusOpen, '', false, false)]
    local procedure OnDeleteOnBeforeTestStatusOpen()
    begin
        G_CallFromDelte := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterUpdateAmountsDone, '', false, false)]
    local procedure OnAfterUpdateAmountsDone(var PurchLine: Record "Purchase Line")
    var
        RecUserSetup: Record "User Setup";
    begin
        if ((PurchLine."Line Amount" <> 0) AND (PurchLine."Document Type" = PurchLine."Document Type"::Order) AND (G_CallFromDelte = false)) then begin
            IF RecUserSetup.GET(USERID) THEN BEGIN
                IF NOT RecUserSetup."PO Override MaxQty Calculation" THEN BEGIN
                    CheckMaxOrderamt(PurchLine, G_CalledFrom::Creation);
                END;
            END ELSE BEGIN
                CheckMaxOrderamt(PurchLine, G_CalledFrom::Creation);
            END;
        end;
        Clear(G_CallFromDelte);
    end;
    #EndRegion Quota Check at the time creation of PO++++


    procedure CheckMaxOrderamt(P_PurchaseLine: Record "Purchase Line"; _CalledFrom: Option Creation,Post)
    var
        PurchaseHeader: Record "Purchase Header";
        RecitemAmt: Record Item;
        CurrentMonthStartDateAmt: Date;
        CurrentYearAmt: Integer;
        currentMonthAmt: Integer;
        CurrentMonth_TextAmt: Text;
        EndDateAmt: Date;
        L_QuotaFound: Boolean;
    begin
        Clear(CurrentMonthStartDateAmt);
        Clear(EndDateAmt);
        Clear(L_QuotaFound);

        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("No.", P_PurchaseLine."Document No.");
        PurchaseHeader.SetRange("Document Type", P_PurchaseLine."Document Type");
        if PurchaseHeader.FindFirst() then;

        RecitemAmt.Reset();
        RecitemAmt.SetRange("No.", P_PurchaseLine."No.");
        if RecitemAmt.FindFirst() then;
        RecitemAmt.CalcFields("Parent Category");


        if _CalledFrom = _CalledFrom::Creation then begin
            //StartDateEndDateCalculation
            currentMonthAmt := Date2DMY(PurchaseHeader."Order Date", 2);
            CurrentYearAmt := Date2DMY(PurchaseHeader."Order Date", 3);
            if currentMonthAmt > 9 then
                CurrentMonth_TextAmt := Format(currentMonthAmt)
            else
                CurrentMonth_TextAmt := '0' + Format(currentMonthAmt);
            Evaluate(CurrentMonthStartDateAmt, '01' + CurrentMonth_TextAmt + Format(CurrentYearAmt));
            //CurrentMonthStartDate--

            //EndDate++
            EndDateAmt := CalcDate('+1M', CurrentMonthStartDateAmt);
            EndDateAmt := CalcDate('-1D', EndDateAmt);
            //EndDate--
        end else begin
            if _CalledFrom = _CalledFrom::Post then begin
                //StartDateEndDateCalculation
                if (IsSameMonth(PurchaseHeader."Order Date", WorkDate()) = true) OR (IsBeforeMonth(PurchaseHeader."Order Date", WorkDate()) = true) then begin
                    currentMonthAmt := Date2DMY(PurchaseHeader."Order Date", 2);
                    CurrentYearAmt := Date2DMY(PurchaseHeader."Order Date", 3);
                    if currentMonthAmt > 9 then
                        CurrentMonth_TextAmt := Format(currentMonthAmt)
                    else
                        CurrentMonth_TextAmt := '0' + Format(currentMonthAmt);
                    Evaluate(CurrentMonthStartDateAmt, '01' + CurrentMonth_TextAmt + Format(CurrentYearAmt));
                    //CurrentMonthStartDate--

                    //EndDate++
                    EndDateAmt := CalcDate('+1M', CurrentMonthStartDateAmt);
                    EndDateAmt := CalcDate('-1D', EndDateAmt);
                    //EndDate--
                end else begin
                    if IsAfterMonth(PurchaseHeader."Order Date", WorkDate()) = true then begin
                        currentMonthAmt := Date2DMY(WorkDate(), 2);
                        CurrentYearAmt := Date2DMY(WorkDate(), 3);
                        if currentMonthAmt > 9 then
                            CurrentMonth_TextAmt := Format(currentMonthAmt)
                        else
                            CurrentMonth_TextAmt := '0' + Format(currentMonthAmt);
                        Evaluate(CurrentMonthStartDateAmt, '01' + CurrentMonth_TextAmt + Format(CurrentYearAmt));
                        //CurrentMonthStartDate--

                        //EndDate++
                        EndDateAmt := CalcDate('+1M', CurrentMonthStartDateAmt);
                        EndDateAmt := CalcDate('-1D', EndDateAmt);
                        //EndDate--
                    end;
                end;

            end;
        end;

        //+++All Vendor Selected Item Category+++
        L_QuotaFound := PerMonthAllVendorSelItemCatAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Parent Category", CurrentMonthStartDateAmt, EndDateAmt);


        //+++Vendor Selected Item Category+++
        if L_QuotaFound = false then
            L_QuotaFound := PerMonthSelVendorSelItemCatAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Parent Category", CurrentMonthStartDateAmt, EndDateAmt);

        //If Quota Not Found then Exit
        if (not L_QuotaFound) AND (P_PurchaseLine.Type = P_PurchaseLine.Type::Item) then
            Error('Purchase budget not Found for order number %1 and Line number %2', P_PurchaseLine."Document No.", P_PurchaseLine."Line No.");

    end;

    procedure PerMonthAllVendorSelItemCatAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20]; Sdate: date; Edate: Date) IsQuotaExists: Boolean
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderAmount: Decimal;
        L_RemainingQuantity: Decimal;
        PurchaseLine: Record "Purchase Line";
        PurchInvLine: Record "Purch. Inv. Line";
        L_OrderAmount: Decimal;
        L_ILE: Record "Item Ledger Entry";
        AmountFromILE: Decimal;
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        L_PurchRcptLine: Record "Purch. Rcpt. Line";
        Query_POAmount: Query "PO order Amt";
    begin
        //Clear Vairiables++
        Clear(L_DayOrderAmount);
        Clear(L_RemainingQuantity);
        Clear(L_OrderAmount);
        Clear(WarningtypeOpion);

        //Processs++
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::"All Vendor");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        L_MaxOrderQty.SetCurrentKey("Start Date");
        L_MaxOrderQty.Ascending(true);
        IF L_MaxOrderQty.FindSet() THEN BEGIN
            repeat
                // Get Warning type++
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
                // Check Date Range++
                if (L_MaxOrderQty."Start Date" <= _PurchaseHeader."Order Date") and (L_MaxOrderQty."End Date" >= _PurchaseHeader."Order Date") then begin

                    #Region  Order Amount from PO++
                    Clear(L_DayOrderAmount);
                    Clear(Query_POAmount);
                    Query_POAmount.SetRange(Query_POAmount.Document_Type, _PurchaseLine."Document Type");
                    Query_POAmount.SetFilter(Query_POAmount.Document_No_, '<>%1', _PurchaseLine."Document No.");
                    Query_POAmount.SetRange(Query_POAmount.Parent_Category, ItemCat);
                    Query_POAmount.SetFilter(Query_POAmount.Custom_Order_Date, '%1..%2', Sdate, Edate);
                    Query_POAmount.Open();
                    while Query_POAmount.Read() do begin
                        L_DayOrderAmount += Query_POAmount.Outstanding_Amt__Ex__VAT__LCY_;
                    end;

                    //--Calculate Same Order Amount but if same item in Different line++
                    Clear(Query_POAmount);
                    Query_POAmount.SetRange(Query_POAmount.Document_Type, _PurchaseLine."Document Type");
                    Query_POAmount.SetRange(Query_POAmount.Document_No_, _PurchaseLine."Document No.");
                    Query_POAmount.SetFilter(Query_POAmount.Line_No_, '<>%1', _PurchaseLine."Line No.");
                    Query_POAmount.SetRange(Query_POAmount.Parent_Category, ItemCat);
                    Query_POAmount.SetFilter(Query_POAmount.Custom_Order_Date, '%1..%2', Sdate, Edate);
                    Query_POAmount.Open();
                    while Query_POAmount.Read() do begin
                        L_DayOrderAmount += Query_POAmount.Outstanding_Amt__Ex__VAT__LCY_;
                    end;
                    #EndRegion Order Amount from PO++

                    #Region Order Amount From Recpt Line++
                    Clear(AmountFromILE);
                    L_PurchRcptLine.Reset();
                    L_PurchRcptLine.SetRange(Type, L_PurchRcptLine.Type::Item);
                    L_PurchRcptLine.SetRange("Parent Category", ItemCat);
                    L_PurchRcptLine.SetFilter("Budget Receipt Date", '%1..%2', Sdate, Edate);
                    L_PurchRcptLine.SetFilter(Quantity, '>0');
                    if L_PurchRcptLine.FindSet() then begin
                        repeat
                            AmountFromILE := AmountFromILE + L_PurchRcptLine."Unit Cost (LCY)" * L_PurchRcptLine.Quantity;
                        until L_PurchRcptLine.Next() = 0;

                        L_DayOrderAmount += AmountFromILE;
                    end;
                    #EndRegion Order Amount From Recpt Line++

                    //Current Line Amount
                    Clear(L_OrderAmount);
                    L_OrderAmount := _PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";


                    //Calculate Ramaining amount++
                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderAmount;
                    if L_RemainingQuantity <= 0 then
                        L_RemainingQuantity := 0;

                    //+++
                    CheckRemainingAmt(L_RemainingQuantity, 'ASICPMAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type", L_OrderAmount);

                    //Quota Found
                    IsQuotaExists := true;

                    //If not Error then Exit +++++
                    exit;
                end else
                    IsQuotaExists := false;
            until L_MaxOrderQty.Next() = 0;
        End else
            IsQuotaExists := false;
    end;

    procedure PerMonthSelVendorSelItemCatAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20]; Sdate: date; Edate: Date) IsQuotaExists: Boolean
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderAmount: Decimal;
        L_RemainingQuantity: Decimal;
        PurchaseLine: Record "Purchase Line";
        PurchInvLine: Record "Purch. Inv. Line";
        L_OrderAmount: Decimal;
        L_ILE: Record "Item Ledger Entry";
        AmountFromILE: Decimal;
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        L_PurchRcptLine: Record "Purch. Rcpt. Line";
        Query_POAmount: Query "PO order Amt";
    begin
        //Clear Vairiables++
        Clear(L_DayOrderAmount);
        Clear(L_RemainingQuantity);
        Clear(L_OrderAmount);
        Clear(WarningtypeOpion);

        //Processs++
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        L_MaxOrderQty.SetCurrentKey("Start Date");
        L_MaxOrderQty.Ascending(true);
        IF L_MaxOrderQty.FindSet() THEN BEGIN
            repeat
                // Get Warning type++
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                // Check Date Range++
                if (L_MaxOrderQty."Start Date" <= _PurchaseHeader."Order Date") and (L_MaxOrderQty."End Date" >= _PurchaseHeader."Order Date") then begin

                    #Region  Order Amount from PO++
                    Clear(L_DayOrderAmount);
                    Clear(Query_POAmount);
                    Query_POAmount.SetRange(Query_POAmount.Document_Type, _PurchaseLine."Document Type");
                    Query_POAmount.SetFilter(Query_POAmount.Document_No_, '<>%1', _PurchaseLine."Document No.");
                    Query_POAmount.SetRange(Query_POAmount.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                    Query_POAmount.SetRange(Query_POAmount.Parent_Category, ItemCat);
                    Query_POAmount.SetFilter(Query_POAmount.Custom_Order_Date, '%1..%2', Sdate, Edate);
                    Query_POAmount.Open();
                    while Query_POAmount.Read() do begin
                        L_DayOrderAmount += Query_POAmount.Outstanding_Amt__Ex__VAT__LCY_;
                    end;

                    //--Calculate Same Order Amount but if same item in Different line++
                    Clear(Query_POAmount);
                    Query_POAmount.SetRange(Query_POAmount.Document_Type, _PurchaseLine."Document Type");
                    Query_POAmount.SetRange(Query_POAmount.Document_No_, _PurchaseLine."Document No.");
                    Query_POAmount.SetFilter(Query_POAmount.Line_No_, '<>%1', _PurchaseLine."Line No.");
                    Query_POAmount.SetRange(Query_POAmount.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                    Query_POAmount.SetRange(Query_POAmount.Parent_Category, ItemCat);
                    Query_POAmount.SetFilter(Query_POAmount.Custom_Order_Date, '%1..%2', Sdate, Edate);
                    Query_POAmount.Open();
                    while Query_POAmount.Read() do begin
                        L_DayOrderAmount += Query_POAmount.Outstanding_Amt__Ex__VAT__LCY_;
                    end;

                    #EndRegion Order Amount from PO++

                    #Region Order Amount From Recpt Line++
                    Clear(AmountFromILE);
                    L_PurchRcptLine.Reset();
                    L_PurchRcptLine.SetRange(Type, L_PurchRcptLine.Type::Item);
                    L_PurchRcptLine.SetRange("Parent Category", ItemCat);
                    //L_PurchRcptLine.SetFilter("Custom Order Date", '%1..%2', Sdate, Edate);
                    L_PurchRcptLine.SetFilter("Budget Receipt Date", '%1..%2', Sdate, Edate);
                    L_PurchRcptLine.SetFilter(Quantity, '>0');
                    if L_PurchRcptLine.FindSet() then begin
                        repeat
                            AmountFromILE := AmountFromILE + L_PurchRcptLine."Unit Cost (LCY)" * L_PurchRcptLine.Quantity;
                        until L_PurchRcptLine.Next() = 0;

                        L_DayOrderAmount += AmountFromILE;
                    end;
                    #EndRegion Order Amount From Recpt Line++

                    //Current Line Amount
                    L_OrderAmount := _PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";

                    //Calculate Ramaining amount++
                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderAmount;
                    if L_RemainingQuantity <= 0 then
                        L_RemainingQuantity := 0;

                    //++
                    CheckRemainingAmt(L_RemainingQuantity, 'ASICPMAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type", L_OrderAmount);

                    //Quota Found
                    IsQuotaExists := true;

                    //If not Error then Exit +++++
                    exit;
                end else
                    IsQuotaExists := false;
            until L_MaxOrderQty.Next() = 0;
        end else
            IsQuotaExists := false;
    end;

    procedure CheckRemainingAmt(RemAmt: Decimal; Errcode: code[20]; WarningtypeOpion: Text; _TotalMaxAmount: Decimal; _QuantityRestriction: Option "Per Day","Per Order","Per Month"; _OrderAmount: Decimal)
    var
    begin
        if _OrderAmount > RemAmt then begin
            if WarningtypeOpion = 'error' then
                Error('Remaining Amount is £%3. Maximum Amount allowed is: £%1 %2', _TotalMaxAmount, _QuantityRestriction, RemAmt)
            else begin
                Message('Remaining Amount is £%3. Maximum Amount allowed is: £%1 %2', _TotalMaxAmount, _QuantityRestriction, RemAmt);
                exit;
            end;
        end;
    end;
}