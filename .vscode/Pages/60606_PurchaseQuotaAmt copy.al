page 60606 "Purchase Quota By Amount"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Purchase Quota";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Purchase Type Filter"; PurchaseTypeFilter)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        Rec.SetRange("Purchase Type", PurchaseTypeFilter);
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                    end;
                }
                field("Purchase Code Filter"; PurchaseCodeFilter)
                {
                    ApplicationArea = all;
                    Visible = false;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustList: Page "Customer List";
                        CustPriceGrList: Page "Customer Price Groups";
                        CampaignList: Page "Campaign List";
                    begin
                        if PurchaseTypeFilter = PurchaseTypeFilter::"All Vendor" then
                            exit;
                        if PurchaseTypeFilter = PurchaseTypeFilter::" " then
                            exit;

                        case PurchaseTypeFilter of
                            PurchaseTypeFilter::Vendor:
                                begin
                                    CustList.LookupMode := true;
                                    if CustList.RunModal = ACTION::LookupOK then
                                        Text := CustList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        Rec.SetFilter("Purchase Code", PurchaseCodeFilter);
                        CurrPage.Update(false);
                    end;
                }
                field("Item Type Filter"; ItemTypeFilter)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                    begin
                        Rec.SetRange("Item Type", ItemTypeFilter);
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                    end;
                }
                field("Item Code Filter"; ItemCodeFilter)
                {
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                        ItemCategory: Page "Item Categories";
                    begin
                        if ItemTypeFilter = ItemTypeFilter::"All Items" then
                            exit;

                        case ItemTypeFilter of

                            ItemTypeFilter::Item:
                                begin

                                    ItemList.LookupMode := true;
                                    if ItemList.RunModal = ACTION::LookupOK then
                                        Text := ItemList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;

                            ItemTypeFilter::"Item Category":
                                begin
                                    ItemCategory.LookupMode := true;
                                    if ItemCategory.RunModal = ACTION::LookupOK then
                                        Text := ItemCategory.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    var
                    begin
                        Rec.SetFilter("Item Code", ItemCodeFilter);
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                    end;
                }
                field("Starting Date Filter"; StartingDateFilter)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        FilterTokens: Codeunit "Filter Tokens";
                    begin
                        FilterTokens.MakeDateFilter(StartingDateFilter);
                        CurrPage.SaveRecord;
                        if StartingDateFilter <> '' then
                            Rec.SetFilter("Start Date", StartingDateFilter)
                        else
                            Rec.SetRange("Start Date");
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(DataAll)
            {
                ShowCaption = false;
                field("Purchase Type"; Rec."Purchase Type")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        if Rec."Purchase Type" <> Rec."Purchase Type"::"All Vendor" then
                            Error('Quota by Amount only work for All Vendor');
                    end;
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        if Rec."Item Type" <> Rec."Item Type"::"Item Category" then
                            Error('Quota by Amount only work for Item Category');
                    end;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = all;
                }
                field("Maximum Amount"; Rec."Maximum Quantity")
                {
                    ApplicationArea = all;
                    Caption = 'Maximum Amount';

                    trigger OnValidate()
                    var
                        L_PurchBudgetSummary: Record "Purchase Budget Summary";
                        L_ItemCategory: Record "Item Category";
                    begin

                        CurrMonthPurch := GetPurchaseForCurrentMonth(Rec."Item Code", Rec."Start Date", Rec."End Date");
                        CMBudget := xRec."Maximum Quantity";
                        RemAmt := CMBudget - CurrMonthPurch;
                        DiffAmt := xRec."Maximum Quantity" - rec."Maximum Quantity";

                        if RemAmt < DiffAmt then begin
                            Error('You cannot reduce the amount more than the purchase made for the Item category code %1 within the period %2 to %3', rec."Item Code", rec."Start Date", rec."End Date")
                        end;

                    end;
                    // FIN-107
                }
                field("Amount Restriction"; Rec."Quantity Restriction")
                {
                    ApplicationArea = all;
                    Caption = 'Amount Restriction';
                    trigger OnValidate();
                    var
                    begin
                        if Rec."Quantity Restriction" <> Rec."Quantity Restriction"::"Per Month" then
                            Error('Quota by Amount only work for Per Month');

                        if Rec."Quantity Restriction" = Rec."Quantity Restriction"::"Per Month" then begin
                            NoOfMonthEdit := true;
                        end else begin
                            NoOfMonthEdit := false;
                            Clear(Rec."No of Months");
                            Clear(Rec."Start Date");
                            Clear(Rec."End Date");
                        end;
                    end;
                }
                field("No of Months"; Rec."No of Months")
                {
                    ApplicationArea = all;
                    Editable = NoOfMonthEdit;
                    trigger OnValidate()
                    var
                    begin
                        if (Format(Rec."No of Months") <> '') and (Format(Rec."No of Months") <> '1M') then begin
                            Error('No. of Months should always be 1M');
                        end;
                    end;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                        Day: Integer;
                    begin
                        Clear(Day);
                        if Rec."Start Date" <> 0D then begin
                            Day := Date2DMY(Rec."Start Date", 1);
                            if Day <> 1 then
                                Error('Start date should always be first of Month');
                        end;
                    end;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Warning Type"; rec."Warning Type")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Clear Filter")
            {
                ApplicationArea = All;
                Image = ClearFilter;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                begin
                    PurchaseTypeFilter := PurchaseTypeFilter::" ";
                    PurchaseCodeFilter := '';
                    ItemTypeFilter := ItemTypeFilter::" ";
                    ItemCodeFilter := '';
                    StartingDateFilter := '';
                    CurrPage.Update(false);
                    Rec.Reset();
                end;
            }
            // action(Open)
            // {
            //     Image = Open;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Visible = false;
            //     trigger OnAction()
            //     var
            //         RecSalesQuota: Record "Sales Quota";
            //     begin
            //         RecSalesQuota.Reset();
            //         RecSalesQuota.SetRange("Sales Type", Rec."Sales Type");
            //         RecSalesQuota.SetRange("Restriction Type", Rec."Restriction Type");
            //         RecSalesQuota.SetRange("Sales Code", Rec."Sales Code");
            //         RecSalesQuota.SetRange("Item Type", Rec."Item Type");
            //         RecSalesQuota.SetRange("Item Code", Rec."Item Code");
            //         RecSalesQuota.SetRange(Status, Rec.Status);
            //         if RecSalesQuota.FindFirst() then begin
            //             RecSalesQuota.Validate(Status, RecSalesQuota.Status::Open);
            //             //RecSalesQuota.Modify();
            //             CurrPage.Update();
            //         end;

            //     end;
            // }
            // action(Close)
            // {
            //     Image = Close;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Visible = false;
            //     trigger OnAction()
            //     var
            //         RecSalesQuota: Record "Sales Quota";
            //     begin
            //         RecSalesQuota.Reset();
            //         RecSalesQuota.SetRange("Sales Type", Rec."Sales Type");
            //         RecSalesQuota.SetRange("Restriction Type", Rec."Restriction Type");
            //         RecSalesQuota.SetRange("Sales Code", Rec."Sales Code");
            //         RecSalesQuota.SetRange("Item Type", Rec."Item Type");
            //         RecSalesQuota.SetRange("Item Code", Rec."Item Code");
            //         RecSalesQuota.SetRange(Status, Rec.Status);
            //         if RecSalesQuota.FindFirst() then begin
            //             RecSalesQuota.Validate(Status, RecSalesQuota.Status::Close);
            //             //RecSalesQuota.Modify();
            //             CurrPage.Update();
            //         end;
            //     end;
            // }
        }
    }


    var
        PurchaseTypeFilter: Option " ","All Vendor",Vendor;
        ItemTypeFilter: Option " ","All Items","Item","Item Category";
        PurchaseCodeFilter: Text;
        ItemCodeFilter: Text;
        StartingDateFilter: Text[30];
        NoOfMonthEdit: Boolean;
        ItemCate: Page "Item Categories";
        CurrMonthPurch: Decimal;
        CMBudget: Decimal;
        RemAmt: Decimal;
        DiffAmt: Decimal;
    // FIN-107
    trigger OnOpenPage()
    var
    begin
        Rec.SetRange("Restriction Type", Rec."Restriction Type"::"By Amount");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
    begin
        Rec.Validate("Restriction Type", Rec."Restriction Type"::"By Amount");
    end;

    trigger OnAfterGetCurrRecord()
    var
    begin
        if Rec."Quantity Restriction" = Rec."Quantity Restriction"::"Per Month" then begin
            NoOfMonthEdit := true;
        end else begin
            NoOfMonthEdit := false;
        end;
    end;

    /* procedure getitemfilterCustomer(GlobalFIlterSalesCOde: Text)
        var
        begin
        SalesCodeFilter := GlobalFIlterSalesCOde;

        end;*/

    /*
    local procedure DefaultRestriction()
    var
    begin
            Rec.Validate("Restriction Type", Rec."Restriction Type"::"By Amount");
            //CurrPage.Update();
            //Rec.Modify();
    end;
        */

    // local procedure GetBudgetFromPurchQuota(CategoryCode: Code[20]; MonthStartDate: Date; MonthEndDate: Date): Decimal
    // var
    //     L_PurchaseQuotaByAmt: Record "Purchase Quota";
    // begin
    //     L_PurchaseQuotaByAmt.Reset();
    //     L_PurchaseQuotaByAmt.SetRange("Purchase Type", L_PurchaseQuotaByAmt."Purchase Type"::"All Vendor");
    //     L_PurchaseQuotaByAmt.SetRange("Item Type", L_PurchaseQuotaByAmt."Item Type"::"Item Category");
    //     L_PurchaseQuotaByAmt.SetRange("Item Code", CategoryCode);
    //     if L_PurchaseQuotaByAmt.FindSet() then begin
    //         repeat
    //             if (Today >= L_PurchaseQuotaByAmt."Start Date") and (Today <= L_PurchaseQuotaByAmt."End Date") then
    //                 exit(L_PurchaseQuotaByAmt."Maximum Quantity");
    //         until L_PurchaseQuotaByAmt.Next() = 0;
    //     end;
    // end;

    local procedure GetPurchaseForCurrentMonth(CategoryCode: Code[20]; MonthStartDate: Date; MonthEndDate: Date): Decimal
    var
        CurrentMonthPurchase: Decimal;
        PurchaseLine: Record "Purchase Line";
        AmountFromILE: Decimal;
        L_PurchRcptLine: Record "Purch. Rcpt. Line";
    begin

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Parent Category", CategoryCode);
        PurchaseLine.SetFilter("Custom Order Date", '%1..%2', MonthStartDate, MonthEndDate);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then begin
            PurchaseLine.CalcSums("Outstanding Amt. Ex. VAT (LCY)");
            CurrentMonthPurchase += PurchaseLine."Outstanding Amt. Ex. VAT (LCY)";
        end;

        Clear(AmountFromILE);
        L_PurchRcptLine.Reset();
        L_PurchRcptLine.SetRange(Type, L_PurchRcptLine.Type::Item);
        L_PurchRcptLine.SetRange("Parent Category", CategoryCode);
        L_PurchRcptLine.SetFilter("Budget Receipt Date", '%1..%2', MonthStartDate, MonthEndDate);
        L_PurchRcptLine.SetFilter(Quantity, '>0');
        if L_PurchRcptLine.FindSet() then begin
            repeat
                AmountFromILE := AmountFromILE + L_PurchRcptLine."Unit Cost (LCY)" * L_PurchRcptLine.Quantity;
            until L_PurchRcptLine.Next() = 0;
            CurrentMonthPurchase += AmountFromILE;
        end;

        if CurrentMonthPurchase > 0 then
            exit(CurrentMonthPurchase);
    end;
    // FIN-107
}