page 60600 "Purchase Budget Summary"
{
    PageType = List;
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    CardPageID = "Item Category Card";
    UsageCategory = Administration;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTableView = sorting("Presentation Order");
    SourceTable = "Purchase Budget Summary";

    layout
    {
        area(Content)
        {
            repeater("Budget Summary")
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = "Item Category";
                ShowAsTree = true;

                field("Item Category"; Rec."Item Category")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Budget CM"; Rec."Budget CM")
                {
                    ApplicationArea = All;
                }
                field("Purchase CM"; Rec."Purchase CM")
                {
                    ApplicationArea = All;
                }
                field("Remaining CM"; Rec."Remaining CM")
                {
                    ApplicationArea = All;
                }
                field("Purchase LM"; Rec."Purchase LM")
                {
                    ApplicationArea = All;
                }
                field("+2M Purchase"; Rec."+2M Purchase")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Refresh Budget")
            {
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    L_ItemCategory: Record "Item Category";
                    Rec_ItemCategory: Record "Item Category";
                    L_PurchBudgetSummary: Record "Purchase Budget Summary";
                    Windows: Dialog;
                    ProgressCount: Integer;
                    NoOfRecs: Integer;
                    Count: Integer;
                begin
                    Windows.OPEN('Refreshing Purchase Summary..' + ' @1@@@@@@@@@@@@@\' + 'Updating..' + ' #3##########' + 'Please Wait..');
                    L_ItemCategory.Reset();
                    L_ItemCategory.SetRange(Indentation, 1);
                    if L_ItemCategory.FindSet() then begin
                        repeat
                            NoOfRecs := L_ItemCategory.Count;
                            ProgressCount += 1;
                            IF NoOfRecs <= 100 THEN
                                Windows.UPDATE(1, (ProgressCount / NoOfRecs * 10000) DIV 1)
                            ELSE
                                IF Count MOD (NoOfRecs DIV 100) = 0 THEN BEGIN
                                    Windows.UPDATE(1, (ProgressCount / NoOfRecs * 10000) DIV 1)
                                END;
                            Windows.UPDATE(3, L_ItemCategory.Code);

                            L_PurchBudgetSummary.Reset();
                            L_PurchBudgetSummary.SetRange("Item Category", L_ItemCategory.Code);
                            if L_PurchBudgetSummary.FindFirst() then begin
                                L_PurchBudgetSummary."Budget CM" := GetBudgetFromPurchQuota(L_ItemCategory.Code);
                                L_PurchBudgetSummary."Purchase CM" := GetPurchaseForCurrentMonth(L_ItemCategory.Code, L_ItemCategory.Indentation);
                                if L_PurchBudgetSummary."Budget CM" > 0 then
                                    L_PurchBudgetSummary."Remaining CM" := L_PurchBudgetSummary."Budget CM" - L_PurchBudgetSummary."Purchase CM"
                                else
                                    L_PurchBudgetSummary."Remaining CM" := 0;
                                L_PurchBudgetSummary."Purchase LM" := GetPurchaseForLastMonth(L_ItemCategory.Code, L_ItemCategory.Indentation);
                                L_PurchBudgetSummary."+2M Purchase" := GetPurchaseForLastTwoMonths(L_ItemCategory.Code, L_ItemCategory.Indentation);
                                L_PurchBudgetSummary.Modify();

                                Rec_ItemCategory.Reset();
                                Rec_ItemCategory.SetRange("Parent Category", L_ItemCategory.Code);
                                if Rec_ItemCategory.FindSet() then begin
                                    repeat
                                        L_PurchBudgetSummary.Reset();
                                        L_PurchBudgetSummary.SetRange("Item Category", Rec_ItemCategory.Code);
                                        if L_PurchBudgetSummary.FindFirst() then begin
                                            L_PurchBudgetSummary."Purchase CM" := GetPurchaseForCurrentMonth(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary."Purchase LM" := GetPurchaseForLastMonth(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary."+2M Purchase" := GetPurchaseForLastTwoMonths(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary.Modify();
                                        end
                                        else begin
                                            Clear(L_PurchBudgetSummary);
                                            L_PurchBudgetSummary.Init();
                                            L_PurchBudgetSummary."Entry No" := FindLastEntryNo();
                                            L_PurchBudgetSummary."Item Category" := Rec_ItemCategory.Code;
                                            L_PurchBudgetSummary.Indentation := Rec_ItemCategory.Indentation;
                                            L_PurchBudgetSummary."Presentation Order" := FindLastPresentationOrder();
                                            L_PurchBudgetSummary."Purchase CM" := GetPurchaseForCurrentMonth(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary."Purchase LM" := GetPurchaseForLastMonth(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary."+2M Purchase" := GetPurchaseForLastTwoMonths(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary.Insert();
                                        end;
                                    until Rec_ItemCategory.Next() = 0;
                                end;
                            end
                            else begin
                                Clear(L_PurchBudgetSummary);
                                L_PurchBudgetSummary.Init();
                                L_PurchBudgetSummary."Entry No" := FindLastEntryNo();
                                L_PurchBudgetSummary."Item Category" := L_ItemCategory.Code;
                                L_PurchBudgetSummary.Indentation := L_ItemCategory.Indentation;
                                L_PurchBudgetSummary."Presentation Order" := FindLastPresentationOrder();
                                L_PurchBudgetSummary."Budget CM" := GetBudgetFromPurchQuota(L_ItemCategory.Code);
                                L_PurchBudgetSummary."Purchase CM" := GetPurchaseForCurrentMonth(L_ItemCategory.Code, L_ItemCategory.Indentation);
                                if L_PurchBudgetSummary."Budget CM" > 0 then
                                    L_PurchBudgetSummary."Remaining CM" := L_PurchBudgetSummary."Budget CM" - L_PurchBudgetSummary."Purchase CM"
                                else
                                    L_PurchBudgetSummary."Remaining CM" := 0;
                                L_PurchBudgetSummary."Purchase LM" := GetPurchaseForLastMonth(L_ItemCategory.Code, L_ItemCategory.Indentation);
                                L_PurchBudgetSummary."+2M Purchase" := GetPurchaseForLastTwoMonths(L_ItemCategory.Code, L_ItemCategory.Indentation);
                                L_PurchBudgetSummary.Insert();

                                Rec_ItemCategory.Reset();
                                Rec_ItemCategory.SetRange("Parent Category", L_ItemCategory.Code);
                                if Rec_ItemCategory.FindSet() then begin
                                    repeat
                                        L_PurchBudgetSummary.Reset();
                                        L_PurchBudgetSummary.SetRange("Item Category", Rec_ItemCategory.Code);
                                        if L_PurchBudgetSummary.FindFirst() then begin
                                            L_PurchBudgetSummary."Purchase CM" := GetPurchaseForCurrentMonth(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary."Purchase LM" := GetPurchaseForLastMonth(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary."+2M Purchase" := GetPurchaseForLastTwoMonths(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary.Modify();
                                        end
                                        else begin
                                            Clear(L_PurchBudgetSummary);
                                            L_PurchBudgetSummary.Init();
                                            L_PurchBudgetSummary."Entry No" := FindLastEntryNo();
                                            L_PurchBudgetSummary."Item Category" := Rec_ItemCategory.Code;
                                            L_PurchBudgetSummary.Indentation := Rec_ItemCategory.Indentation;
                                            L_PurchBudgetSummary."Presentation Order" := FindLastPresentationOrder();
                                            L_PurchBudgetSummary."Purchase CM" := GetPurchaseForCurrentMonth(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary."Purchase LM" := GetPurchaseForLastMonth(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary."+2M Purchase" := GetPurchaseForLastTwoMonths(Rec_ItemCategory.Code, Rec_ItemCategory.Indentation);
                                            L_PurchBudgetSummary.Insert();
                                        end;
                                    until Rec_ItemCategory.Next() = 0;
                                end;
                            end;
                        until L_ItemCategory.Next() = 0;
                    end;
                end;
            }

            action("Delete All Entries")
            {
                ApplicationArea = All;
                Image = Delete;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    L_PurchBudgetSummary: Record "Purchase Budget Summary";
                begin
                    L_PurchBudgetSummary.Reset();
                    if L_PurchBudgetSummary.FindSet() then begin
                        L_PurchBudgetSummary.DeleteAll();
                    end;
                end;
            }
        }
    }

    var
        StyleTxt: Text;

    local procedure GetBudgetFromPurchQuota(CategoryCode: Code[20]): Decimal
    var
        L_PurchaseQuotaByAmt: Record "Purchase Quota";
        L_SalesHeader: Record "Purchase Header";
    begin
        L_PurchaseQuotaByAmt.Reset();
        L_PurchaseQuotaByAmt.SetRange("Purchase Type", L_PurchaseQuotaByAmt."Purchase Type"::"All Vendor");
        L_PurchaseQuotaByAmt.SetRange("Item Type", L_PurchaseQuotaByAmt."Item Type"::"Item Category");
        L_PurchaseQuotaByAmt.SetRange("Item Code", CategoryCode);
        if L_PurchaseQuotaByAmt.FindSet() then begin
            repeat
                if (Today >= L_PurchaseQuotaByAmt."Start Date") and (Today <= L_PurchaseQuotaByAmt."End Date") then
                    exit(L_PurchaseQuotaByAmt."Maximum Quantity");
            until L_PurchaseQuotaByAmt.Next() = 0;
        end;
    end;

    local procedure GetPurchaseForCurrentMonth(CategoryCode: Code[20]; P_Indentation: Integer): Decimal
    var
        CurrentMonthStartDate: Date;
        CurrentMonthEndDate: Date;
        CurrentMonthPurchase: Decimal;
        PurchaseLine: Record "Purchase Line";
        AmountFromILE: Decimal;
        L_ILE: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        Clear(CurrentMonthPurchase);
        Clear(CurrentMonthStartDate);
        Clear(CurrentMonthEndDate);

        CurrentMonthStartDate := CalcDate('-CM', Today);
        CurrentMonthEndDate := CalcDate('+CM', Today);

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        if P_Indentation = 1 then
            PurchaseLine.SetRange("Parent Category", CategoryCode)
        else
            PurchaseLine.SetRange("Child Category", CategoryCode);
        PurchaseLine.SetFilter("Order Date", '%1..%2', CurrentMonthStartDate, CurrentMonthEndDate);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then begin
            PurchaseLine.CalcSums("Outstanding Amt. Ex. VAT (LCY)");
            CurrentMonthPurchase += PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";
        end;

        Clear(AmountFromILE);
        L_ILE.Reset();
        L_ILE.SetRange("Entry Type", L_ILE."Entry Type"::Purchase);
        L_ILE.SetRange("Document Type", L_ILE."Document Type"::"Purchase Receipt");
        if P_Indentation = 1 then
            L_ILE.SetRange("Parent Category", CategoryCode)
        else
            L_ILE.SetRange("Child Category", CategoryCode);
        if L_ILE.FindSet() then begin
            repeat
                PurchRcptHeader.Reset();
                PurchRcptHeader.SetRange("No.", L_ILE."Document No.");
                if PurchRcptHeader.FindFirst() then begin
                    if PurchRcptHeader."Order Date" in [CurrentMonthStartDate .. CurrentMonthEndDate] then begin
                        L_ILE.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                        AmountFromILE := AmountFromILE + (L_ILE."Cost Amount (Actual)" + L_ILE."Cost Amount (Expected)");
                    end;
                end;
            until L_ILE.Next() = 0;

            CurrentMonthPurchase += AmountFromILE;
        end;

        if CurrentMonthPurchase > 0 then
            exit(CurrentMonthPurchase);
    end;

    local procedure GetPurchaseForLastMonth(CategoryCode: Code[20]; P_Indentation: Integer): Decimal
    var
        LastMonthStartDate: Date;
        LastMonthEndDate: Date;
        LastMonthPurchase: Decimal;
        PurchaseLine: Record "Purchase Line";
        AmountFromILE: Decimal;
        L_ILE: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        Clear(LastMonthPurchase);
        Clear(LastMonthStartDate);
        Clear(LastMonthEndDate);

        LastMonthStartDate := CalcDate('-CM', CalcDate('-1M', Today));
        LastMonthEndDate := CalcDate('+CM', LastMonthStartDate);

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        if P_Indentation = 1 then
            PurchaseLine.SetRange("Parent Category", CategoryCode)
        else
            PurchaseLine.SetRange("Child Category", CategoryCode);
        PurchaseLine.SetFilter("Order Date", '%1..%2', LastMonthStartDate, LastMonthEndDate);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then begin
            PurchaseLine.CalcSums("Outstanding Amt. Ex. VAT (LCY)");
            LastMonthPurchase += PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";
        end;

        Clear(AmountFromILE);
        L_ILE.Reset();
        L_ILE.SetRange("Entry Type", L_ILE."Entry Type"::Purchase);
        L_ILE.SetRange("Document Type", L_ILE."Document Type"::"Purchase Receipt");
        if P_Indentation = 1 then
            L_ILE.SetRange("Parent Category", CategoryCode)
        else
            L_ILE.SetRange("Child Category", CategoryCode);
        if L_ILE.FindSet() then begin
            repeat
                PurchRcptHeader.Reset();
                PurchRcptHeader.SetRange("No.", L_ILE."Document No.");
                if PurchRcptHeader.FindFirst() then begin
                    if PurchRcptHeader."Order Date" in [LastMonthStartDate .. LastMonthEndDate] then begin
                        L_ILE.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                        AmountFromILE := AmountFromILE + (L_ILE."Cost Amount (Actual)" + L_ILE."Cost Amount (Expected)");
                    end;
                end;
            until L_ILE.Next() = 0;

            LastMonthPurchase += AmountFromILE;
        end;

        if LastMonthPurchase > 0 then
            exit(LastMonthPurchase);
    end;

    local procedure GetPurchaseForLastTwoMonths(CategoryCode: Code[20]; P_Indentation: Integer): Decimal
    var
        Last2MonthStartDate: Date;
        Last2MonthEndDate: Date;
        Last2MonthPurchase: Decimal;
        PurchaseLine: Record "Purchase Line";
        AmountFromILE: Decimal;
        L_ILE: Record "Item Ledger Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        Clear(Last2MonthPurchase);
        Clear(Last2MonthStartDate);
        Clear(Last2MonthEndDate);

        Last2MonthStartDate := CalcDate('-CM', CalcDate('-3M', Today));
        Last2MonthEndDate := CalcDate('+CM', CalcDate('-2M', Today));

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        if P_Indentation = 1 then
            PurchaseLine.SetRange("Parent Category", CategoryCode)
        else
            PurchaseLine.SetRange("Child Category", CategoryCode);
        PurchaseLine.SetFilter("Order Date", '%1..%2', Last2MonthStartDate, Last2MonthEndDate);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then begin
            PurchaseLine.CalcSums("Outstanding Amt. Ex. VAT (LCY)");
            Last2MonthPurchase += PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";
        end;

        Clear(AmountFromILE);
        L_ILE.Reset();
        L_ILE.SetRange("Entry Type", L_ILE."Entry Type"::Purchase);
        L_ILE.SetRange("Document Type", L_ILE."Document Type"::"Purchase Receipt");
        if P_Indentation = 1 then
            L_ILE.SetRange("Parent Category", CategoryCode)
        else
            L_ILE.SetRange("Child Category", CategoryCode);
        if L_ILE.FindSet() then begin
            repeat
                PurchRcptHeader.Reset();
                PurchRcptHeader.SetRange("No.", L_ILE."Document No.");
                if PurchRcptHeader.FindFirst() then begin
                    if PurchRcptHeader."Order Date" in [Last2MonthStartDate .. Last2MonthEndDate] then begin
                        L_ILE.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                        AmountFromILE := AmountFromILE + (L_ILE."Cost Amount (Actual)" + L_ILE."Cost Amount (Expected)");
                    end;
                end;
            until L_ILE.Next() = 0;

            Last2MonthPurchase += AmountFromILE;
        end;

        if Last2MonthPurchase > 0 then
            exit(Last2MonthPurchase);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        StyleTxt := Rec.GetStyleText();
    end;

    local procedure FindLastEntryNo(): Integer
    var
        PurchBudgetSummary: Record "Purchase Budget Summary";
    begin
        PurchBudgetSummary.Reset();
        if PurchBudgetSummary.FindLast() then
            exit(PurchBudgetSummary."Entry No" + 1)
        else
            exit(1);
    end;

    local procedure FindLastPresentationOrder(): Integer
    var
        PurchBudgetSummary: Record "Purchase Budget Summary";
    begin
        PurchBudgetSummary.Reset();
        if PurchBudgetSummary.FindLast() then
            exit(PurchBudgetSummary."Presentation Order" + 10000)
        else
            exit(10000);
    end;
}