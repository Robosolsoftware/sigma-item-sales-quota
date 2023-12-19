pageextension 60604 UserSetupSalesQ extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {
            field("SO Override MaxQty Calculation"; Rec."SO Override MaxQty Calculation")
            {
                ApplicationArea = all;
            }
            field("PO Override MaxQty Calculation"; Rec."PO Override MaxQty Calculation")
            {
                ApplicationArea = All;
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