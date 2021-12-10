pageextension 60604 UserSetupSalesQ extends "User Setup"
{
    layout
    {
        addafter(PhoneNo)
        {
            field("Override Max. Qty. Calculation"; Rec."Override Max. Qty. Calculation")
            {
                ApplicationArea = all;
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