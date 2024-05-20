// page 60605 "Sales Quota"
// {
//     DelayedInsert = true;
//     PageType = Worksheet;

//     SourceTable = "Sales Quota";

//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Sales Type"; Rec."Sales Type")
//                 {
//                     ApplicationArea = all;

//                     trigger OnValidate()
//                     begin
//                         CLEAR(EditCustomerNo);
//                         IF Rec."Sales Type" = Rec."Sales Type"::"All Customer" THEN
//                             EditCustomerNo := FALSE
//                         ELSE
//                             EditCustomerNo := TRUE;
//                     end;
//                 }
//                 field("Sales Code"; Rec."Sales Code")
//                 {
//                     Editable = EditCustomerNo;
//                     ApplicationArea = all;
//                 }
//                 field("Item Code"; Rec."Item Code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Item Description"; Rec."Item Description")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Ship-to Code"; Rec."Ship-to Code")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Maximum Quantity"; Rec."Maximum Quantity")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("Quantity Restriction"; Rec."Quantity Restriction")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("B2B Nav Maximum Order Id"; Rec."B2B Nav Maximum Order Id")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("B2B Nav Maximum Order IdV3"; Rec."B2B Nav Maximum Order IdV3")
//                 {
//                     ApplicationArea = all;
//                     Visible = false;
//                 }
//                 field("Start Date"; Rec."Start Date")
//                 {
//                     ApplicationArea = all;
//                 }
//                 field("End Date"; Rec."End Date")
//                 {
//                     ApplicationArea = all;
//                 }
//             }
//         }
//     }


//     var
//         EditCustomerNo: Boolean;
//         EditItemNo: Boolean;

// }

