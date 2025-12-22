pageextension 60605 "ISQ Purchase Lines" extends "Purchase Lines"
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
            field("Outstanding Amt. Ex. VAT (LCY)"; Rec."Outstanding Amt. Ex. VAT (LCY)")
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