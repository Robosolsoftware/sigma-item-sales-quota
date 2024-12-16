codeunit 60600 "All Event"
{
    trigger OnRun()
    begin
    end;


    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Amount', false, false)]
    // local procedure LineAmountEvent(var Rec: Record "Sales Line"; CurrFieldNo: Integer)
    // begin
    //     //NewCode Azhar++
    //     if Rec."Line Amount" <> 0 then begin
    //         IF RecUserSetup.GET(USERID) THEN BEGIN
    //             IF NOT RecUserSetup."SO Override MaxQty Calculation" THEN BEGIN
    //                 CheckMaxOrderamt(Rec);
    //             END;
    //         END ELSE BEGIN
    //             CheckMaxOrderamt(Rec);
    //         END;
    //     end;
    //     //NewCode Azhar--
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit Price', false, false)]
    // local procedure UnitPriceEvent(var Rec: Record "Sales Line"; CurrFieldNo: Integer)
    // begin
    //     //NewCode Azhar++
    //     if Rec."Line Amount" <> 0 then begin
    //         IF RecUserSetup.GET(USERID) THEN BEGIN
    //             IF NOT RecUserSetup."SO Override MaxQty Calculation" THEN BEGIN
    //                 CheckMaxOrderamt(Rec);
    //             END;
    //         END ELSE BEGIN
    //             CheckMaxOrderamt(Rec);
    //         END;
    //     end;
    //     //NewCode Azhar--
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount %', false, false)]
    // local procedure LineDiscountPerEvent(var Rec: Record "Sales Line"; CurrFieldNo: Integer)
    // begin
    //     //NewCode Azhar++
    //     if Rec."Line Amount" <> 0 then begin
    //         IF RecUserSetup.GET(USERID) THEN BEGIN
    //             IF NOT RecUserSetup."SO Override MaxQty Calculation" THEN BEGIN
    //                 CheckMaxOrderamt(Rec);
    //             END;
    //         END ELSE BEGIN
    //             CheckMaxOrderamt(Rec);
    //         END;
    //     end;
    //     //NewCode Azhar--
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Discount Amount', false, false)]
    // local procedure LineDiscountAmtEvent(var Rec: Record "Sales Line"; CurrFieldNo: Integer)
    // begin
    //     //NewCode Azhar++
    //     if Rec."Line Amount" <> 0 then begin
    //         IF RecUserSetup.GET(USERID) THEN BEGIN
    //             IF NOT RecUserSetup."SO Override MaxQty Calculation" THEN BEGIN
    //                 CheckMaxOrderamt(Rec);
    //             END;
    //         END ELSE BEGIN
    //             CheckMaxOrderamt(Rec);
    //         END;
    //     end;
    //     //NewCode Azhar--
    // end;

    var
        myInt: Integer;
        G_CurrFieldNoGlo: Integer;
        MaximumOrderQuantity: Record "Sales Quota";
        RecUserSetup: Record "User Setup";

    //Azhar++
    procedure CheckMaxOrderQty2(var P_SalesLine: Record 37)
    var
        SalesHeader: Record "Sales Header";
        Recitem: Record Item;
        CurrentMonthStartDate: Date;
        CurrentYear: Integer;
        currentMonth: Integer;
        CurrentMonth_Text: Text;
        EndDate: Date;
    begin
        Clear(G_CurrFieldNoGlo);
        Clear(CurrentMonthStartDate);
        Clear(EndDate);

        SalesHeader.Reset();
        SalesHeader.SetRange("No.", P_SalesLine."Document No.");
        if SalesHeader.FindFirst() then;

        Recitem.Reset();
        Recitem.SetRange("No.", P_SalesLine."No.");
        if Recitem.FindFirst() then;

        //StartDateEndDateCalculation
        currentMonth := Date2DMY(SalesHeader."Order Date", 2);
        CurrentYear := Date2DMY(SalesHeader."Order Date", 3);
        if currentMonth > 9 then
            CurrentMonth_Text := Format(currentMonth)
        else
            CurrentMonth_Text := '0' + Format(currentMonth);
        Evaluate(CurrentMonthStartDate, '01' + CurrentMonth_Text + Format(CurrentYear));
        //CurrentMonthStartDate--

        //EndDate++
        EndDate := CalcDate('+1M', CurrentMonthStartDate);
        EndDate := CalcDate('-1D', EndDate);
        //EndDate--

        //Exception Per Day all 12 Validation++
        //-------------1: Selected Customer, Selected Item, ErrorCode(SCSIPOQ)-------------
        if ExceptionPerDaySelCustomerSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------2: Selected Customer, All Item, ErrorCode(SCAPDQ)-------------
        if ExceptionPerDaySelCustomerAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------3: Selected Customer, Selected Item Category, ErrorCode(SCSICPDQ)-------
        If ExceptionPerDaySelCustomerSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //As discussed with Customer(Dipesh) - Exception per day only work for sales type customer+++++++
        // //-------------4: Selected Dimension, Selected Item, ErrorCode(SCAPOQ)-------------
        // If ExceptionPerDaySelDimensionSelItem(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        // //-------------5: Selected Dimension, All Item, ErrorCode(SCAPOQ)-------------
        // if ExceptionPerDaySelDimensionAllItem(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        // //-------------6: Selected Dimension, Selected Item Category, ErrorCode(SCSICPOQ)-------------
        // if ExceptionPerDaySelDimensionSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        // //-------------7: All Customer, Selected Item, ErrorCode(ASIPDQ)-------------
        // if ExceptionPerDayAllCustomerSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        // //-------------8: All Customer, All Item, ErrorCode(AAPDQ)-------------
        // if ExceptionPerDayAllCustomerAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        // //-------------9: All Customer, Selected Item Category, ErrorCode(ASICPDQ)-------------
        // if ExceptionPerDayAllCustomerSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        // //-------------10: Selected Customer Price Group, Selected Item, ErrorCode(SCGSIPDQ)-------
        // if ExceptionPerDaySelCustomerGroupSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        // //-------------11: Selected Customer Price Group, All Item, ErrorCode(SCGAPDQ)-------------
        // If ExceptionPerDaySelCustomerGroupAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        // //-------------12: Selected Customer Price Group, Selected Item Category, ErrorCode(SCGSICPOQ)-------------
        // if ExceptionPerDaySelCustomerGroupSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
        //     exit;
        //As discussed with Customer(Dipesh) - Exception per day only work for sales type customer+++++++
        // //Exception Per Day all 12 Validation++



        //Per Order all 12 Validation++
        //-------------1: Selected Customer, Selected Item, ErrorCode(SCSIPOQ)-------------
        if PerOrderSelCustomerSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") = true then
            exit;
        //-------------2: Selected Customer, All Item, ErrorCode(SCAPOQ)-------------
        if PerOrderSelCustomerAllItem(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------3: Selected Customer, Selected Item Category, ErrorCode(SCSICPOQ)-------------
        if PerOrderSelCustomerSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------4: Selected Dimension, Selected Item, ErrorCode(SCAPOQ)-------------
        if PerOrderSelDimensionSelItem(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------5: Selected Dimension, All Item, ErrorCode(SCAPOQ)-------------
        if PerOrderSelDimensionAllItem(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------6: Selected Dimension, Selected Item Category, ErrorCode(SCSICPOQ)-------------
        if PerOrderSelDimensionSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------7: All Customer, Selected Item, ErrorCode(ASIPOQ)-------------
        if PerOrderAllCustomerSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------8: All Customer, All Item, ErrorCode(AAPOQ)-------------
        if PerOrderAllCustomerAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------9: All Customer, Selected Item Category, ErrorCode(ASICPOQ)-------------
        if PerOrderAllCustomerSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------10: Selected Customer Price Group, Selected Item, ErrorCode(SCGSIPOQ)-------------
        if PerOrderSelCustomerGroupSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------11: Selected Customer Price Group, All Item, ErrorCode(SCGAPOQ)-------------
        if PerOrderSelCustomerGroupAllItem(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------12: Selected Customer Price Group, Selected Item Category, ErrorCode(SCGSICPOQ)-------------
        if PerOrderSelCustomerGroupSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //Per Order all 12 Validation--


        //Per Day all 12 validation++
        //-------------1: Selected Customer, Selected Item, ErrorCode(SCSIPDQ)-------------
        if PerDaySelCustomerSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------2: Selected Customer, All Item, ErrorCode(SCAPDQ)-------------
        If PerDaySelCustomerAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------3: Selected Customer, Selected Item Category, ErrorCode(SCSICPDQ)-------
        If PerDaySelCustomerSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------4: Selected Dimension, Selected Item, ErrorCode(SCAPOQ)-------------
        if PerDaySelDimensionSelItem(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------5: Selected Dimension, All Item, ErrorCode(SCAPOQ)-------------
        if PerDaySelDimensionAllItem(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------6: Selected Dimension, Selected Item Category, ErrorCode(SCSICPOQ)-------------
        if PerDaySelDimensionSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------7: All Customer, Selected Item, ErrorCode(ASIPDQ)-------------
        If PerDayAllCustomerSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------8: All Customer, All Item, ErrorCode(AAPDQ)-------------
        if PerDayAllCustomerAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------9: All Customer, Selected Item Category, ErrorCode(ASICPDQ)-------------
        if PerDayAllCustomerSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------10: Selected Customer Price Group, Selected Item, ErrorCode(SCGSIPDQ)-------
        If PerDaySelCustomerGroupSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------11: Selected Customer Price Group, All Item, ErrorCode(SCGAPDQ)-------------
        if PerDaySelCustomerGroupAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //-------------12: Selected Customer Price Group, Selected Item Category, ErrorCode(SCGSICPOQ)-------------
        if PerDaySelCustomerGroupSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code") then
            exit;
        //Per Day all 12 validation++



        //Per Month all 12 validation++
        //-------------1: Selected Customer, Selected Item, ErrorCode(SCSIPMQ)-------------
        if PerMonthSelCustomerSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------2: Selected Customer, All Item, ErrorCode(SCAPMQ)-------------
        if PerMonthSelCustomerAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------3: Selected Customer, Selected Item Category, ErrorCode(SCSICPMQ)-------
        if PerMonthSelCustomerSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------4: Selected Dimension, Selected Item, ErrorCode(SCSIPMQ)-------------
        if PerMonthSelDimensionSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------5: Selected Dimension, All Item, ErrorCode(SCAPMQ)-------------
        if PerMonthSelDimensionAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------6: Selected Dimension, Selected Item Category, ErrorCode(SCSICPMQ)-------
        if PerMonthSelDimensionSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------7: All Customer, Selected Item, ErrorCode(ASIPMQ)-------------
        if PerMonthAllCustomerSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------8: All Customer, All Item, ErrorCode(AAPMQ)-------------
        if PerMonthAllCustomerAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------9: All Customer, Selected Item Category, ErrorCode(ASICPMQ)-------------
        if PerMonthAllCustomerSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------10: Selected Customer Price Group, Selected Item, ErrorCode(SCGSIPMQ)-------
        if PerMonthSelCustomerGroupSelItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------11: Selected Customer Price Group, All Item, ErrorCode(SCGAPMQ)-------------
        if PerMonthSelCustomerGroupAllItemQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //-------------12: Selected Customer Price Group, Selected Item Category, ErrorCode(SCGSICPMQ)-------------
        if PerMonthSelCustomerGroupSelItemCatQty(P_SalesLine, SalesHeader, Recitem."Item Category Code", CurrentMonthStartDate, EndDate) then
            exit;
        //Per Month all 12 validation--
    end;

    procedure CheckMaxOrderamt(P_SalesLine: Record 37)
    var
        SalesHeaderAmt: Record "Sales Header";
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

        SalesHeaderAmt.Reset();
        SalesHeaderAmt.SetRange("No.", P_SalesLine."Document No.");
        if SalesHeaderAmt.FindFirst() then;

        RecitemAmt.Reset();
        RecitemAmt.SetRange("No.", P_SalesLine."No.");
        if RecitemAmt.FindFirst() then;

        //StartDateEndDateCalculation
        currentMonthAmt := Date2DMY(SalesHeaderAmt."Order Date", 2);
        CurrentYearAmt := Date2DMY(SalesHeaderAmt."Order Date", 3);
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



        //Per Order all 9 Validation++
        //-------------1: All Customer, All Item, ErrorCode(AAPOAMT)-------------
        PerOrderAllCustomerAllItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------2: All Customer, Selected Item, ErrorCode(ASIPOAMT)-------------
        PerOrderAllCustomerSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------3: All Customer, Selected Item Category, ErrorCode(ASICPOAMT)-------------
        PerOrderAllCustomerSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------4: Selected Customer, All Item, ErrorCode(SCAPOAMT)-------------
        PerOrderSelCustomerAllItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------5: Selected Customer, Selected Item, ErrorCode(SCSIPOAMT)-------------
        PerOrderSelCustomerSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------6: Selected Customer, Selected Item Category, ErrorCode(SCSICPOAMT)-------------
        PerOrderSelCustomerSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------7: Selected Customer Price Group, All Item, ErrorCode(SCGAPOAMT)-------------
        PerOrderSelCustomerGroupAllItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------8: Selected Customer Price Group, Selected Item, ErrorCode(SCGSIPOAMT)-------------
        PerOrderSelCustomerGroupSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------9: Selected Customer Price Group, Selected Item Category, ErrorCode(SCGSICPOAMT)-------------
        PerOrderSelCustomerGroupSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //Per Order all 9 Validation++

        //Per Day all 9 validation++
        //-------------1: All Customer, All Item, ErrorCode(AAPDAMT)-------------
        PerDayAllCustomerAllItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------2: All Customer, Selected Item, ErrorCode(ASIPDAMT)-------------
        PerDayAllCustomerSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------3: All Customer, Selected Item Category, ErrorCode(ASICPDAMT)-------------
        PerDayAllCustomerSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------4: Selected Customer, All Item, ErrorCode(SCAPDAMT)-------------
        PerDaySelCustomerAllItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------5: Selected Customer, Selected Item, ErrorCode(SCSIPDAMT)-------------
        PerDaySelCustomerSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------6: Selected Customer, Selected Item Category, ErrorCode(SCSICPDAMT)-------
        PerDaySelCustomerSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------7: Selected Customer Price Group, All Item, ErrorCode(SCGAPDAMT)-------------
        PerDaySelCustomerGroupAllItemAmt(P_SalesLine, SalesHeaderAmt, Recitemamt."Item Category Code");
        //-------------8: Selected Customer Price Group, Selected Item, ErrorCode(SCGSIPDAMT)-------
        PerDaySelCustomerGroupSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //-------------9: Selected Customer Price Group, Selected Item Category, ErrorCode(SCGSICPOAMT)-------------
        PerDaySelCustomerGroupSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code");
        //Per Day all 9 validation--

        //Per Month all 9 validation++
        //-------------1: All Customer, All Item, ErrorCode(AAPMAMT)-------------
        PerMonthAllCustomerAllItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------2: All Customer, Selected Item, ErrorCode(ASIPMAMT)-------------
        PerMonthAllCustomerSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------3: All Customer, Selected Item Category, ErrorCode(ASICPMAMT)-------------
        PerMonthAllCustomerSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------4: Selected Customer, All Item, ErrorCode(SCAPMAMT)-------------
        PerMonthSelCustomerAllItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------5: Selected Customer, Selected Item, ErrorCode(SCSIPMAMT)-------------
        PerMonthSelCustomerSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------6: Selected Customer, Selected Item Category, ErrorCode(SCSICPMAMT)-------
        PerMonthSelCustomerSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------7: Selected Customer Price Group, All Item, ErrorCode(SCGAPMAMT)-------------
        PerMonthSelCustomerGroupAllItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------8: Selected Customer Price Group, Selected Item, ErrorCode(SCGSIPMAMT)-------
        PerMonthSelCustomerGroupSelItemAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //-------------9: Selected Customer Price Group, Selected Item Category, ErrorCode(SCGSICPMAMT)-------------
        PerMonthSelCustomerGroupSelItemCatAmt(P_SalesLine, SalesHeaderAmt, RecitemAmt."Item Category Code", CurrentMonthStartDateAmt, EndDateAmt);
        //Per Month all 9 validation--

    end;

    procedure PerOrderSelDimensionSelItem(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                Clear(L_DayOrderQty);
                Clear(L_RemainingQuantity);
                Clear(L_OrderQty);
                Clear(WarningtypeOpion);

                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
                L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                    //Calculateing Existing Sales Order Quantity in Same Order++
                    ExistingSalesQuantity.RESET;
                    ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
                    ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
                    ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
                    ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
                    IF ExistingSalesQuantity.FINDSET THEN BEGIN
                        ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                        L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
                    END;

                    //L_OrderQty := RecSalesLine.Quantity;
                    L_OrderQty := RecSalesLine."Outstanding Quantity";

                    if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                        L_RemainingQuantity := 0
                    else
                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

                    Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCAPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure PerOrderSelDimensionAllItem(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                Clear(L_DayOrderQty);
                Clear(L_RemainingQuantity);
                Clear(L_OrderQty);
                Clear(WarningtypeOpion);

                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                    //Calculateing Existing Sales Order Quantity in Same Order++
                    ExistingSalesQuantity.RESET;
                    ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
                    ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
                    ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
                    ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
                    IF ExistingSalesQuantity.FINDSET THEN BEGIN
                        ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                        L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
                    END;

                    //L_OrderQty := RecSalesLine.Quantity;
                    L_OrderQty := RecSalesLine."Outstanding Quantity";

                    if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                        L_RemainingQuantity := 0
                    else
                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

                    Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCAPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure PerOrderSelDimensionSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean;
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";
        RecItem: Record Item;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                Clear(L_DayOrderQty);
                Clear(L_RemainingQuantity);
                Clear(L_OrderQty);
                Clear(WarningtypeOpion);

                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
                L_MaxOrderQty.SetRange("Item Code", ItemCat);
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                    //Calculateing Existing Sales Order Quantity in Same Order++
                    ExistingSalesQuantity.RESET;
                    ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
                    ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
                    ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
                    ExistingSalesQuantity.SETRANGE("Item Category Code", ItemCat);
                    IF ExistingSalesQuantity.FINDSET THEN BEGIN
                        ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                        L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
                    END;

                    //L_OrderQty := RecSalesLine.Quantity;
                    L_OrderQty := RecSalesLine."Outstanding Quantity";

                    if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                        L_RemainingQuantity := 0
                    else
                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

                    Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCAPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure ExceptionPerDaySelDimensionSelItem(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
                L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                        WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                        //Calculate Existing Order Quantity++++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Current Order Quantity but if same item in Different line++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Shipped Quantity+++++
                        L_SalesShipmentLine.Reset();
                        L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesShipmentLine.FindSet() then begin
                            repeat
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesShipmentLine.Quantity;
                                end;
                            until L_SalesShipmentLine.Next() = 0;
                        end;

                        //Calculate L_OrderQty Quantity++
                        //L_OrderQty := RecSalesLine.Quantity;
                        L_OrderQty := RecSalesLine."Outstanding Quantity";

                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                        if L_RemainingQuantity < 0 then
                            L_RemainingQuantity := 0;

                        Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                        if Exceeded = true then
                            exit;
                    end;
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure PerDaySelDimensionSelItem(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

        //New
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
                L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                    // //Calculate Existing Order Quantity++++
                    // L_SalesLine.Reset();
                    // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    // L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                    // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    // L_SalesLine.SetRange("No.", RecSalesLine."No.");
                    // L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesLine.FindSet() then begin
                    //     repeat
                    //         L_SaleasHeader.Reset();
                    //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                    //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                    //         if L_SaleasHeader.FindFirst() then begin
                    //             L_DimensionSetEntry.Reset();
                    //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                    //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //             if L_DimensionSetEntry.FindFirst() then begin
                    //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                    //             end;
                    //         end;
                    //     until L_SalesLine.Next() = 0;
                    // end;

                    // //Calculate Current Order Quantity but if same item in Different line++
                    // L_SalesLine.Reset();
                    // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    // L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                    // L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    // L_SalesLine.SetRange("No.", RecSalesLine."No.");
                    // L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesLine.FindSet() then begin
                    //     repeat
                    //         L_SaleasHeader.Reset();
                    //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                    //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                    //         if L_SaleasHeader.FindFirst() then begin
                    //             L_DimensionSetEntry.Reset();
                    //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                    //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //             if L_DimensionSetEntry.FindFirst() then begin
                    //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                    //             end;
                    //         end;
                    //     until L_SalesLine.Next() = 0;
                    // end;

                    // //Calculate Shipped Quantity+++++
                    // L_SalesShipmentLine.Reset();
                    // L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                    // L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                    // L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesShipmentLine.FindSet() then begin
                    //     repeat
                    //         L_DimensionSetEntry.Reset();
                    //         L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                    //         L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //         L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //         if L_DimensionSetEntry.FindFirst() then begin
                    //             L_DayOrderQty += L_SalesShipmentLine.Quantity;
                    //         end;
                    //     until L_SalesShipmentLine.Next() = 0;
                    // end;

                    //New Code added discussed with Team++
                    //Calculate Existing Order Quantity++++
                    L_SalesLine.Reset();
                    L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                    L_SalesLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                    L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    L_SalesLine.SetRange("No.", RecSalesLine."No.");
                    L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    if L_SalesLine.FindSet() then begin
                        repeat
                            L_SaleasHeader.Reset();
                            L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                            L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                            if L_SaleasHeader.FindFirst() then begin
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                end;
                            end;
                        until L_SalesLine.Next() = 0;

                    end;

                    //Calculate Current Order Quantity but if same item in Different line++
                    L_SalesLine.Reset();
                    L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                    L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    L_SalesLine.SetRange("No.", RecSalesLine."No.");
                    L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    if L_SalesLine.FindSet() then begin
                        repeat
                            L_SaleasHeader.Reset();
                            L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                            L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                            if L_SaleasHeader.FindFirst() then begin
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                end;
                            end;
                        until L_SalesLine.Next() = 0;
                    end;

                    //Calculate Shipped Quantity+++++
                    L_SalesShipmentLine.Reset();
                    L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                    L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                    L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    L_SalesShipmentLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                    if L_SalesShipmentLine.FindSet() then begin
                        repeat
                            L_DimensionSetEntry.Reset();
                            L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                            L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                            L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                            if L_DimensionSetEntry.FindFirst() then begin
                                L_DayOrderQty += L_SalesShipmentLine.Quantity;
                            end;
                        until L_SalesShipmentLine.Next() = 0;
                    end;
                    //New Code added discussed with Team--

                    //Calculate L_OrderQty Quantity++
                    //L_OrderQty := RecSalesLine.Quantity;
                    L_OrderQty := RecSalesLine."Outstanding Quantity";


                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                    if L_RemainingQuantity < 0 then
                        L_RemainingQuantity := 0;

                    Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                    if Exceeded = true then
                        exit;

                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure ExceptionPerDaySelDimensionAllItem(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

        //New
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                        WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                        //Calculate Existing Order Quantity+++++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Current Order Quantity but if same item in Different line++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Shipped Quantity++
                        L_SalesShipmentLine.Reset();
                        L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesShipmentLine.FindSet() then begin
                            repeat
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesShipmentLine.Quantity;
                                end;
                            until L_SalesShipmentLine.Next() = 0;
                        end;

                        //Calculate L_OrderQty Quantity++
                        //L_OrderQty := RecSalesLine.Quantity;
                        L_OrderQty := RecSalesLine."Outstanding Quantity";

                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                        if L_RemainingQuantity < 0 then
                            L_RemainingQuantity := 0;

                        Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                        if Exceeded = true then
                            exit;
                    end;
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure PerDaySelDimensionAllItem(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

        //New
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                    // //Calculate Existing Order Quantity+++++
                    // L_SalesLine.Reset();
                    // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    // L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                    // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    // L_SalesLine.SetRange("No.", RecSalesLine."No.");
                    // L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesLine.FindSet() then begin
                    //     repeat
                    //         L_SaleasHeader.Reset();
                    //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                    //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                    //         if L_SaleasHeader.FindFirst() then begin
                    //             L_DimensionSetEntry.Reset();
                    //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                    //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //             if L_DimensionSetEntry.FindFirst() then begin
                    //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                    //             end;
                    //         end;
                    //     until L_SalesLine.Next() = 0;
                    // end;

                    // //Calculate Current Order Quantity but if same item in Different line++
                    // L_SalesLine.Reset();
                    // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    // L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                    // L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    // L_SalesLine.SetRange("No.", RecSalesLine."No.");
                    // L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesLine.FindSet() then begin
                    //     repeat
                    //         L_SaleasHeader.Reset();
                    //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                    //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                    //         if L_SaleasHeader.FindFirst() then begin
                    //             L_DimensionSetEntry.Reset();
                    //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                    //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //             if L_DimensionSetEntry.FindFirst() then begin
                    //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                    //             end;
                    //         end;
                    //     until L_SalesLine.Next() = 0;
                    // end;

                    // //Calculate Shipped Quantity++
                    // L_SalesShipmentLine.Reset();
                    // L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                    // L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                    // L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesShipmentLine.FindSet() then begin
                    //     repeat
                    //         L_DimensionSetEntry.Reset();
                    //         L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                    //         L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //         L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //         if L_DimensionSetEntry.FindFirst() then begin
                    //             L_DayOrderQty += L_SalesShipmentLine.Quantity;
                    //         end;
                    //     until L_SalesShipmentLine.Next() = 0;
                    // end;

                    //New Code added discussed with Team++
                    //Calculate Existing Order Quantity++++
                    L_SalesLine.Reset();
                    L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                    L_SalesLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                    L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    L_SalesLine.SetRange("No.", RecSalesLine."No.");
                    L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    if L_SalesLine.FindSet() then begin
                        repeat
                            L_SaleasHeader.Reset();
                            L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                            L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                            if L_SaleasHeader.FindFirst() then begin
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                end;
                            end;
                        until L_SalesLine.Next() = 0;

                    end;

                    //Calculate Current Order Quantity but if same item in Different line++
                    L_SalesLine.Reset();
                    L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                    L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    L_SalesLine.SetRange("No.", RecSalesLine."No.");
                    L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    if L_SalesLine.FindSet() then begin
                        repeat
                            L_SaleasHeader.Reset();
                            L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                            L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                            if L_SaleasHeader.FindFirst() then begin
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                end;
                            end;
                        until L_SalesLine.Next() = 0;
                    end;

                    //Calculate Shipped Quantity+++++
                    L_SalesShipmentLine.Reset();
                    L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                    L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                    L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    L_SalesShipmentLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                    if L_SalesShipmentLine.FindSet() then begin
                        repeat
                            L_DimensionSetEntry.Reset();
                            L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                            L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                            L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                            if L_DimensionSetEntry.FindFirst() then begin
                                L_DayOrderQty += L_SalesShipmentLine.Quantity;
                            end;
                        until L_SalesShipmentLine.Next() = 0;
                    end;
                    //New Code added discussed with Team--

                    //Calculate L_OrderQty Quantity++
                    //L_OrderQty := RecSalesLine.Quantity;
                    L_OrderQty := RecSalesLine."Outstanding Quantity";

                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                    if L_RemainingQuantity < 0 then
                        L_RemainingQuantity := 0;

                    Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                    if Exceeded = true then
                        exit;
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure ExceptionPerDaySelDimensionSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean;
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

        //New
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
                L_MaxOrderQty.SetRange("Item Code", ItemCat);
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                        WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                        //Calculate Existing Order Quantity++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("Item Category Code", ItemCat);
                        L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Current Order Quantity but if same item in Different line++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("Item Category Code", ItemCat);
                        L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Shipped Quantity++
                        L_SalesShipmentLine.Reset();
                        L_SalesShipmentLine.SetRange("Item Category Code", ItemCat);
                        L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                        if L_SalesShipmentLine.FindSet() then begin
                            repeat
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesShipmentLine.Quantity;
                                end;
                            until L_SalesShipmentLine.Next() = 0;
                        end;

                        //Calculate L_OrderQty Quantity++
                        //L_OrderQty := RecSalesLine.Quantity;
                        L_OrderQty := RecSalesLine."Outstanding Quantity";

                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                        if L_RemainingQuantity < 0 then
                            L_RemainingQuantity := 0;

                        Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSICPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                        if Exceeded = true then
                            exit;
                    end;
                end;
            until L_DefaultDimension.Next() = 0
        end;
    end;

    procedure PerDaySelDimensionSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

        //New
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
                L_MaxOrderQty.SetRange("Item Code", ItemCat);
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FINDFIRST THEN BEGIN
                    WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                    // //Calculate Existing Order Quantity++
                    // L_SalesLine.Reset();
                    // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    // L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                    // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    // L_SalesLine.SetRange("Item Category Code", ItemCat);
                    // L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesLine.FindSet() then begin
                    //     repeat
                    //         L_SaleasHeader.Reset();
                    //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                    //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                    //         if L_SaleasHeader.FindFirst() then begin
                    //             L_DimensionSetEntry.Reset();
                    //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                    //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //             if L_DimensionSetEntry.FindFirst() then begin
                    //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                    //             end;
                    //         end;
                    //     until L_SalesLine.Next() = 0;
                    // end;

                    // //Calculate Current Order Quantity but if same item in Different line++
                    // L_SalesLine.Reset();
                    // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    // L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                    // L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    // L_SalesLine.SetRange("Item Category Code", ItemCat);
                    // L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesLine.FindSet() then begin
                    //     repeat
                    //         L_SaleasHeader.Reset();
                    //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                    //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                    //         if L_SaleasHeader.FindFirst() then begin
                    //             L_DimensionSetEntry.Reset();
                    //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                    //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //             if L_DimensionSetEntry.FindFirst() then begin
                    //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                    //             end;
                    //         end;
                    //     until L_SalesLine.Next() = 0;
                    // end;

                    // //Calculate Shipped Quantity++
                    // L_SalesShipmentLine.Reset();
                    // L_SalesShipmentLine.SetRange("Item Category Code", ItemCat);
                    // L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                    // L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    // if L_SalesShipmentLine.FindSet() then begin
                    //     repeat
                    //         L_DimensionSetEntry.Reset();
                    //         L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                    //         L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                    //         L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                    //         if L_DimensionSetEntry.FindFirst() then begin
                    //             L_DayOrderQty += L_SalesShipmentLine.Quantity;
                    //         end;
                    //     until L_SalesShipmentLine.Next() = 0;
                    // end;

                    //New Code added discussed with Team++
                    //Calculate Existing Order Quantity++
                    L_SalesLine.Reset();
                    L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                    L_SalesLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                    L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    L_SalesLine.SetRange("Item Category Code", ItemCat);
                    L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    if L_SalesLine.FindSet() then begin
                        repeat
                            L_SaleasHeader.Reset();
                            L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                            L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                            if L_SaleasHeader.FindFirst() then begin
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                end;
                            end;
                        until L_SalesLine.Next() = 0;
                    end;

                    //Calculate Current Order Quantity but if same item in Different line++
                    L_SalesLine.Reset();
                    L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                    L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                    L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                    L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                    L_SalesLine.SetRange("Item Category Code", ItemCat);
                    L_SalesLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    if L_SalesLine.FindSet() then begin
                        repeat
                            L_SaleasHeader.Reset();
                            L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                            L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                            if L_SaleasHeader.FindFirst() then begin
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                end;
                            end;
                        until L_SalesLine.Next() = 0;
                    end;

                    //Calculate Shipped Quantity++
                    L_SalesShipmentLine.Reset();
                    L_SalesShipmentLine.SetRange("Item Category Code", ItemCat);
                    L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                    L_SalesShipmentLine.SetRange("Order Date", RecSalesHeader."Order Date");
                    L_SalesShipmentLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                    if L_SalesShipmentLine.FindSet() then begin
                        repeat
                            L_DimensionSetEntry.Reset();
                            L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                            L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                            L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                            if L_DimensionSetEntry.FindFirst() then begin
                                L_DayOrderQty += L_SalesShipmentLine.Quantity;
                            end;
                        until L_SalesShipmentLine.Next() = 0;
                    end;
                    //New Code added discussed with Team++

                    //Calculate L_OrderQty Quantity++
                    //L_OrderQty := RecSalesLine.Quantity;
                    L_OrderQty := RecSalesLine."Outstanding Quantity";

                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                    if L_RemainingQuantity < 0 then
                        L_RemainingQuantity := 0;

                    Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSICPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                    if Exceeded = true then
                        exit;
                end;
            until L_DefaultDimension.Next() = 0
        end;
    end;

    procedure PerMonthSelDimensionSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

        //New
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
                L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FindFirst() THEN BEGIN
                    if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                        WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                        // //Calculate Existing Order Quantity++++
                        // L_SalesLine.Reset();
                        // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        // L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        // L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        // L_SalesLine.SETFILTER("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesLine.FindSet() then begin
                        //     repeat
                        //         L_SaleasHeader.Reset();
                        //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                        //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                        //         if L_SaleasHeader.FindFirst() then begin
                        //             L_DimensionSetEntry.Reset();
                        //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                        //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //             if L_DimensionSetEntry.FindFirst() then begin
                        //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                        //             end;
                        //         end;
                        //     until L_SalesLine.Next() = 0;
                        // end;

                        // //Calculate Current Order Quantity but if same item in Different line++
                        // L_SalesLine.Reset();
                        // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        // L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        // L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        // L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        // L_SalesLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesLine.FindSet() then begin
                        //     repeat
                        //         L_SaleasHeader.Reset();
                        //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                        //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                        //         if L_SaleasHeader.FindFirst() then begin
                        //             L_DimensionSetEntry.Reset();
                        //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                        //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //             if L_DimensionSetEntry.FindFirst() then begin
                        //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                        //             end;
                        //         end;
                        //     until L_SalesLine.Next() = 0;
                        // end;

                        // //Calculate Shipped Quantity++++
                        // L_SalesShipmentLine.Reset();
                        // L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                        // L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        // L_SalesShipmentLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesShipmentLine.FindSet() then begin
                        //     repeat
                        //         L_DimensionSetEntry.Reset();
                        //         L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                        //         L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //         L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //         if L_DimensionSetEntry.FindFirst() then begin
                        //             L_DayOrderQty += L_SalesShipmentLine.Quantity;
                        //         end;
                        //     until L_SalesShipmentLine.Next() = 0;
                        // end;

                        //New Code added discussed with Team++
                        //Calculate Existing Order Quantity++++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        L_SalesLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesLine.SETFILTER("Order Date", '%1..%2', Sdate, Edate);
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Current Order Quantity but if same item in Different line++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Shipped Quantity++++
                        L_SalesShipmentLine.Reset();
                        L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        L_SalesShipmentLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        L_SalesShipmentLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                        if L_SalesShipmentLine.FindSet() then begin
                            repeat
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesShipmentLine.Quantity;
                                end;
                            until L_SalesShipmentLine.Next() = 0;
                        end;
                        //New Code added discussed with Team--

                        //Calculate L_OrderQty Quantity++
                        //L_OrderQty := RecSalesLine.Quantity;
                        L_OrderQty := RecSalesLine."Outstanding Quantity";

                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                        if L_RemainingQuantity < 0 then
                            L_RemainingQuantity := 0;

                        Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                        if Exceeded = true then
                            exit;
                    end;
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure PerMonthSelDimensionAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

        //New
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FindFirst() THEN BEGIN
                    if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                        WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                        // //Calculate Existing Order Quantity++++
                        // L_SalesLine.Reset();
                        // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        // L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        // L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        // L_SalesLine.SETFILTER("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesLine.FindSet() then begin
                        //     repeat
                        //         L_SaleasHeader.Reset();
                        //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                        //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                        //         if L_SaleasHeader.FindFirst() then begin
                        //             L_DimensionSetEntry.Reset();
                        //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                        //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //             if L_DimensionSetEntry.FindFirst() then begin
                        //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                        //             end;
                        //         end;
                        //     until L_SalesLine.Next() = 0;
                        // end;

                        // //Calculate Current Order Quantity but if same item in Different line++
                        // L_SalesLine.Reset();
                        // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        // L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        // L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        // L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        // L_SalesLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesLine.FindSet() then begin
                        //     repeat
                        //         L_SaleasHeader.Reset();
                        //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                        //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                        //         if L_SaleasHeader.FindFirst() then begin
                        //             L_DimensionSetEntry.Reset();
                        //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                        //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //             if L_DimensionSetEntry.FindFirst() then begin
                        //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                        //             end;
                        //         end;
                        //     until L_SalesLine.Next() = 0;
                        // end;

                        // //Calculate Shipped Quantity++++
                        // L_SalesShipmentLine.Reset();
                        // L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                        // L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        // L_SalesShipmentLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesShipmentLine.FindSet() then begin
                        //     repeat
                        //         L_DimensionSetEntry.Reset();
                        //         L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                        //         L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //         L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //         if L_DimensionSetEntry.FindFirst() then begin
                        //             L_DayOrderQty += L_SalesShipmentLine.Quantity;
                        //         end;
                        //     until L_SalesShipmentLine.Next() = 0;
                        // end;

                        //New Code added discussed with Team++
                        //Calculate Existing Order Quantity++++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        L_SalesLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesLine.SETFILTER("Order Date", '%1..%2', Sdate, Edate);
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Current Order Quantity but if same item in Different line++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Shipped Quantity++++
                        L_SalesShipmentLine.Reset();
                        L_SalesShipmentLine.SetRange("No.", RecSalesLine."No.");
                        L_SalesShipmentLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                        L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        L_SalesShipmentLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        if L_SalesShipmentLine.FindSet() then begin
                            repeat
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesShipmentLine.Quantity;
                                end;
                            until L_SalesShipmentLine.Next() = 0;
                        end;
                        //New Code added discussed with Team--



                        //Calculate L_OrderQty Quantity++
                        //L_OrderQty := RecSalesLine.Quantity;
                        L_OrderQty := RecSalesLine."Outstanding Quantity";

                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                        if L_RemainingQuantity < 0 then
                            L_RemainingQuantity := 0;

                        Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                        if Exceeded = true then
                            exit;
                    end;
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure PerMonthSelDimensionSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
        L_DefaultDimension: Record "Default Dimension";

        //New
        L_SalesLine: Record "Sales Line";
        DefaultDimension_2: Record "Default Dimension";
        L_SaleasHeader: Record "Sales Header";
        L_DimensionSetEntry: Record "Dimension Set Entry";
        L_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_DefaultDimension.Reset();
        L_DefaultDimension.SetRange("Table ID", 18);
        L_DefaultDimension.SetRange("Parent Type", L_DefaultDimension."Parent Type"::Customer);
        L_DefaultDimension.SetRange("No.", RecSalesHeader."Sell-to Customer No.");
        if L_DefaultDimension.FindSet() then begin
            repeat
                L_MaxOrderQty.RESET;
                L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Dimension);
                L_MaxOrderQty.SetRange("Sales Code", L_DefaultDimension."Dimension Code");
                L_MaxOrderQty.SetRange("Dimension Value", L_DefaultDimension."Dimension Value Code");
                L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
                L_MaxOrderQty.SetRange("Item Code", ItemCat);
                L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
                L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
                //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
                IF L_MaxOrderQty.FindFirst() THEN BEGIN
                    if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                        WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                        // //Calculate Existing Order Quantity++++
                        // L_SalesLine.Reset();
                        // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        // L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        // L_SalesLine.SetRange("Item Category Code", ItemCat);
                        // L_SalesLine.SETFILTER("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesLine.FindSet() then begin
                        //     repeat
                        //         L_SaleasHeader.Reset();
                        //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                        //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                        //         if L_SaleasHeader.FindFirst() then begin
                        //             L_DimensionSetEntry.Reset();
                        //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                        //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //             if L_DimensionSetEntry.FindFirst() then begin
                        //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                        //             end;
                        //         end;
                        //     until L_SalesLine.Next() = 0;
                        // end;

                        // //Calculate Current Order Quantity but if same item in Different line++
                        // L_SalesLine.Reset();
                        // L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        // L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        // L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        // L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        // L_SalesLine.SetRange("Item Category Code", ItemCat);
                        // L_SalesLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesLine.FindSet() then begin
                        //     repeat
                        //         L_SaleasHeader.Reset();
                        //         L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                        //         L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                        //         if L_SaleasHeader.FindFirst() then begin
                        //             L_DimensionSetEntry.Reset();
                        //             L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                        //             L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //             L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //             if L_DimensionSetEntry.FindFirst() then begin
                        //                 L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                        //             end;
                        //         end;
                        //     until L_SalesLine.Next() = 0;
                        // end;

                        // //Calculate Shipped Quantity++++
                        // L_SalesShipmentLine.Reset();
                        // L_SalesShipmentLine.SetRange("Item Category Code", ItemCat);
                        // L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        // L_SalesShipmentLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        // if L_SalesShipmentLine.FindSet() then begin
                        //     repeat
                        //         L_DimensionSetEntry.Reset();
                        //         L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                        //         L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                        //         L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                        //         if L_DimensionSetEntry.FindFirst() then begin
                        //             L_DayOrderQty += L_SalesShipmentLine.Quantity;
                        //         end;
                        //     until L_SalesShipmentLine.Next() = 0;
                        // end;

                        //New Code added discussed with Team++
                        //Calculate Existing Order Quantity++++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SETFILTER("Document No.", '<>%1', RecSalesLine."Document No.");
                        L_SalesLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("Item Category Code", ItemCat);
                        L_SalesLine.SETFILTER("Order Date", '%1..%2', Sdate, Edate);
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Current Order Quantity but if same item in Different line++
                        L_SalesLine.Reset();
                        L_SalesLine.SetRange("Document Type", L_SalesLine."Document Type"::Order);
                        L_SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
                        L_SalesLine.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
                        L_SalesLine.SetRange(Type, L_SalesLine.Type::Item);
                        L_SalesLine.SetRange("Item Category Code", ItemCat);
                        L_SalesLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        if L_SalesLine.FindSet() then begin
                            repeat
                                L_SaleasHeader.Reset();
                                L_SaleasHeader.SetRange("Document Type", L_SalesLine."Document Type");
                                L_SaleasHeader.SetRange("No.", L_SalesLine."Document No.");
                                if L_SaleasHeader.FindFirst() then begin
                                    L_DimensionSetEntry.Reset();
                                    L_DimensionSetEntry.SetRange("Dimension Set ID", L_SaleasHeader."Dimension Set ID");
                                    L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                    L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                    if L_DimensionSetEntry.FindFirst() then begin
                                        L_DayOrderQty += L_SalesLine."Outstanding Quantity";
                                    end;
                                end;
                            until L_SalesLine.Next() = 0;
                        end;

                        //Calculate Shipped Quantity++++
                        L_SalesShipmentLine.Reset();
                        L_SalesShipmentLine.SetRange("Item Category Code", ItemCat);
                        L_SalesShipmentLine.SetRange("Sell-to Customer No.", RecSalesLine."Sell-to Customer No.");
                        L_SalesShipmentLine.SetRange(Type, L_SalesShipmentLine.Type::Item);
                        L_SalesShipmentLine.SetFilter("Order Date", '%1..%2', Sdate, Edate);
                        if L_SalesShipmentLine.FindSet() then begin
                            repeat
                                L_DimensionSetEntry.Reset();
                                L_DimensionSetEntry.SetRange("Dimension Set ID", L_SalesShipmentLine."Dimension Set ID");
                                L_DimensionSetEntry.SetRange("Dimension Code", L_DefaultDimension."Dimension Code");
                                L_DimensionSetEntry.SetRange("Dimension Value Code", L_DefaultDimension."Dimension Value Code");
                                if L_DimensionSetEntry.FindFirst() then begin
                                    L_DayOrderQty += L_SalesShipmentLine.Quantity;
                                end;
                            until L_SalesShipmentLine.Next() = 0;
                        end;
                        //New Code added discussed with Team--


                        //Calculate L_OrderQty Quantity++
                        //L_OrderQty := RecSalesLine.Quantity;
                        L_OrderQty := RecSalesLine."Outstanding Quantity";

                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                        if L_RemainingQuantity < 0 then
                            L_RemainingQuantity := 0;

                        Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSICPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                        if Exceeded = true then
                            exit;
                    end;
                end;
            until L_DefaultDimension.Next() = 0;
        end;
    end;

    procedure PerOrderAllCustomerAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.RESET;
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'AAPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure PerOrderAllCustomerSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.RESET;
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'ASIPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure PerOrderAllCustomerSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean;
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        RecItem: Record Item;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.RESET;
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            ExistingSalesQuantity.SETRANGE("Item Category Code", ItemCat);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'ASICPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure PerOrderSelCustomerAllItem(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.Reset();
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCAPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure PerOrderSelCustomerSelItemQty(Var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean;
    var
        L_MaxOrderQty: Record "Sales Quota";
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.Reset();
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure PerOrderSelCustomerSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean;
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        RecItem: Record Item;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.RESET;
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SETRANGE("Item Category Code", ItemCat);
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSICPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure PerOrderSelCustomerGroupAllItem(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.RESET;
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
            ExistingSalesQuantity.SetRange("Customer Price Group", RecSalesLine."Customer Price Group");
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGAPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure PerOrderSelCustomerGroupSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.RESET;
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
            ExistingSalesQuantity.SetRange("Customer Price Group", RecSalesLine."Customer Price Group");
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGSIPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure PerOrderSelCustomerGroupSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        RecItem: Record Item;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculateing Existing Sales Order Quantity in Same Order++
            ExistingSalesQuantity.RESET;
            ExistingSalesQuantity.SETRANGE("Document Type", RecSalesLine."Document Type");
            ExistingSalesQuantity.SETRANGE("Document No.", RecSalesLine."Document No.");
            ExistingSalesQuantity.SetFilter("Line No.", '<>%1', RecSalesLine."Line No.");
            ExistingSalesQuantity.SETRANGE("No.", RecSalesLine."No.");
            ExistingSalesQuantity.SetRange("Customer Price Group", RecSalesLine."Customer Price Group");
            ExistingSalesQuantity.SetRange(Type, ExistingSalesQuantity.Type::Item);
            ExistingSalesQuantity.SetRange("Item Category Code", ItemCat);
            IF ExistingSalesQuantity.FINDSET THEN BEGIN
                ExistingSalesQuantity.CalcSums("Outstanding Quantity");
                L_DayOrderQty := ExistingSalesQuantity."Outstanding Quantity";
            END;

            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            if L_MaxOrderQty."Maximum Quantity" < (L_DayOrderQty + L_OrderQty) then
                L_RemainingQuantity := 0
            else
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity";

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGSICPOQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", (L_DayOrderQty + L_OrderQty), RecSalesLine);
        end;
    end;

    procedure ExceptionPerDayAllCustomerAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'AAPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerDayAllCustomerAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;

            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'AAPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;


    procedure ExceptionPerDayAllCustomerSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'ASIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerDayAllCustomerSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;

            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'ASIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;

    procedure ExceptionPerDayAllCustomerSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'ASICPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerDayAllCustomerSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;

            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'ASICPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;

    procedure ExceptionPerDaySelCustomerAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean;
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;


                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                //New requirement++ D314 - if exception per day is applied as quantity restriction then system shouldn't be checking per day and per month restriction 
                CheckingRemainingQty(L_RemainingQuantity, 'SCAPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                Exceeded := true;
            end;
        end;
    end;

    procedure PerDaySelCustomerAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;


            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCAPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;

    procedure ExceptionPerDaySelCustomerSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        ExistingSalesQuantity: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";


                //Calculate Remaining Quantity++
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                //New requirement++ D314 - if exception per day is applied as quantity restriction then system shouldn't be checking per day and per month restriction 
                CheckingRemainingQty(L_RemainingQuantity, 'SCSIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
                Exceeded := true;
            end;
        end;
    end;

    procedure PerDaySelCustomerSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;

            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";


            //Calculate Remaining Quantity++
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;

    procedure ExceptionPerDaySelCustomerSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSICPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerDaySelCustomerSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;

            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSICPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;

    procedure ExceptionPerDaySelCustomerGroupAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGAPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerDaySelCustomerGroupAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;

            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGAPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;

    procedure ExceptionPerDaySelCustomerGroupSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGSIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerDaySelCustomerGroupSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;

            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGSIPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;

    procedure ExceptionPerDaySelCustomerGroupSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Exception Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
                L_DayWiseShippedQty.SETRANGE(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGSICPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerDaySelCustomerGroupSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

            //Calculate Existing Order Quantity++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Current Order Quantity but if same item in Different line++
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
            L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseQty.SETRANGE(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
            END;
            L_DayWiseQty.CLOSE;

            //Calculate Shipped Quantity++
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseShippedQty.SETRANGE(Order_Date, RecSalesHeader."Order Date");
            L_DayWiseShippedQty.SETRANGE(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
            END;
            L_DayWiseShippedQty.CLOSE;

            //Calculate L_OrderQty Quantity++
            //L_OrderQty := RecSalesLine.Quantity;
            L_OrderQty := RecSalesLine."Outstanding Quantity";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
            if L_RemainingQuantity < 0 then
                L_RemainingQuantity := 0;

            Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGSICPDQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
        end;
    end;

    procedure PerMonthAllCustomerAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'AAPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerMonthAllCustomerSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'ASIPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        End;
    end;

    procedure PerMonthAllCustomerSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;


                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'ASICPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        End;
    end;

    procedure PerMonthSelCustomerAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCAPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerMonthSelCustomerSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;


                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSIPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;

    end;

    procedure PerMonthSelCustomerSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCSICPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;


    procedure PerMonthSelCustomerGroupAllItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETFILTER(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;


                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGAPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerMonthSelCustomerGroupSelItemQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETFILTER(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SetRange(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;


                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGSIPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;

    procedure PerMonthSelCustomerGroupSelItemCatQty(var RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date) Exceeded: Boolean
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60602;
        L_DayWiseShippedQty: Query 60603;
        WarningtypeOpion: Text;

    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        Clear(WarningtypeOpion);

        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Quantity");
        //L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FindFirst() THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                WarningtypeOpion := Format(L_MaxOrderQty."Warning Type");

                //Calculate Existing Order Quantity++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Current Order Quantity but if same item in Different line++
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(L_DayWiseQty.Line_No_, '<>%1', RecSalesLine."Line No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                //Calculate Shipped Quantity++
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;


                //Calculate L_OrderQty Quantity++
                //L_OrderQty := RecSalesLine.Quantity;
                L_OrderQty := RecSalesLine."Outstanding Quantity";

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                if L_RemainingQuantity < 0 then
                    L_RemainingQuantity := 0;

                Exceeded := CheckingRemainingQty(L_RemainingQuantity, 'SCGSICPMQ', WarningtypeOpion, L_MaxOrderQty."Maximum Quantity", L_MaxOrderQty."Quantity Restriction", L_OrderQty, RecSalesLine);
            end;
        end;
    end;


    procedure PerOrderAllCustomerAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderAmt: Decimal;
        L_RemainingAmt: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderAmt: Decimal;

    begin
        Clear(L_DayOrderAmt);
        Clear(L_RemainingAmt);
        Clear(L_OrderAmt);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_DayOrderAmt := L_DayOrderAmt + RecSalesLine."Line Amount"
                    ELSE
                        L_DayOrderAmt := L_DayOrderAmt + RecSalesLineNew."Line Amount";
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderAmt := RecSalesLine."Line Amount";

            L_RemainingAmt := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderAmt + L_OrderAmt);
            CheckingRemainingAmt(L_RemainingAmt, 'AAPOAMT');
        end;
    end;

    procedure PerOrderAllCustomerSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderAmt: Record 60600;
        L_DayOrderAmt: Decimal;
        L_RemainingAmt: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderAmt: Decimal;
    begin
        Clear(L_DayOrderAmt);
        Clear(L_RemainingAmt);
        Clear(L_OrderAmt);
        L_MaxOrderAmt.RESET;
        L_MaxOrderAmt.SETRANGE("Sales Type", L_MaxOrderAmt."Sales Type"::"All Customer");
        L_MaxOrderAmt.SetRange("Item Type", L_MaxOrderAmt."Item Type"::Item);
        L_MaxOrderAmt.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderAmt.SetRange("Quantity Restriction", L_MaxOrderAmt."Quantity Restriction"::"Per Order");
        L_MaxOrderAmt.SetRange("Restriction Type", L_MaxOrderAmt."Restriction Type"::"By Amount");
        L_MaxOrderAmt.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderAmt.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            RecSalesLineNew.SetRange(Type, RecSalesLineNew.Type::Item);
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_DayOrderAmt := L_DayOrderAmt + RecSalesLine."Line Amount"
                    ELSE
                        L_DayOrderAmt := L_DayOrderAmt + RecSalesLineNew."Line Amount";
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderAmt := RecSalesLine."Line Amount";

            L_RemainingAmt := L_MaxOrderAmt."Maximum Quantity" - (L_DayOrderAmt + L_OrderAmt);
            CheckingRemainingAmt(L_RemainingAmt, 'ASIPOAMT');
        end;
    end;

    procedure PerOrderAllCustomerSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        RecItem: Record Item;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SetRange(Type, RecSalesLineNew.Type::Item);
            //RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    RecItem.Reset();
                    RecItem.SetRange("No.", RecSalesLineNew."No.");
                    RecItem.SetRange("Item Category Code", ItemCat);
                    if RecItem.FindFirst() then begin
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_DayOrderQty := L_DayOrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_DayOrderQty := L_DayOrderQty + RecSalesLineNew."Line Amount";
                    end;
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'ASICPOAMT');
        end;
    end;


    procedure PerOrderSelCustomerAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            RecSalesLineNew.SetRange(Type, RecSalesLineNew.Type::Item);
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_DayOrderQty := L_DayOrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_DayOrderQty := L_DayOrderQty + RecSalesLineNew."Line Amount";
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCAPOAMT');
        end;
    end;

    procedure PerOrderSelCustomerSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            RecSalesLineNew.SetRange(Type, RecSalesLineNew.Type::Item);
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_DayOrderQty := L_DayOrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_DayOrderQty := L_DayOrderQty + RecSalesLineNew."Line Amount";
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCSIPOAMT');
        end;
    end;

    procedure PerOrderSelCustomerSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        RecItem: Record Item;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SetRange(Type, RecSalesLineNew.Type::Item);
            //RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    RecItem.Reset();
                    RecItem.SetRange("No.", RecSalesLineNew."No.");
                    RecItem.SetRange("Item Category Code", ItemCat);
                    if RecItem.FindFirst() then begin
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_DayOrderQty := L_DayOrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_DayOrderQty := L_DayOrderQty + RecSalesLineNew."Line Amount";
                    end;
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine.Quantity;

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCSICPOAMT');
        end;
    end;


    procedure PerOrderSelCustomerGroupAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            RecSalesLineNew.SetRange(Type, RecSalesLineNew.Type::Item);
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_DayOrderQty := L_DayOrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_DayOrderQty := L_DayOrderQty + RecSalesLineNew."Line Amount";
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCGAPOAMT');
        end;
    end;

    procedure PerOrderSelCustomerGroupSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            RecSalesLineNew.SetRange("Customer Price Group", RecSalesLine."Customer Price Group");
            RecSalesLineNew.SetRange(Type, RecSalesLineNew.Type::Item);
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_DayOrderQty := L_DayOrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_DayOrderQty := L_DayOrderQty + RecSalesLineNew."Line Amount";
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCGSIPOAMT');
        end;
    end;

    procedure PerOrderSelCustomerGroupSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        RecItem: Record Item;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Order");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE("Document Type", RecSalesLine."Document Type");
            RecSalesLineNew.SETRANGE("Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SetRange("Customer Price Group", RecSalesLine."Customer Price Group");
            RecSalesLineNew.SetRange(Type, RecSalesLineNew.Type::Item);
            //RecSalesLineNew.SETRANGE("No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    RecItem.Reset();
                    RecItem.SetRange("No.", RecSalesLineNew."No.");
                    RecItem.SetRange("Item Category Code", ItemCat);
                    if RecItem.FindFirst() then begin
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_DayOrderQty := L_DayOrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_DayOrderQty := L_DayOrderQty + RecSalesLineNew."Line Amount";
                    end;
                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";

            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCGSICPOAMT');
        end;
    end;

    procedure PerDayAllCustomerAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'AAPDAMT');
        end;
    end;

    procedure PerDayAllCustomerSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'ASIPDAMT');
        end;
    end;


    procedure PerDayAllCustomerSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            //L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            //L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            //RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
            RecSalesLine.SetRange("Item Category Code", ItemCat);
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'ASICPDAMT');
        end;
    end;


    procedure PerDaySelCustomerAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCAPDAMT');
        end;
    end;

    procedure PerDaySelCustomerSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCSIPDAMT');
        end;
    end;

    procedure PerDaySelCustomerSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            //L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            //L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            //RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
            RecSalesLine.SetRange("Item Category Code", ItemCat);
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCSICPDAMT');
        end;
    end;


    procedure PerDaySelCustomerGroupAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            //L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            //L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            //L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            //L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCGAPDAMT');
        end;
    end;

    procedure PerDaySelCustomerGroupSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            //L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            //L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;

            //L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            //L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCGSIPDAMT');
        end;
    end;

    procedure PerDaySelCustomerGroupSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20])
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
            L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
            L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
            L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseQty.OPEN;
            WHILE L_DayWiseQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseQty.Sum_Amt;
            END;
            L_DayWiseQty.CLOSE;


            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
            L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
            L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
            L_DayWiseShippedQty.OPEN;
            WHILE L_DayWiseShippedQty.READ DO BEGIN
                L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
            END;
            L_DayWiseShippedQty.CLOSE;

            // Added additonal code for checking the quantity for the particular Order ++
            RecSalesLineNew.RESET;
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
            RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
            RecSalesLineNew.SetRange("Item Category Code", ItemCat);
            IF RecSalesLineNew.FINDSET THEN BEGIN
                REPEAT
                    IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                        L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                    ELSE
                        L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                UNTIL RecSalesLineNew.NEXT = 0;
            END
            ELSE
                L_OrderQty := RecSalesLine."Line Amount";
            L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
            CheckingRemainingAmt(L_RemainingQuantity, 'SCGSICPDAMT');
        end;
    end;

    procedure PerMonthAllCustomerAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'AAPMAMT');
            end;
        end;
    end;

    procedure PerMonthAllCustomerSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'ASIPMAMT');
            end;
        End;
    end;

    procedure PerMonthAllCustomerSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                //L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                //L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                //RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
                RecSalesLine.SetRange("Item Category Code", ItemCat);
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'ASICPMAMT');
            end;
        End;
    end;

    procedure PerMonthSelCustomerAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'SCAPMAMT');
            end;
        end;
    end;

    procedure PerMonthSelCustomerSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'SCSIPMAMT');
            end;
        end;
    end;

    procedure PerMonthSelCustomerSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        if RecSalesHeader."Ship-to Code" <> '' then
            L_MaxOrderQty.SetRange("Ship-to Code", RecSalesHeader."Ship-to Code");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                //L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                //L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                //RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
                RecSalesLine.SetRange("Item Category Code", ItemCat);
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'SCSICPMAMT');
            end;
        end;
    end;


    procedure PerMonthSelCustomerGroupAllItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"All Items");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                //L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                //L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                //L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                //L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine."Line Amount";
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'SCGAPMAMT');
            end;
        end;
    end;

    procedure PerMonthSelCustomerGroupSelItemAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::Item);
        L_MaxOrderQty.SetRange("Item Code", RecSalesLine."No.");
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Month");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                //L_DayWiseQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                //L_DayWiseQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;

                //L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, RecSalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                //L_DayWiseShippedQty.SETRANGE(Ship_to_Code, RecSalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SETRANGE(No, RecSalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                RecSalesLineNew.SETRANGE(RecSalesLineNew."No.", RecSalesLine."No.");
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine.Quantity;
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'SCGSIPMAMT');
            end;
        end;
    end;

    procedure PerMonthSelCustomerGroupSelItemCatAmt(RecSalesLine: Record "Sales Line"; RecSalesHeader: Record "Sales Header"; ItemCat: code[20]; Sdate: Date; Edate: Date)
    var
        L_MaxOrderQty: Record 60600;
        L_DayOrderQty: Decimal;
        L_RemainingQuantity: Decimal;
        RecSalesLineNew: Record "Sales Line";
        L_OrderQty: Decimal;
        L_DayWiseQty: Query 60600;
        L_DayWiseShippedQty: Query 60601;
    begin
        Clear(L_DayOrderQty);
        Clear(L_RemainingQuantity);
        Clear(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");
        L_MaxOrderQty.SetRange("Sales Code", RecSalesLine."Customer Price Group");
        L_MaxOrderQty.SetRange("Item Type", L_MaxOrderQty."Item Type"::"Item Category");
        L_MaxOrderQty.SetRange("Item Code", ItemCat);
        L_MaxOrderQty.SetRange("Quantity Restriction", L_MaxOrderQty."Quantity Restriction"::"Per Day");
        L_MaxOrderQty.SetRange("Restriction Type", L_MaxOrderQty."Restriction Type"::"By Amount");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            if (L_MaxOrderQty."Start Date" <= RecSalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= RecSalesHeader."Order Date") then begin
                L_DayWiseQty.SetRange(Document_Type, RecSalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', RecSalesLine."Document No.");
                L_DayWiseQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseQty.SetRange(L_DayWiseQty.Item_Category_Code, ItemCat);
                L_DayWiseQty.SetRange(L_DayWiseQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Amt;
                END;
                L_DayWiseQty.CLOSE;


                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Customer_Price_Group, RecSalesLine."Customer Price Group");
                L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', Sdate, Edate);
                L_DayWiseShippedQty.SetRange(L_DayWiseShippedQty.Item_Category_Code, ItemCat);
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Amt;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                RecSalesLineNew.RESET;
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document Type", RecSalesLineNew."Document Type"::Order);
                RecSalesLineNew.SETRANGE(RecSalesLineNew."Document No.", RecSalesLine."Document No.");
                RecSalesLineNew.SetRange("Item Category Code", ItemCat);
                IF RecSalesLineNew.FINDSET THEN BEGIN
                    REPEAT
                        IF RecSalesLineNew."Line No." = RecSalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + RecSalesLine."Line Amount"
                        ELSE
                            L_OrderQty := L_OrderQty + RecSalesLineNew."Line Amount";

                    UNTIL RecSalesLineNew.NEXT = 0;
                END
                ELSE
                    L_OrderQty := RecSalesLine.Quantity;
                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                CheckingRemainingAmt(L_RemainingQuantity, 'SCGSICPMAMT');
            end;
        end;
    end;




    //salman


    procedure CheckingRemainingQty(RemQty: Decimal; Errcode: code[20]; WarningtypeOpion: Text; _TotalMaxQuantity: Decimal; _QuantityRestriction: Option "Per Day","Per Order","Per Month","Exception Per Day"; _OrderQuanitity: Decimal; var _SalesLine: Record "Sales Line") Exceeded: Boolean
    var
    begin
        _SalesLine."Sales Quota Approval" := false;
        if _QuantityRestriction = _QuantityRestriction::"Per Order" then begin
            if _OrderQuanitity > RemQty then begin
                if WarningtypeOpion = 'error' then begin
                    if GuiAllowed = true then begin
                        ERROR('Maximum quantity %1  %2 allowed has been exceeded.You can use only %3 Qty.', _TotalMaxQuantity, _QuantityRestriction, _TotalMaxQuantity)
                    end
                    else begin
                        _SalesLine."Sales Quota Approval" := true;
                        Exceeded := true;
                    end;
                end
                else begin
                    Message('Maximum quantity %1  %2 allowed has been exceeded.You can use only %3 Qty.', _TotalMaxQuantity, _QuantityRestriction, _TotalMaxQuantity);
                    _SalesLine."Sales Quota Approval" := true;
                    Exceeded := true;
                end;
            end else
                _SalesLine."Sales Quota Approval" := false;
        end else begin
            if _OrderQuanitity > RemQty then begin
                if WarningtypeOpion = 'error' then begin
                    if GuiAllowed = true then begin
                        ERROR('Maximum quantity %1  %2 allowed has been exceeded.Remaining quantity is %3.', _TotalMaxQuantity, _QuantityRestriction, RemQty)
                    end
                    else begin
                        _SalesLine."Sales Quota Approval" := true;
                        Exceeded := true;
                    end;
                end
                else begin
                    Message('Maximum quantity %1  %2 allowed has been exceeded.Remaining quantity is %3.', _TotalMaxQuantity, _QuantityRestriction, RemQty);
                    _SalesLine."Sales Quota Approval" := true;
                    Exceeded := true;
                end;
            end else
                _SalesLine."Sales Quota Approval" := false;
        end;
        if GuiAllowed = false then
            _SalesLine.Modify();
    end;

    procedure CheckingRemainingAmt(RemAmt: Decimal; Errcode: code[20])
    var
    begin
        IF RemAmt < 0 THEN
            ERROR('Maximum amount allowed has been exceeded. Error Code:' + Errcode);
    end;
    //Azhar--

    procedure CheckMaxOrderQty(P_SalesLine: Record 37): Decimal
    var
        L_MaxOrderQty: Record 60600;
        L_SalesLine: Record 37;
        L_DayWiseQty: Query 60602;
        L_DayOrderQty: Decimal;
        L_DayWiseShippedQty: Query 60603;
        L_CustomerPriceGroup: Record 6;
        L_Customer: Record 18;
        L_RemainingQuantity: Decimal;
        L_SalesLine2: Record 37;
        L_OrderQty: Decimal;
        SalesHeader: Record "Sales Header";
        RecSalesLineNew: Record "Sales Line";
    begin
        //IF CurrFieldNo <> FIELDNO(Quantity) THEN//azhar
        //    EXIT;//azhar
        // IF CurrFieldNoGlo <> 15 THEN//azhar
        //     EXIT;//azhar
        //GetSalesHeader;//azhar
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", P_SalesLine."Document No.");
        if SalesHeader.FindFirst() then;

        CLEAR(L_DayWiseQty);
        CLEAR(L_RemainingQuantity);
        CLEAR(L_OrderQty);
        // For the Type Customer
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::Customer);// Manish ++
        L_MaxOrderQty.SETRANGE("Sales Code", P_SalesLine."Sell-to Customer No.");
        L_MaxOrderQty.SETRANGE("Item Code", P_SalesLine."No.");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);// Manish 25/04/2017 ++ Added to filter quantity restriction for greater than 0
        IF SalesHeader."Ship-to Code" <> '' THEN
            L_MaxOrderQty.SETRANGE("Ship-to Code", SalesHeader."Ship-to Code");
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            IF L_MaxOrderQty."Quantity Restriction" = L_MaxOrderQty."Quantity Restriction"::"Per Day" THEN BEGIN
                L_DayWiseQty.SETRANGE(Document_Type, P_SalesLine."Document Type");
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', P_SalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
                L_DayWiseQty.SETRANGE(No, P_SalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;


                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
                L_DayWiseShippedQty.SETRANGE(No, P_SalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                L_SalesLine2.RESET;
                L_SalesLine2.SETRANGE(L_SalesLine2."Document Type", L_SalesLine2."Document Type"::Order);
                L_SalesLine2.SETRANGE(L_SalesLine2."Document No.", P_SalesLine."Document No.");
                L_SalesLine2.SETRANGE(L_SalesLine2."No.", P_SalesLine."No.");
                IF L_SalesLine2.FINDSET THEN BEGIN
                    REPEAT
                        IF L_SalesLine2."Line No." = P_SalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + P_SalesLine.Quantity
                        ELSE
                            L_OrderQty := L_OrderQty + L_SalesLine2.Quantity;
                    UNTIL L_SalesLine2.NEXT = 0;
                END
                ELSE
                    L_OrderQty := P_SalesLine.Quantity;


                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty)
            END
            //azhar++
            else
                if L_MaxOrderQty."Quantity Restriction" = L_MaxOrderQty."Quantity Restriction"::"Per Month" THEN begin
                    if (L_MaxOrderQty."Start Date" <= SalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= SalesHeader."Order Date") then begin
                        L_DayWiseQty.SETRANGE(Document_Type, P_SalesLine."Document Type");
                        L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', P_SalesLine."Document No.");//azhar
                        L_DayWiseQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                        L_DayWiseQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                        L_DayWiseQty.SetFilter(Order_Date, '%1..%2', L_MaxOrderQty."Start Date", L_MaxOrderQty."End Date");
                        L_DayWiseQty.SETRANGE(No, P_SalesLine."No.");
                        L_DayWiseQty.OPEN;
                        WHILE L_DayWiseQty.READ DO BEGIN
                            L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                        END;
                        L_DayWiseQty.CLOSE;


                        L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                        L_DayWiseShippedQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                        L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', L_MaxOrderQty."Start Date", L_MaxOrderQty."End Date");
                        L_DayWiseShippedQty.SETRANGE(No, P_SalesLine."No.");
                        L_DayWiseShippedQty.OPEN;
                        WHILE L_DayWiseShippedQty.READ DO BEGIN
                            L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                        END;
                        L_DayWiseShippedQty.CLOSE;

                        L_SalesLine2.RESET;
                        L_SalesLine2.SETRANGE(L_SalesLine2."Document Type", L_SalesLine2."Document Type"::Order);
                        L_SalesLine2.SETRANGE(L_SalesLine2."Document No.", P_SalesLine."Document No.");
                        L_SalesLine2.SETRANGE(L_SalesLine2."No.", P_SalesLine."No.");
                        IF L_SalesLine2.FINDSET THEN BEGIN
                            REPEAT
                                IF L_SalesLine2."Line No." = P_SalesLine."Line No." THEN
                                    L_OrderQty := L_OrderQty + P_SalesLine.Quantity
                                ELSE
                                    L_OrderQty := L_OrderQty + L_SalesLine2.Quantity;
                            UNTIL L_SalesLine2.NEXT = 0;
                        END
                        ELSE
                            L_OrderQty := P_SalesLine.Quantity;


                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty)
                    end;
                end
                //azhar--
                ELSE BEGIN

                    L_DayWiseQty.SETRANGE(Document_Type, P_SalesLine."Document Type");
                    L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, P_SalesLine."Document No.");
                    L_DayWiseQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                    L_DayWiseQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                    //L_DayWiseQty.SETRANGE(Order_Date,WORKDATE);
                    L_DayWiseQty.SETRANGE(No, P_SalesLine."No.");
                    L_DayWiseQty.OPEN;
                    WHILE L_DayWiseQty.READ DO BEGIN
                        L_DayOrderQty := L_DayWiseQty.Sum_Quantity;
                    END;
                    L_DayWiseQty.CLOSE;

                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;
                END;


            EXIT(L_RemainingQuantity);


        END;

        // For the Customer Price Group ++
        CLEAR(L_DayOrderQty);
        CLEAR(L_RemainingQuantity);
        CLEAR(L_DayWiseQty);
        CLEAR(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"Customer Price Group");// Manish ++

        L_Customer.RESET;
        L_Customer.SETRANGE("No.", P_SalesLine."Bill-to Customer No.");
        IF L_Customer.FINDFIRST THEN;

        L_MaxOrderQty.SETRANGE("Sales Code", L_Customer."Customer Price Group");
        L_MaxOrderQty.SETRANGE("Item Code", P_SalesLine."No.");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);// Manish 25/04/2017 ++ Added to filter quantity restriction for greater than 0

        IF SalesHeader."Ship-to Code" <> '' THEN
            L_MaxOrderQty.SETRANGE("Ship-to Code", SalesHeader."Ship-to Code");
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            IF L_MaxOrderQty."Quantity Restriction" = L_MaxOrderQty."Quantity Restriction"::"Per Day" THEN BEGIN
                L_DayWiseQty.SETRANGE(Document_Type, P_SalesLine."Document Type");
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', P_SalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
                L_DayWiseQty.SETRANGE(No, P_SalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
                L_DayWiseShippedQty.SETRANGE(No, P_SalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                L_SalesLine2.RESET;
                L_SalesLine2.SETRANGE(L_SalesLine2."Document Type", L_SalesLine2."Document Type"::Order);
                L_SalesLine2.SETRANGE(L_SalesLine2."Document No.", P_SalesLine."Document No.");
                L_SalesLine2.SETRANGE(L_SalesLine2."No.", P_SalesLine."No.");
                IF L_SalesLine2.FINDSET THEN BEGIN
                    REPEAT
                        IF L_SalesLine2."Line No." = P_SalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + P_SalesLine.Quantity
                        ELSE
                            L_OrderQty := L_OrderQty + L_SalesLine2.Quantity;
                    UNTIL L_SalesLine2.NEXT = 0;
                END
                ELSE
                    L_OrderQty := P_SalesLine.Quantity;

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty)
            END
            //azhar++
            else
                if L_MaxOrderQty."Quantity Restriction" = L_MaxOrderQty."Quantity Restriction"::"Per Month" THEN begin
                    if (L_MaxOrderQty."Start Date" <= SalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= SalesHeader."Order Date") then begin
                        L_DayWiseQty.SETRANGE(Document_Type, P_SalesLine."Document Type");
                        L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', P_SalesLine."Document No.");
                        L_DayWiseQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                        L_DayWiseQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                        L_DayWiseQty.SetFilter(Order_Date, '%1..%2', L_MaxOrderQty."Start Date", L_MaxOrderQty."End Date");
                        L_DayWiseQty.SETRANGE(No, P_SalesLine."No.");
                        L_DayWiseQty.OPEN;
                        WHILE L_DayWiseQty.READ DO BEGIN
                            L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                        END;
                        L_DayWiseQty.CLOSE;

                        L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                        L_DayWiseShippedQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                        L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', L_MaxOrderQty."Start Date", L_MaxOrderQty."End Date");
                        L_DayWiseShippedQty.SETRANGE(No, P_SalesLine."No.");
                        L_DayWiseShippedQty.OPEN;
                        WHILE L_DayWiseShippedQty.READ DO BEGIN
                            L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                        END;
                        L_DayWiseShippedQty.CLOSE;

                        L_SalesLine2.RESET;
                        L_SalesLine2.SETRANGE(L_SalesLine2."Document Type", L_SalesLine2."Document Type"::Order);
                        L_SalesLine2.SETRANGE(L_SalesLine2."Document No.", P_SalesLine."Document No.");
                        L_SalesLine2.SETRANGE(L_SalesLine2."No.", P_SalesLine."No.");
                        IF L_SalesLine2.FINDSET THEN BEGIN
                            REPEAT
                                IF L_SalesLine2."Line No." = P_SalesLine."Line No." THEN
                                    L_OrderQty := L_OrderQty + P_SalesLine.Quantity
                                ELSE
                                    L_OrderQty := L_OrderQty + L_SalesLine2.Quantity;
                            UNTIL L_SalesLine2.NEXT = 0;
                        END
                        ELSE
                            L_OrderQty := P_SalesLine.Quantity;

                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty)
                    end;
                end
                //azhar--
                ELSE BEGIN

                    L_DayWiseQty.SETRANGE(Document_Type, P_SalesLine."Document Type");
                    L_DayWiseQty.SETRANGE(L_DayWiseQty.Doc_No, P_SalesLine."Document No.");
                    //L_DayWiseQty.SETRANGE(Sell_to_Customer_No,P_SalesLine."Sell-to Customer No.");
                    L_DayWiseQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                    //L_DayWiseQty.SETRANGE(Order_Date,WORKDATE);
                    L_DayWiseQty.SETRANGE(No, P_SalesLine."No.");
                    L_DayWiseQty.OPEN;
                    WHILE L_DayWiseQty.READ DO BEGIN
                        L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                    END;
                    L_DayWiseQty.CLOSE;
                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - L_DayOrderQty;

                END;


            EXIT(L_RemainingQuantity);

        END;

        // For the All Customer ++ Correct code for the All Customer scenerio
        CLEAR(L_DayOrderQty);
        CLEAR(L_RemainingQuantity);
        CLEAR(L_DayWiseQty);
        CLEAR(L_OrderQty);
        L_MaxOrderQty.RESET;
        L_MaxOrderQty.SETRANGE("Sales Type", L_MaxOrderQty."Sales Type"::"All Customer");// Manish ++
        L_MaxOrderQty.SETRANGE("Item Code", P_SalesLine."No.");
        L_MaxOrderQty.SETFILTER("Maximum Quantity", '>%1', 0);// Manish 25/04/2017 ++ Added to filter quantity restriction for greater than 0
                                                              //IF SalesHeader."Ship-to Code" <> '' THEN
                                                              //L_MaxOrderQty.SETRANGE("Ship-to Code",SalesHeader."Ship-to Code");
        IF L_MaxOrderQty.FINDFIRST THEN BEGIN
            IF L_MaxOrderQty."Quantity Restriction" = L_MaxOrderQty."Quantity Restriction"::"Per Day" THEN BEGIN
                L_DayWiseQty.SetRange(Document_Type, P_SalesLine."Document Type");//azhar
                L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', P_SalesLine."Document No.");
                L_DayWiseQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                L_DayWiseQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                L_DayWiseQty.SETRANGE(Order_Date, WORKDATE);
                L_DayWiseQty.SETRANGE(No, P_SalesLine."No.");
                L_DayWiseQty.OPEN;
                WHILE L_DayWiseQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                END;
                L_DayWiseQty.CLOSE;

                L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                L_DayWiseShippedQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                L_DayWiseShippedQty.SETRANGE(Order_Date, WORKDATE);
                L_DayWiseShippedQty.SETRANGE(No, P_SalesLine."No.");
                L_DayWiseShippedQty.OPEN;
                WHILE L_DayWiseShippedQty.READ DO BEGIN
                    L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                END;
                L_DayWiseShippedQty.CLOSE;

                // Added additonal code for checking the quantity for the particular Order ++
                L_SalesLine2.RESET;
                L_SalesLine2.SETRANGE(L_SalesLine2."Document Type", L_SalesLine2."Document Type"::Order);
                L_SalesLine2.SETRANGE(L_SalesLine2."Document No.", P_SalesLine."Document No.");
                L_SalesLine2.SETRANGE(L_SalesLine2."No.", P_SalesLine."No.");
                IF L_SalesLine2.FINDSET THEN BEGIN
                    REPEAT
                        IF L_SalesLine2."Line No." = P_SalesLine."Line No." THEN
                            L_OrderQty := L_OrderQty + P_SalesLine.Quantity
                        ELSE
                            L_OrderQty := L_OrderQty + L_SalesLine2.Quantity;

                    UNTIL L_SalesLine2.NEXT = 0;
                END
                ELSE
                    L_OrderQty := P_SalesLine.Quantity;
                //MESSAGE(FORMAT(L_OrderQty));
                // Added additonal code for checking the quantity for the particular Order --

                L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);

            END
            //azhar++
            else
                if L_MaxOrderQty."Quantity Restriction" = L_MaxOrderQty."Quantity Restriction"::"Per Month" THEN BEGIN
                    if (L_MaxOrderQty."Start Date" <= SalesHeader."Order Date") and (L_MaxOrderQty."End Date" >= SalesHeader."Order Date") then begin
                        L_DayWiseQty.SetRange(Document_Type, P_SalesLine."Document Type");//azhar
                        L_DayWiseQty.SETFILTER(L_DayWiseQty.Doc_No, '<>%1', P_SalesLine."Document No.");//azhar
                        L_DayWiseQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                        L_DayWiseQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                        L_DayWiseQty.SetFilter(Order_Date, '%1..%2', L_MaxOrderQty."Start Date", L_MaxOrderQty."End Date");
                        L_DayWiseQty.SETRANGE(No, P_SalesLine."No.");
                        L_DayWiseQty.OPEN;
                        WHILE L_DayWiseQty.READ DO BEGIN
                            L_DayOrderQty += L_DayWiseQty.Sum_Quantity;
                        END;
                        L_DayWiseQty.CLOSE;

                        L_DayWiseShippedQty.SETRANGE(Sell_to_Customer_No, P_SalesLine."Sell-to Customer No.");
                        L_DayWiseShippedQty.SETRANGE(Ship_to_Code, SalesHeader."Ship-to Code");
                        L_DayWiseShippedQty.SetFilter(Order_Date, '%1..%2', L_MaxOrderQty."Start Date", L_MaxOrderQty."End Date");
                        L_DayWiseShippedQty.SETRANGE(No, P_SalesLine."No.");
                        L_DayWiseShippedQty.OPEN;
                        WHILE L_DayWiseShippedQty.READ DO BEGIN
                            L_DayOrderQty += L_DayWiseShippedQty.Sum_Quantity;
                        END;
                        L_DayWiseShippedQty.CLOSE;

                        // Added additonal code for checking the quantity for the particular Order ++
                        L_SalesLine2.RESET;
                        L_SalesLine2.SETRANGE(L_SalesLine2."Document Type", L_SalesLine2."Document Type"::Order);
                        L_SalesLine2.SETRANGE(L_SalesLine2."Document No.", P_SalesLine."Document No.");
                        L_SalesLine2.SETRANGE(L_SalesLine2."No.", P_SalesLine."No.");
                        IF L_SalesLine2.FINDSET THEN BEGIN
                            REPEAT
                                IF L_SalesLine2."Line No." = P_SalesLine."Line No." THEN
                                    L_OrderQty := L_OrderQty + P_SalesLine.Quantity
                                ELSE
                                    L_OrderQty := L_OrderQty + L_SalesLine2.Quantity;

                            UNTIL L_SalesLine2.NEXT = 0;
                        END
                        ELSE
                            L_OrderQty := P_SalesLine.Quantity;
                        //MESSAGE(FORMAT(L_OrderQty));
                        // Added additonal code for checking the quantity for the particular Order --

                        L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                    end;
                END
                //azhar--
                ELSE BEGIN
                    RecSalesLineNew.RESET;
                    RecSalesLineNew.SETRANGE("Document Type", P_SalesLine."Document Type");
                    RecSalesLineNew.SETRANGE("Document No.", P_SalesLine."Document No.");
                    RecSalesLineNew.SETRANGE("No.", P_SalesLine."No.");
                    IF RecSalesLineNew.FINDSET THEN BEGIN
                        REPEAT
                            IF RecSalesLineNew."Line No." = P_SalesLine."Line No." THEN
                                L_DayOrderQty := L_DayOrderQty + P_SalesLine.Quantity
                            ELSE
                                L_DayOrderQty := L_DayOrderQty + RecSalesLineNew.Quantity;
                        UNTIL RecSalesLineNew.NEXT = 0;
                    END
                    ELSE
                        L_OrderQty := P_SalesLine.Quantity;

                    L_RemainingQuantity := L_MaxOrderQty."Maximum Quantity" - (L_DayOrderQty + L_OrderQty);
                END;

            EXIT(L_RemainingQuantity);

        END;
    end;


    procedure CheckPermissionForCDProducts(_ItemNo: Code[20])
    var
        L_Item: Record 27;
        L_UserSetup: Record "User Setup";
        L_WarehouseClassCode: Record "Warehouse Class";
    begin
        //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
        //16th Training Points:+++++++
        L_Item.Reset();
        L_Item.SetRange("No.", _ItemNo);
        if L_Item.FindFirst() then begin
            L_WarehouseClassCode.Reset();
            L_WarehouseClassCode.SetRange(Code, L_Item."Warehouse Class Code");
            if L_WarehouseClassCode.FindFirst() then begin
                if (L_WarehouseClassCode."Quota Restriction" = true) then begin
                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Allowed Quota Manag. for CD", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to Add/Edit/Remove Restricted product');
                end;
            end;
        end;
        //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
        //16th Training Points:--------
    end;
}