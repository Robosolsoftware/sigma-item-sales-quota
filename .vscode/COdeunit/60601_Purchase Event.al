codeunit 60601 "Purchase Order Restriction"
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        WarningtypeOpion: Text;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Line Amount', false, false)]
    local procedure LineAmountEvent(var Rec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        RecUserSetup: Record "User Setup";
    begin

        if ((Rec."Line Amount" <> 0) AND (Rec."Document Type" = Rec."Document Type"::Order)) then begin
            IF RecUserSetup.GET(USERID) THEN BEGIN
                IF NOT RecUserSetup."PO Override MaxQty Calculation" THEN BEGIN
                    CheckMaxOrderamt(Rec);
                END;
            END ELSE BEGIN
                CheckMaxOrderamt(Rec);
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Unit cost', false, false)]
    local procedure UnitPriceEvent(var Rec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        RecUserSetup: Record "User Setup";
    begin
        //NewCode Azhar++
        if ((Rec."Line Amount" <> 0) AND (Rec."Document Type" = Rec."Document Type"::Order)) then begin
            IF RecUserSetup.GET(USERID) THEN BEGIN
                IF NOT RecUserSetup."PO Override MaxQty Calculation" THEN BEGIN
                    CheckMaxOrderamt(Rec);
                END;
            END ELSE BEGIN
                CheckMaxOrderamt(Rec);
            END;
        end;
        //NewCode Azhar--
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    local procedure LineDiscountPerEvent(var Rec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        RecUserSetup: Record "User Setup";
    begin
        //NewCode Azhar++
        if ((Rec."Line Amount" <> 0) AND (Rec."Document Type" = Rec."Document Type"::Order)) then begin
            IF RecUserSetup.GET(USERID) THEN BEGIN
                IF NOT RecUserSetup."PO Override MaxQty Calculation" THEN BEGIN
                    CheckMaxOrderamt(Rec);
                END;
            END ELSE BEGIN
                CheckMaxOrderamt(Rec);
            END;
        end;
        //NewCode Azhar--
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
    local procedure LineDiscountAmtEvent(var Rec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        RecUserSetup: Record "User Setup";
    begin
        //NewCode Azhar++
        if ((Rec."Line Amount" <> 0) AND (Rec."Document Type" = Rec."Document Type"::Order)) then begin
            IF RecUserSetup.GET(USERID) THEN BEGIN
                IF NOT RecUserSetup."PO Override MaxQty Calculation" THEN BEGIN
                    CheckMaxOrderamt(Rec);
                END;
            END ELSE BEGIN
                CheckMaxOrderamt(Rec);
            END;
        end;
        //NewCode Azhar--
    end;

    procedure CheckMaxOrderamt(P_PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
        RecitemAmt: Record Item;
        CurrentMonthStartDateAmt: Date;
        CurrentYearAmt: Integer;
        currentMonthAmt: Integer;
        CurrentMonth_TextAmt: Text;
        EndDateAmt: Date;
    begin


        Clear(CurrentMonthStartDateAmt);
        Clear(EndDateAmt);
        // IF CurrFieldNoGlo <> 15 THEN
        //     EXIT;

        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("No.", P_PurchaseLine."Document No.");
        PurchaseHeader.SetRange("Document Type", P_PurchaseLine."Document Type");
        if PurchaseHeader.FindFirst() then;

        RecitemAmt.Reset();
        RecitemAmt.SetRange("No.", P_PurchaseLine."No.");
        if RecitemAmt.FindFirst() then;
        RecitemAmt.CalcFields("Parent Category");

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

        // //Per Order all 6 Validation++
        // //-------------1: All Vendor, All Item, ErrorCode(AAPOAMT)-------------
        // PerOrderAllVendorAllItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code");
        // //-------------2: All Vendor, Selected Item, ErrorCode(ASIPOAMT)-------------
        // PerOrderAllVendorSelItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code");
        // //-------------3: All Vendor, Selected Item Category, ErrorCode(ASICPOAMT)-------------
        // PerOrderAllVendorSelItemCatAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Child Category");
        // //-------------4: Selected Vendor, All Item, ErrorCode(SCAPOAMT)-------------
        // PerOrderSelVendorAllItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code");
        // //-------------5: Selected Vendor, Selected Item, ErrorCode(SCSIPOAMT)-------------
        // PerOrderSelVendorSelItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code");
        // //-------------6: Selected Vendor, Selected Item Category, ErrorCode(SCSICPOAMT)-------------
        // PerOrderSelVendorSelItemCatAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Child Category");
        // //Per Order all 6 Validation++

        // //Per Day all 6 validation++
        // //-------------1: All Vendor, All Item, ErrorCode(AAPDAMT)-------------
        // PerDayAllVendorAllItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code");
        // //-------------2: All Vendor, Selected Item, ErrorCode(ASIPDAMT)-------------
        // PerDayAllVendorSelItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code");
        // //-------------3: All Vendor, Selected Item Category, ErrorCode(ASICPDAMT)-------------
        // PerDayAllVendorSelItemCatAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Child Category");
        // //-------------4: Selected Vendor, All Item, ErrorCode(SCAPDAMT)-------------
        // PerDaySelVendorAllItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code");
        // //-------------5: Selected Vendor, Selected Item, ErrorCode(SCSIPDAMT)-------------
        // PerDaySelVendorSelItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code");
        // //-------------6: Selected Vendor, Selected Item Category, ErrorCode(SCSICPDAMT)-------
        // PerDaySelVendorSelItemCatAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Child Category");
        // //Per Day all 6 validation--

        //Per Month all 6 validation++
        //-------------1: All Customer, All Item, ErrorCode(AAPMAMT)-------------
        //PerMonthAllVendorAllItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------2: All Customer, Selected Item, ErrorCode(ASIPMAMT)-------------
        //PerMonthAllVendorSelItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------3: All Customer, Selected Item Category, ErrorCode(ASICPMAMT)-------------
        PerMonthAllVendorSelItemCatAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Parent Category", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------4: Selected Customer, All Item, ErrorCode(SCAPMAMT)-------------
        //PerMonthSelVendorAllItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------5: Selected Customer, Selected Item, ErrorCode(SCSIPMAMT)-------------
        //PerMonthSelVendorSelItemAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------6: Selected Customer, Selected Item Category, ErrorCode(SCSICPMAMT)-------
        PerMonthSelVendorSelItemCatAmt(P_PurchaseLine, PurchaseHeader, RecitemAmt."Parent Category", CurrentMonthStartDateAmt, EndDateAmt);
        //Per Month all 6 validation--

    end;

    procedure PerMonthSelVendorSelItemCatAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20]; Sdate: date; Edate: Date)
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
    begin
        Clear(L_DayOrderAmount);
        Clear(L_RemainingQuantity);
        Clear(L_OrderAmount);
        Clear(WarningtypeOpion);

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
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                if (L_MaxOrderQty."Start Date" <= _PurchaseHeader."Order Date") and (L_MaxOrderQty."End Date" >= _PurchaseHeader."Order Date") then begin

                    //Calculate Existing Order Amount++
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", _PurchaseLine."Document Type");
                    PurchaseLine.SetFilter("Document No.", '<>%1', _PurchaseLine."Document No.");
                    //PurchaseLine.SetRange("Buy-from Vendor No.", _PurchaseHeader."Buy-from Vendor No.");
                    PurchaseLine.SetRange("Parent Category", ItemCat);
                    PurchaseLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    if PurchaseLine.FindSet() then begin
                        PurchaseLine.CalcSums("Outstanding Amt. Ex. VAT (LCY)");
                        L_DayOrderAmount += PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";
                    end;

                    //Calculate Same Order Amount but if same item in Different line++
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", _PurchaseLine."Document Type");
                    PurchaseLine.SetRange("Document No.", _PurchaseLine."Document No.");
                    PurchaseLine.SetFilter("Line No.", '<>%1', _PurchaseLine."Line No.");
                    //PurchaseLine.SetRange("Buy-from Vendor No.", _PurchaseHeader."Buy-from Vendor No.");
                    PurchaseLine.SetRange("Parent Category", ItemCat);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                    if PurchaseLine.FindSet() then begin
                        PurchaseLine.CalcSums("Outstanding Amt. Ex. VAT (LCY)");
                        L_DayOrderAmount += PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";
                    end;

                    //Calculate Posted  Document Amount++
                    // PurchInvLine.Reset();
                    // PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
                    // PurchInvLine.SetRange("Parent Category", ItemCat);
                    // //PurchInvLine.SetRange("Buy-from Vendor No.", _PurchaseLine."Buy-from Vendor No.");
                    // PurchInvLine.CalcFields("Order Date");
                    // PurchInvLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                    // if PurchInvLine.FindSet() then begin
                    //     PurchInvLine.CalcSums(Amount);
                    //     L_DayOrderAmount += PurchInvLine.Amount;
                    // end;
                    Clear(AmountFromILE);
                    L_ILE.Reset();
                    L_ILE.SetRange("Entry Type", L_ILE."Entry Type"::Purchase);
                    L_ILE.SetRange("Document Type", L_ILE."Document Type"::"Purchase Receipt");
                    L_ILE.SetRange("Parent Category", ItemCat);
                    // L_ILE.SetFilter("Posting Date", '%1..%2', Sdate, Edate);
                    if L_ILE.FindSet() then begin
                        repeat
                            PurchRcptHeader.Reset();
                            PurchRcptHeader.SetRange("No.", L_ILE."Document No.");
                            if PurchRcptHeader.FindFirst() then begin
                                if PurchRcptHeader."Order Date" in [Sdate .. Edate] then begin
                                    L_ILE.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                                    AmountFromILE := AmountFromILE + (L_ILE."Cost Amount (Actual)" + L_ILE."Cost Amount (Expected)");
                                end;
                            end;
                        until L_ILE.Next() = 0;

                        L_DayOrderAmount += AmountFromILE;
                    end;

                    //Current Line Amount
                    L_OrderAmount := _PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";

                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderAmount;
                    if L_RemainingQuantity <= 0 then
                        L_RemainingQuantity := 0;

                    CheckRemainingAmt(L_RemainingQuantity, 'ASICPMAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type", L_OrderAmount);

                    //If not Error then Exit +++++
                    exit;
                end;
            until L_MaxOrderQty.Next() = 0;
        end;
    end;

    procedure PerMonthSelVendorSelItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20]; Sdate: date; Edate: Date)
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", _PurchaseLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            if (L_MaxOrderQty."Start Date" <= _PurchaseHeader."Order Date") and (L_MaxOrderQty."End Date" >= _PurchaseHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, _PurchaseLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, _PurchaseLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                L_DayWiseReceivedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseReceivedQty.SETRANGE(No, _PurchaseLine."No.");
                L_DayWiseReceivedQty.OPEN;
                WHILE L_DayWiseReceivedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
                END;
                L_DayWiseReceivedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecPurchaseLineNew.RESET;
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document Type", RecPurchaseLineNew."Document Type"::Order);
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document No.", _PurchaseLine."Document No.");
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."No.", _PurchaseLine."No.");
                IF RecPurchaseLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                            L_OrderQty := L_OrderQty + _PurchaseLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecPurchaseLineNew."Line Amount";

                    UNTIL RecPurchaseLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := _PurchaseLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'SCSIPMAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
            end;
        end;
    end;


    procedure PerMonthSelVendorAllItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20]; Sdate: date; Edate: Date)
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            if (L_MaxOrderQty."Start Date" <= _PurchaseHeader."Order Date") and (L_MaxOrderQty."End Date" >= _PurchaseHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, _PurchaseLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, _PurchaseLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                L_DayWiseReceivedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseReceivedQty.SETRANGE(No, _PurchaseLine."No.");
                L_DayWiseReceivedQty.OPEN;
                WHILE L_DayWiseReceivedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
                END;
                L_DayWiseReceivedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecPurchaseLineNew.RESET;
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document Type", RecPurchaseLineNew."Document Type"::Order);
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document No.", _PurchaseLine."Document No.");
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."No.", _PurchaseLine."No.");
                IF RecPurchaseLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                            L_OrderQty := L_OrderQty + _PurchaseLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecPurchaseLineNew."Line Amount";

                    UNTIL RecPurchaseLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := _PurchaseLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'SCAPMAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
            end;
        end;
    end;


    procedure PerMonthAllVendorSelItemCatAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20]; Sdate: date; Edate: Date)
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
    begin
        Clear(L_DayOrderAmount);
        Clear(L_RemainingQuantity);
        Clear(L_OrderAmount);
        Clear(WarningtypeOpion);

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
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                if (L_MaxOrderQty."Start Date" <= _PurchaseHeader."Order Date") and (L_MaxOrderQty."End Date" >= _PurchaseHeader."Order Date") then begin

                    //Calculate Existing Order Amount++
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", _PurchaseLine."Document Type");
                    PurchaseLine.SetFilter("Document No.", '<>%1', _PurchaseLine."Document No.");
                    //PurchaseLine.SetRange("Buy-from Vendor No.", _PurchaseHeader."Buy-from Vendor No.");
                    PurchaseLine.SetRange("Parent Category", ItemCat);
                    PurchaseLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    if PurchaseLine.FindSet() then begin
                        PurchaseLine.CalcSums("Outstanding Amt. Ex. VAT (LCY)");
                        L_DayOrderAmount += PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";
                    end;

                    //Calculate Same Order Amount but if same item in Different line++
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", _PurchaseLine."Document Type");
                    PurchaseLine.SetRange("Document No.", _PurchaseLine."Document No.");
                    PurchaseLine.SetFilter("Line No.", '<>%1', _PurchaseLine."Line No.");
                    //PurchaseLine.SetRange("Buy-from Vendor No.", _PurchaseHeader."Buy-from Vendor No.");
                    PurchaseLine.SetRange("Parent Category", ItemCat);
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    PurchaseLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                    if PurchaseLine.FindSet() then begin
                        PurchaseLine.CalcSums("Outstanding Amt. Ex. VAT (LCY)");
                        L_DayOrderAmount += PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";
                    end;

                    //Calculate Posted  Document Amount++
                    // PurchInvLine.Reset();
                    // PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
                    // PurchInvLine.SetRange("Parent Category", ItemCat);
                    // //PurchInvLine.SetRange("Buy-from Vendor No.", _PurchaseLine."Buy-from Vendor No.");
                    // PurchInvLine.CalcFields("Order Date");
                    // PurchInvLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                    // if PurchInvLine.FindSet() then begin
                    //     PurchInvLine.CalcSums(Amount);
                    //     L_DayOrderAmount += PurchInvLine.Amount;
                    // end;
                    Clear(AmountFromILE);
                    L_ILE.Reset();
                    L_ILE.SetRange("Entry Type", L_ILE."Entry Type"::Purchase);
                    L_ILE.SetRange("Document Type", L_ILE."Document Type"::"Purchase Receipt");
                    L_ILE.SetRange("Parent Category", ItemCat);
                    // L_ILE.SetFilter("Posting Date", '%1..%2', Sdate, Edate);
                    if L_ILE.FindSet() then begin
                        repeat
                            PurchRcptHeader.Reset();
                            PurchRcptHeader.SetRange("No.", L_ILE."Document No.");
                            if PurchRcptHeader.FindFirst() then begin
                                if PurchRcptHeader."Order Date" in [Sdate .. Edate] then begin
                                    L_ILE.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                                    AmountFromILE := AmountFromILE + (L_ILE."Cost Amount (Actual)" + L_ILE."Cost Amount (Expected)");
                                end;
                            end;
                        until L_ILE.Next() = 0;

                        L_DayOrderAmount += AmountFromILE;
                    end;



                    //Current Line Amount
                    L_OrderAmount := _PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";

                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderAmount;
                    if L_RemainingQuantity <= 0 then
                        L_RemainingQuantity := 0;

                    CheckRemainingAmt(L_RemainingQuantity, 'ASICPMAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type", L_OrderAmount);

                    //If not Error then Exit +++++
                    exit;
                end;
            until L_MaxOrderQty.Next() = 0;
        End;
    end;

    procedure PerMonthAllVendorSelItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20]; Sdate: date; Edate: Date)
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::"All Vendor");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", _PurchaseLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            if (L_MaxOrderQty."Start Date" <= _PurchaseHeader."Order Date") and (L_MaxOrderQty."End Date" >= _PurchaseHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, _PurchaseLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, _PurchaseLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                L_DayWiseReceivedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseReceivedQty.SETRANGE(No, _PurchaseLine."No.");
                L_DayWiseReceivedQty.OPEN;
                WHILE L_DayWiseReceivedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
                END;
                L_DayWiseReceivedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecPurchaseLineNew.RESET;
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document Type", RecPurchaseLineNew."Document Type"::Order);
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document No.", _PurchaseLine."Document No.");
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."No.", _PurchaseLine."No.");
                IF RecPurchaseLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                            L_OrderQty := L_OrderQty + _PurchaseLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecPurchaseLineNew."Line Amount";

                    UNTIL RecPurchaseLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := _PurchaseLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'ASIPMAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
            end;
        End;
    end;

    procedure PerMonthAllVendorAllItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20]; Sdate: date; Edate: Date)
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::"All Vendor");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            if (L_MaxOrderQty."Start Date" <= _PurchaseHeader."Order Date") and (L_MaxOrderQty."End Date" >= _PurchaseHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, _PurchaseLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, _PurchaseLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
                L_DayWiseReceivedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseReceivedQty.SETRANGE(No, _PurchaseLine."No.");
                L_DayWiseReceivedQty.OPEN;
                WHILE L_DayWiseReceivedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
                END;
                L_DayWiseReceivedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecPurchaseLineNew.RESET;
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document Type", RecPurchaseLineNew."Document Type"::Order);
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document No.", _PurchaseLine."Document No.");
                RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."No.", _PurchaseLine."No.");
                IF RecPurchaseLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                            L_OrderQty := L_OrderQty + _PurchaseLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecPurchaseLineNew."Line Amount";

                    UNTIL RecPurchaseLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := _PurchaseLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'AAPMAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
            end;
        end;
    end;



    procedure PerDaySelVendorSelItemCatAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(L_DayWiseQty.Document_Type, _PurchaseLine."Document Type");
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Order_Date, _PurchaseHeader."Order Date");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Amount but if same item in Different line++
            L_DayWiseQty.SetRange(L_DayWiseQty.Document_Type, _PurchaseLine."Document Type");
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, _PurchaseLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', _PurchaseLine."Line No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Order_Date, _PurchaseHeader."Order Date");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Posted Amount++
            L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Order_Date, _PurchaseHeader."Order Date");
            L_DayWiseReceivedQty.SetRange(L_DayWiseReceivedQty.Item_Category_Code, ItemCat);
            L_DayWiseReceivedQty.OPEN;
            WHILE L_DayWiseReceivedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
            END;
            L_DayWiseReceivedQty.CLOSE;

            //Current Amount++
            L_OrderQty := _PurchaseLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCSICPDAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;

    procedure PerDaySelVendorSelItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", _PurchaseLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            L_DayWiseQty.SetRange(Document_Type, _PurchaseLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, _PurchaseLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseReceivedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseReceivedQty.SETRANGE(No, _PurchaseLine."No.");
            L_DayWiseReceivedQty.OPEN;
            WHILE L_DayWiseReceivedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
            END;
            L_DayWiseReceivedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document Type", RecPurchaseLineNew."Document Type"::Order);
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."No.", _PurchaseLine."No.");
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                        L_OrderQty := L_OrderQty + _PurchaseLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecPurchaseLineNew."Line Amount";

                UNTIL RecPurchaseLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := _PurchaseLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCSIPDAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;


    procedure PerDaySelVendorAllItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            L_DayWiseQty.SetRange(Document_Type, _PurchaseLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, _PurchaseLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseReceivedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseReceivedQty.SETRANGE(No, _PurchaseLine."No.");
            L_DayWiseReceivedQty.OPEN;
            WHILE L_DayWiseReceivedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
            END;
            L_DayWiseReceivedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document Type", RecPurchaseLineNew."Document Type"::Order);
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."No.", _PurchaseLine."No.");
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                        L_OrderQty := L_OrderQty + _PurchaseLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecPurchaseLineNew."Line Amount";

                UNTIL RecPurchaseLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := _PurchaseLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCAPDAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;

    procedure PerDayAllVendorSelItemCatAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::"All Vendor");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(L_DayWiseQty.Document_Type, _PurchaseLine."Document Type");
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Order_Date, _PurchaseHeader."Order Date");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(L_DayWiseQty.Document_Type, _PurchaseLine."Document Type");
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, _PurchaseLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', _PurchaseLine."Line No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Order_Date, _PurchaseHeader."Order Date");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;


            //Calculate Posted Amount++
            L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Order_Date, _PurchaseHeader."Order Date");
            L_DayWiseReceivedQty.SetRange(L_DayWiseReceivedQty.Item_Category_Code, ItemCat);
            L_DayWiseReceivedQty.OPEN;
            WHILE L_DayWiseReceivedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
            END;
            L_DayWiseReceivedQty.CLOSE;

            //Current Amount++
            L_OrderQty := _PurchaseLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'ASICPDAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;


    procedure PerDayAllVendorSelItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::"All Vendor");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", _PurchaseLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            L_DayWiseQty.SetRange(Document_Type, _PurchaseLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, _PurchaseLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseReceivedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseReceivedQty.SETRANGE(No, _PurchaseLine."No.");
            L_DayWiseReceivedQty.OPEN;
            WHILE L_DayWiseReceivedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
            END;
            L_DayWiseReceivedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document Type", RecPurchaseLineNew."Document Type"::Order);
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."No.", _PurchaseLine."No.");
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                        L_OrderQty := L_OrderQty + _PurchaseLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecPurchaseLineNew."Line Amount";

                UNTIL RecPurchaseLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := _PurchaseLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'ASIPDAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;

    procedure PerDayAllVendorAllItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60604;
        L_DayWiseReceivedQty: Query 60605;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::"All Vendor");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            L_DayWiseQty.SetRange(Document_Type, _PurchaseLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', _PurchaseLine."Document No.");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, _PurchaseLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseReceivedQty.SETRANGE(L_DayWiseReceivedQty.Buy_from_Vendor_No_, _PurchaseLine."Buy-from Vendor No.");
            L_DayWiseReceivedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseReceivedQty.SETRANGE(No, _PurchaseLine."No.");
            L_DayWiseReceivedQty.OPEN;
            WHILE L_DayWiseReceivedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseReceivedQty.Sum_Amt;
            END;
            L_DayWiseReceivedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document Type", RecPurchaseLineNew."Document Type"::Order);
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SETRANGE(RecPurchaseLineNew."No.", _PurchaseLine."No.");
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                        L_OrderQty := L_OrderQty + _PurchaseLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecPurchaseLineNew."Line Amount";

                UNTIL RecPurchaseLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := _PurchaseLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'AAPDAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;

    procedure PerOrderAllVendorAllItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderAmt: Decimal;
        L_RemainingAmt: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderAmt: Decimal;

    begin
        Clear(L_DayOrderAmt);
        Clear(L_RemainingAmt);
        Clear(L_OrderAmt);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::"All Vendor");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE("Document Type", _PurchaseLine."Document Type");
            RecPurchaseLineNew.SETRANGE("Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SETRANGE("No.", _PurchaseLine."No.");
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                        L_DayOrderAmt := L_DayOrderAmt + _PurchaseLine."Line Amount"
                    ELSE
                        L_DayOrderAmt := L_DayOrderAmt + RecPurchaseLineNew."Line Amount";
                UNTIL RecPurchaseLineNew.NEXT = 0;
            END
            ELSE
                L_OrderAmt := _PurchaseLine."Line Amount";

            L_RemainingAmt := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderAmt + L_OrderAmt);
            CheckingRemainingAmt(L_RemainingAmt, 'AAPOAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;

    procedure PerOrderAllVendorSelItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderAmt: Record 60602;
        L_DayOrderAmt: Decimal;
        L_RemainingAmt: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderAmt: Decimal;
    begin
        Clear(L_DayOrderAmt);
        Clear(L_RemainingAmt);
        Clear(L_OrderAmt);
        Clear(WarningtypeOpion);
        L_MaxOrderAmt.RESET;
        L_MaxOrderAmt.SETRANGE("Purchase Type", L_MaxOrderAmt."Purchase Type"::"All Vendor");
        L_MaxOrderAmt.SetRange("Item Type", L_MaxOrderAmt."Item Type"::Item);
        L_MaxOrderAmt.SetRange("Item Code", _PurchaseLine."No.");
        L_MaxOrderAmt.SetRange("Quantity Restriction", L_MaxOrderAmt."Quantity Restriction"::"Per Order");
        L_MaxOrderAmt.SetRange("Restriction Type", L_MaxOrderAmt."Restriction Type"::"By Amount");
        L_MaxOrderAmt.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderAmt.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderAmt."Warning Type");
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE("Document Type", _PurchaseLine."Document Type");
            RecPurchaseLineNew.SETRANGE("Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SETRANGE("No.", _PurchaseLine."No.");
            RecPurchaseLineNew.SetRange(Type, RecPurchaseLineNew.Type::Item);
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                        L_DayOrderAmt := L_DayOrderAmt + _PurchaseLine."Line Amount"
                    ELSE
                        L_DayOrderAmt := L_DayOrderAmt + RecPurchaseLineNew."Line Amount";
                UNTIL RecPurchaseLineNew.NEXT = 0;
            END
            ELSE
                L_OrderAmt := _PurchaseLine."Line Amount";

            L_RemainingAmt := L_MaxOrderAmt."Maximum Quantity" - (L_DayOrderAmt + L_OrderAmt);
            CheckingRemainingAmt(L_RemainingAmt, 'ASIPOAMT', WarningtypeOpion, L_MaxOrderAmt."Maximum Quantity", L_MaxOrderAmt."Restriction Type");
        end;
    end;

    procedure PerOrderAllVendorSelItemCatAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        RecItem: Record Item;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::"All Vendor");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Same Order but Different line++
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE("Document Type", _PurchaseLine."Document Type");
            RecPurchaseLineNew.SETRANGE("Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SetRange(Type, RecPurchaseLineNew.Type::Item);
            RecPurchaseLineNew.SetRange("Child Category", ItemCat);
            RecPurchaseLineNew.SetFilter("Line No.", '<>%1', _PurchaseLine."Line No.");
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                RecPurchaseLineNew.CalcSums("Line Amount");
                L_DayOrderQty := RecPurchaseLineNew."Line Amount";
            END;

            //Current Line++
            L_OrderQty := _PurchaseLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'ASICPOAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;

    procedure PerOrderSelVendorAllItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE("Document Type", _PurchaseLine."Document Type");
            RecPurchaseLineNew.SETRANGE("Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SETRANGE("No.", _PurchaseLine."No.");
            RecPurchaseLineNew.SetRange(Type, RecPurchaseLineNew.Type::Item);
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                        L_DayOrderQty := L_DayOrderQty + _PurchaseLine."Line Amount"
                    ELSE
                        L_DayOrderQty := L_DayOrderQty + RecPurchaseLineNew."Line Amount";
                UNTIL RecPurchaseLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := _PurchaseLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCAPOAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;

    procedure PerOrderSelVendorSelItemAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", _PurchaseLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE("Document Type", _PurchaseLine."Document Type");
            RecPurchaseLineNew.SETRANGE("Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SETRANGE("No.", _PurchaseLine."No.");
            RecPurchaseLineNew.SetRange(Type, RecPurchaseLineNew.Type::Item);
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecPurchaseLineNew."Line No." = _PurchaseLine."Line No." THEN
                        L_DayOrderQty := L_DayOrderQty + _PurchaseLine."Line Amount"
                    ELSE
                        L_DayOrderQty := L_DayOrderQty + RecPurchaseLineNew."Line Amount";
                UNTIL RecPurchaseLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := _PurchaseLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCSIPOAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;

    procedure PerOrderSelVendorSelItemCatAmt(_PurchaseLine: Record "Purchase Line"; _PurchaseHeader: Record "Purchase Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60602;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecPurchaseLineNew: Record "Purchase Line";
        L_OrderQty: Decimal;
        RecItem: Record Item;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Purchase Type", L_MaxOrderQty."Purchase Type"::Vendor);
        L_MaxOrderQty.SetRange("Purchase Code", _PurchaseLine."Buy-from Vendor No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Same Order but Different line++
            RecPurchaseLineNew.RESET;
            RecPurchaseLineNew.SETRANGE("Document Type", _PurchaseLine."Document Type");
            RecPurchaseLineNew.SETRANGE("Document No.", _PurchaseLine."Document No.");
            RecPurchaseLineNew.SetRange(Type, RecPurchaseLineNew.Type::Item);
            RecPurchaseLineNew.SetRange("Child Category", ItemCat);
            RecPurchaseLineNew.SetFilter("Line No.", '<>%1', _PurchaseLine."Line No.");
            IF RecPurchaseLineNew.FINDSET THEN BEGIN
                RecPurchaseLineNew.CalcSums("Line Amount");
                L_DayOrderQty := RecPurchaseLineNew."Line Amount";
            END;

            //Current Line++
            L_OrderQty := _PurchaseLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCSICPOAMT', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Restriction Type");
        end;
    end;


    procedure CheckingRemainingAmt(RemAmt: Decimal; Errcode: code[20]; WarningtypeOpion: Text; _TotalMaxQuantity: Decimal; _QuantityRestriction: Option "Per Day","Per Order","Per Month")
    var
    begin
        IF RemAmt < 0 THEN
            if WarningtypeOpion = 'error' then
                Error('Maximum amount %1  %2 allowed has been exceeded.', _TotalMaxQuantity, _QuantityRestriction)
            else
                Message('Maximum amount %1  %2 allowed has been exceeded.', _TotalMaxQuantity, _QuantityRestriction);
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