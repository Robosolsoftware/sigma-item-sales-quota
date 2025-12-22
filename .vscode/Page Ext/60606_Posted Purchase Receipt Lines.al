pageextension 60606 "ISQ Posted Puh Receipt Lines" extends "Posted Purchase Receipt Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("Custom Order Date"; Rec."Custom Order Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Item Charge Base Amount"; Rec."Item Charge Base Amount")
            {
                ApplicationArea = All;
                Editable = false;
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