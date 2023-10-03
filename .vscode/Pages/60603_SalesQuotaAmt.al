page 60603 "Quota By Amount"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    ObsoleteState = Pending;
    SourceTable = "Sales Quota";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Sales Type Filter"; SalesTypeFilter)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        /*if SalesTypeFilter = SalesTypeFilter::Customer then begin
                            SetRange("Sales Type", Rec."Sales Type"::Customer);
                        end
                        else
                            if SalesTypeFilter = SalesTypeFilter::"All Customer" then begin
                                SetRange("Sales Type", Rec."Sales Type"::"All Customer");
                            end else begin
                                SetRange("Sales Type", Rec."Sales Type"::"Customer Price Group");
                            end;*/
                        //if SalesTypeFilter = SalesTypeFilter::" " then begin
                        //   SetFilter("Sales Type", '%1|%2|%3', SalesTypeFilter::"All Customer", SalesTypeFilter::Customer, SalesTypeFilter::"Customer Price Group");
                        //end else begin
                        Rec.SetRange("Sales Type", SalesTypeFilter);
                        CurrPage.SaveRecord();
                        CurrPage.Update(false);
                        //end;
                    end;

                }
                field("Sales Code Filter"; SalesCodeFilter)
                {
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustList: Page "Customer List";
                        CustPriceGrList: Page "Customer Price Groups";
                        CampaignList: Page "Campaign List";
                    begin
                        if SalesTypeFilter = SalesTypeFilter::"All Customer" then
                            exit;
                        if SalesTypeFilter = SalesTypeFilter::" " then
                            exit;

                        case SalesTypeFilter of
                            SalesTypeFilter::Customer:
                                begin
                                    CustList.LookupMode := true;
                                    if CustList.RunModal = ACTION::LookupOK then
                                        Text := CustList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            SalesTypeFilter::"Customer Price Group":
                                begin
                                    CustPriceGrList.LookupMode := true;
                                    if CustPriceGrList.RunModal = ACTION::LookupOK then
                                        Text := CustPriceGrList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;

                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        Rec.SetFilter("Sales Code", SalesCodeFilter);
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
                field("Restriction Type"; Rec."Restriction Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                    begin
                        //DefaultRestriction();
                    end;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = all;
                }
                field("Sales Name"; Rec."Sales Name")
                {
                    ApplicationArea = all;
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = all;
                }
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = all;
                }
                field("Warehouse Class code"; rec."Warehouse Class code")
                {
                    ApplicationArea = all;
                }
                field("Item Description"; Rec."Item Description")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = all;
                }
                field("Maximum Amount"; Rec."Maximum Quantity")
                {
                    ApplicationArea = all;
                    Caption = 'Maximum Amount';
                }
                field("Amount Restriction"; Rec."Quantity Restriction")
                {
                    ApplicationArea = all;
                    Caption = 'Amount Restriction';
                    trigger OnValidate();
                    var
                    begin
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
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = all;
                    //Editable = false;CAS-28103-W6D1M0
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    /*
    actions
    {
        area(Processing)
        {
            action(Open)
            {
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                trigger OnAction()
                var
                    RecSalesQuota: Record "Sales Quota";
                begin
                    RecSalesQuota.Reset();
                    RecSalesQuota.SetRange("Sales Type", Rec."Sales Type");
                    RecSalesQuota.SetRange("Restriction Type", Rec."Restriction Type");
                    RecSalesQuota.SetRange("Sales Code", Rec."Sales Code");
                    RecSalesQuota.SetRange("Item Type", Rec."Item Type");
                    RecSalesQuota.SetRange("Item Code", Rec."Item Code");
                    RecSalesQuota.SetRange(Status, Rec.Status);
                    if RecSalesQuota.FindFirst() then begin
                        RecSalesQuota.Validate(Status, RecSalesQuota.Status::Open);
                        //RecSalesQuota.Modify();
                        CurrPage.Update();
                    end;

                end;
            }
            action(Close)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                trigger OnAction()
                var
                    RecSalesQuota: Record "Sales Quota";
                begin
                    RecSalesQuota.Reset();
                    RecSalesQuota.SetRange("Sales Type", Rec."Sales Type");
                    RecSalesQuota.SetRange("Restriction Type", Rec."Restriction Type");
                    RecSalesQuota.SetRange("Sales Code", Rec."Sales Code");
                    RecSalesQuota.SetRange("Item Type", Rec."Item Type");
                    RecSalesQuota.SetRange("Item Code", Rec."Item Code");
                    RecSalesQuota.SetRange(Status, Rec.Status);
                    if RecSalesQuota.FindFirst() then begin
                        RecSalesQuota.Validate(Status, RecSalesQuota.Status::Close);
                        //RecSalesQuota.Modify();
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }
    */



    var
        myInt: Integer;

        SalesTypeFilter: Option " ","All Customer",Customer,"Customer Price Group";
        ItemTypeFilter: Option "All Items","Item","Item Category";
        SalesCodeFilter: Text;
        ItemCodeFilter: Text;
        StartingDateFilter: Text[30];
        NoOfMonthEdit: Boolean;


    trigger OnOpenPage()
    var
    begin
        Rec.SetRange("Restriction Type", Rec."Restriction Type"::"By Amount");
    end;


    /*trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
        Rec.Validate("Restriction Type", Rec."Restriction Type"::"By Amount");
    end;
    */


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
            //Clear(Rec."No of Months");
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
}