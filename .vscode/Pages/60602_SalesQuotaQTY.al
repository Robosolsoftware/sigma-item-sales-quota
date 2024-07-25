page 60602 "Quota By Quantity"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Sales Quota";
    Caption = 'Sales Quota By Quantity';

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
                    begin
                        UpdateFilter();
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
                        L_DimensionList: Page Dimensions;
                        L_Dimesion: Record Dimension;
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
                            SalesTypeFilter::Dimension:
                                begin
                                    L_Dimesion.Reset();
                                    L_DimensionList.LookupMode := true;
                                    L_DimensionList.SetTableView(L_Dimesion);
                                    if L_DimensionList.RunModal = ACTION::LookupOK then begin
                                        L_DimensionList.GetRecord(L_Dimesion);
                                        Text := L_Dimesion.Code;
                                    end else
                                        exit(false);
                                end;

                        end;
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        UpdateFilter();
                    end;
                }
                field("Item Type Filter"; ItemTypeFilter)
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    var
                    begin
                        UpdateFilter();
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
                        UpdateFilter();
                    end;

                }
                field("Starting Date Filter"; StartingDateFilter)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        UpdateFilter();
                    end;
                }

            }
            repeater(LinesDetails)
            {
                ShowCaption = true;
                Caption = 'Line Details';
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = all;

                    ToolTip = 'Specifies the sales type based on the priority: "Customer", "Dimension", "All Customer", "Customer Price Group"';
                }
                field("Sales Code"; Rec."Sales Code")
                {

                    ApplicationArea = All;
                }
                field("Sales Name"; Rec."Sales Name")
                {

                    ApplicationArea = all;
                }
                field("Dimension Value"; Rec."Dimension Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'This is only for Dimension';
                    Editable = Rec."Sales Type" = Rec."Sales Type"::Dimension;
                }
                field("Item Type"; Rec."Item Type")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the Item Type based on the priority: "Item", "All Item", "Item Category".';
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
                    Editable = false;
                }
                field("Maximum Quantity"; Rec."Maximum Quantity")
                {

                    ApplicationArea = all;
                }
                field("Warning Type"; rec."Warning Type")
                {

                    ApplicationArea = all;
                }
                field("Quantity Restriction"; Rec."Quantity Restriction")
                {

                    ApplicationArea = all;
                    ToolTip = 'Specifies the Quantity Restriction based on the priority: "Exception Per Day","Per Order","Per Day","Per Month".';
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
                    Editable = (Rec."Quantity Restriction" = Rec."Quantity Restriction"::"Per Month") OR (Rec."Quantity Restriction" = Rec."Quantity Restriction"::"Exception Per Day");
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = all;
                    Editable = Rec."Quantity Restriction" = Rec."Quantity Restriction"::"Exception Per Day";
                }

                field("External Document No."; Rec."External Document No.")
                {

                    ApplicationArea = all;
                }

            }
        }

        area(FactBoxes)
        {

            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }


    local procedure UpdateFilter()
    var
        FilterTokens: Codeunit "Filter Tokens";
    begin
        if SalesTypeFilter <> SalesTypeFilter::" " then
            Rec.SetRange("Sales Type", SalesTypeFilter)
        else
            Rec.SetRange("Sales Type");

        if SalesCodeFilter <> '' then
            Rec.SetRange("Sales Code", SalesCodeFilter)
        else
            Rec.SetRange("Sales Code");

        if ItemTypeFilter <> ItemTypeFilter::" " then
            Rec.SetRange("Item Type", ItemTypeFilter)
        else
            Rec.SetRange("Item Type");

        if ItemCodeFilter <> '' then
            Rec.SetRange("Item Code", ItemCodeFilter)
        else
            Rec.SetRange("Item Code");

        FilterTokens.MakeDateFilter(StartingDateFilter);
        if StartingDateFilter <> '' then
            Rec.SetFilter("Start Date", StartingDateFilter)
        else
            Rec.SetRange("Start Date");

        CurrPage.SaveRecord();
        CurrPage.Update(false);
    end;




    var
        myInt: Integer;
        Salesorder: Page "Item List";

        SalesTypeFilter: Option " ","All Customer",Customer,"Customer Price Group",Dimension;
        ItemTypeFilter: Option " ","All Items","Item","Item Category";
        SalesCodeFilter: Text;
        SalesCodeFilter2: Text;
        ItemCodeFilter: Text;
        StartingDateFilter: Text[30];
        NoOfMonthEdit: Boolean;


    /*trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
        Rec.Validate("Restriction Type", Rec."Restriction Type"::"By Quantity");
    end;
    */
    trigger OnNewRecord(BelowxRec: Boolean)
    var
    begin
        Rec.Validate("Restriction Type", Rec."Restriction Type"::"By Quantity");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Quantity Restriction" = Rec."Quantity Restriction"::"Per Month" then begin
            NoOfMonthEdit := true;
        end else begin
            NoOfMonthEdit := false;
            //Clear(Rec."No of Months");
        end;
    end;

    /*procedure getitemfilterCustomer(GlobalFIlterSalesCOde: Text)
    var
    begin
        SalesCodeFilter2 := GlobalFIlterSalesCOde;

    end;
    */
    /*local procedure DefaultRestriction()
    var
    begin
        Rec."Restriction Type" := Rec."Restriction Type"::"By Quantity";
        //Rec.Modify();
    end;
    */
}