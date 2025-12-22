pageextension 60607 "ISQ Purchase Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Line Amount")
        {
            field("Custom Order Date"; Rec."Custom Order Date")
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