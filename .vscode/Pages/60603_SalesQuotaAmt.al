// page 60603 "Quota By Amount"
// {
//     ApplicationArea = All;
//     UsageCategory = Administration;
//     DelayedInsert = true;
//     PageType = List;
//     SaveValues = true;
//     ObsoleteState = Pending;
//     SourceTable = "Sales Quota";
//     Caption = 'Sales Quota By Amount';


//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 field("Sales Type Filter"; SalesTypeFilter)
//                 {
//                     ApplicationArea = All;
//                     trigger OnValidate()
//                     begin
//                         UpdateFilter();
//                     end;

//                 }
//                 field("Sales Code Filter"; SalesCodeFilter)
//                 {
//                     ApplicationArea = all;
//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         CustList: Page "Customer List";
//                         CustPriceGrList: Page "Customer Price Groups";
//                         CampaignList: Page "Campaign List";
//                         L_DimensionList: Page Dimensions;
//                         L_Dimesion: Record Dimension;
//                     begin
//                         if SalesTypeFilter = SalesTypeFilter::"All Customer" then
//                             exit;
//                         if SalesTypeFilter = SalesTypeFilter::" " then
//                             exit;

//                         case SalesTypeFilter of
//                             SalesTypeFilter::Customer:
//                                 begin
//                                     CustList.LookupMode := true;
//                                     if CustList.RunModal = ACTION::LookupOK then
//                                         Text := CustList.GetSelectionFilter
//                                     else
//                                         exit(false);
//                                 end;
//                             SalesTypeFilter::"Customer Price Group":
//                                 begin
//                                     CustPriceGrList.LookupMode := true;
//                                     if CustPriceGrList.RunModal = ACTION::LookupOK then
//                                         Text := CustPriceGrList.GetSelectionFilter
//                                     else
//                                         exit(false);
//                                 end;
//                             SalesTypeFilter::Dimension:
//                                 begin
//                                     L_Dimesion.Reset();
//                                     L_DimensionList.LookupMode := true;
//                                     L_DimensionList.SetTableView(L_Dimesion);
//                                     if L_DimensionList.RunModal = ACTION::LookupOK then begin
//                                         L_DimensionList.GetRecord(L_Dimesion);
//                                         Text := L_Dimesion.Code;
//                                     end else
//                                         exit(false);
//                                 end;

//                         end;

//                         exit(true);
//                     end;

//                     trigger OnValidate()
//                     begin
//                         UpdateFilter();
//                     end;
//                 }
//                 field("Item Type Filter"; ItemTypeFilter)
//                 {
//                     ApplicationArea = all;
//                     trigger OnValidate()
//                     var
//                     begin
//                         UpdateFilter();
//                     end;
//                 }
//                 field("Item Code Filter"; ItemCodeFilter)
//                 {
//                     ApplicationArea = all;
//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         ItemList: Page "Item List";
//                         ItemCategory: Page "Item Categories";
//                     begin

//                         if ItemTypeFilter = ItemTypeFilter::"All Items" then
//                             exit;

//                         case ItemTypeFilter of

//                             ItemTypeFilter::Item:
//                                 begin

//                                     ItemList.LookupMode := true;
//                                     if ItemList.RunModal = ACTION::LookupOK then
//                                         Text := ItemList.GetSelectionFilter
//                                     else
//                                         exit(false);
//                                 end;

//                             ItemTypeFilter::"Item Category":
//                                 begin
//                                     ItemCategory.LookupMode := true;
//                                     if ItemCategory.RunModal = ACTION::LookupOK then
//                                         Text := ItemCategory.GetSelectionFilter
//                                     else
//                                         exit(false);
//                                 end;
//                         end;

//                         exit(true);
//                     end;

//                     trigger OnValidate()
//                     var
//                     begin
//                         UpdateFilter();
//                     end;

//                 }
//                 field("Starting Date Filter"; StartingDateFilter)
//                 {
//                     ApplicationArea = all;
//                     trigger OnValidate()
//                     begin
//                         UpdateFilter();
//                     end;

//                 }

//             }
//             repeater(LinesDetails)
//             {
//                 ShowCaption = true;
//                 Caption = 'Line Details';
//                 field("Restriction Type"; Rec."Restriction Type")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Sales Type"; Rec."Sales Type")
//                 {
//                     ApplicationArea = all;
//                     ToolTip = 'Specifies the sales type based on the priority: "Customer", "Dimension", "All Customer", "Customer Price Group"';
//                 }
//                 field("Sales Code"; Rec."Sales Code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Sales Name"; Rec."Sales Name")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Dimension Value"; Rec."Dimension Value")
//                 {
//                     ApplicationArea = All;
//                     ToolTip = 'This is only for Dimension';
//                     Editable = Rec."Sales Type" = Rec."Sales Type"::Dimension;
//                 }
//                 field("Item Type"; Rec."Item Type")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Item Code"; Rec."Item Code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Warehouse Class code"; rec."Warehouse Class code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Item Description"; Rec."Item Description")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Unit of Measure Code"; Rec."Unit of Measure Code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Ship-to Code"; Rec."Ship-to Code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Maximum Amount"; Rec."Maximum Quantity")
//                 {
//                     ApplicationArea = all;
//                     Caption = 'Maximum Amount';
//                 }
//                 field("Amount Restriction"; Rec."Quantity Restriction")
//                 {
//                     ApplicationArea = all;
//                     Caption = 'Amount Restriction';
//                     trigger OnValidate();
//                     var
//                     begin
//                         if Rec."Quantity Restriction" = Rec."Quantity Restriction"::"Per Month" then begin
//                             NoOfMonthEdit := true;
//                         end else begin
//                             NoOfMonthEdit := false;
//                             Clear(Rec."No of Months");
//                             Clear(Rec."Start Date");
//                             Clear(Rec."End Date");
//                         end;
//                     end;
//                 }
//                 field("No of Months"; Rec."No of Months")
//                 {
//                     ApplicationArea = all;
//                     Editable = NoOfMonthEdit;
//                 }
//                 field("Start Date"; Rec."Start Date")
//                 {
//                     ApplicationArea = all;
//                     //Editable = false;CAS-28103-W6D1M0
//                 }
//                 field("End Date"; Rec."End Date")
//                 {
//                     ApplicationArea = all;
//                     Editable = false;
//                 }

//                 field("External Document No."; Rec."External Document No.")
//                 {
//                     ApplicationArea = all;
//                 }
//             }
//         }
//     }
//     /*
//     actions
//     {
//         area(Processing)
//         {
//             action(Open)
//             {
//                 Image = Open;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Visible = false;
//                 trigger OnAction()
//                 var
//                     RecSalesQuota: Record "Sales Quota";
//                 begin
//                     RecSalesQuota.Reset();
//                     RecSalesQuota.SetRange("Sales Type", Rec."Sales Type");
//                     RecSalesQuota.SetRange("Restriction Type", Rec."Restriction Type");
//                     RecSalesQuota.SetRange("Sales Code", Rec."Sales Code");
//                     RecSalesQuota.SetRange("Item Type", Rec."Item Type");
//                     RecSalesQuota.SetRange("Item Code", Rec."Item Code");
//                     RecSalesQuota.SetRange(Status, Rec.Status);
//                     if RecSalesQuota.FindFirst() then begin
//                         RecSalesQuota.Validate(Status, RecSalesQuota.Status::Open);
//                         //RecSalesQuota.Modify();
//                         CurrPage.Update();
//                     end;

//                 end;
//             }
//             action(Close)
//             {
//                 Image = Close;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Visible = false;
//                 trigger OnAction()
//                 var
//                     RecSalesQuota: Record "Sales Quota";
//                 begin
//                     RecSalesQuota.Reset();
//                     RecSalesQuota.SetRange("Sales Type", Rec."Sales Type");
//                     RecSalesQuota.SetRange("Restriction Type", Rec."Restriction Type");
//                     RecSalesQuota.SetRange("Sales Code", Rec."Sales Code");
//                     RecSalesQuota.SetRange("Item Type", Rec."Item Type");
//                     RecSalesQuota.SetRange("Item Code", Rec."Item Code");
//                     RecSalesQuota.SetRange(Status, Rec.Status);
//                     if RecSalesQuota.FindFirst() then begin
//                         RecSalesQuota.Validate(Status, RecSalesQuota.Status::Close);
//                         //RecSalesQuota.Modify();
//                         CurrPage.Update();
//                     end;
//                 end;
//             }
//         }
//     }
//     */



//     var
//         myInt: Integer;

//         SalesTypeFilter: Option " ","All Customer",Customer,"Customer Price Group",Dimension;
//         ItemTypeFilter: Option " ","All Items","Item","Item Category";
//         SalesCodeFilter: Text;
//         ItemCodeFilter: Text;
//         StartingDateFilter: Text[30];
//         NoOfMonthEdit: Boolean;


//     local procedure UpdateFilter()
//     var
//         FilterTokens: Codeunit "Filter Tokens";
//     begin
//         if SalesTypeFilter <> SalesTypeFilter::" " then
//             Rec.SetRange("Sales Type", SalesTypeFilter)
//         else
//             Rec.SetRange("Sales Type");

//         if SalesCodeFilter <> '' then
//             Rec.SetRange("Sales Code", SalesCodeFilter)
//         else
//             Rec.SetRange("Sales Code");

//         if ItemTypeFilter <> ItemTypeFilter::" " then
//             Rec.SetRange("Item Type", ItemTypeFilter)
//         else
//             Rec.SetRange("Item Type");

//         if ItemCodeFilter <> '' then
//             Rec.SetRange("Item Code", ItemCodeFilter)
//         else
//             Rec.SetRange("Item Code");

//         FilterTokens.MakeDateFilter(StartingDateFilter);
//         if StartingDateFilter <> '' then
//             Rec.SetFilter("Start Date", StartingDateFilter)
//         else
//             Rec.SetRange("Start Date");

//         CurrPage.SaveRecord();
//         CurrPage.Update(false);
//     end;


//     trigger OnOpenPage()
//     var
//     begin
//         Rec.SetRange("Restriction Type", Rec."Restriction Type"::"By Amount");
//     end;


//     /*trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     var
//     begin
//         Rec.Validate("Restriction Type", Rec."Restriction Type"::"By Amount");
//     end;
//     */


//     trigger OnNewRecord(BelowxRec: Boolean)
//     var
//     begin
//         Rec.Validate("Restriction Type", Rec."Restriction Type"::"By Amount");
//     end;

//     trigger OnAfterGetCurrRecord()
//     var
//     begin
//         if Rec."Quantity Restriction" = Rec."Quantity Restriction"::"Per Month" then begin
//             NoOfMonthEdit := true;
//         end else begin
//             NoOfMonthEdit := false;
//             //Clear(Rec."No of Months");
//         end;
//     end;

//     /* procedure getitemfilterCustomer(GlobalFIlterSalesCOde: Text)
//      var
//      begin
//          SalesCodeFilter := GlobalFIlterSalesCOde;

//      end;*/

//     /*
//     local procedure DefaultRestriction()
//     var
//     begin
//         Rec.Validate("Restriction Type", Rec."Restriction Type"::"By Amount");
//         //CurrPage.Update();
//         //Rec.Modify();
//     end;
//     */
// }