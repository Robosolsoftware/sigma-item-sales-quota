pageextension 60604 UserSetupSalesQ extends "User Setup"
{
    layout
    {
        addbefore("Salespers./Purch. Code")
        {
            field("SO Override MaxQty Calculation"; Rec."SO Override MaxQty Calculation")
            {
                ApplicationArea = all;
            }
            field("PO Override MaxQty Calculation"; Rec."PO Override MaxQty Calculation")
            {
                ApplicationArea = All;
            }
            field("Allowed Quota Manag. for CD"; Rec."Allowed Quota Manag. for CD")
            {
                ApplicationArea = All;
                ToolTip = 'Specify if you want user who edit/add/remove CD product on sales quota by quantity';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}