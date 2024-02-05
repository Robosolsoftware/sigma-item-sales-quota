pageextension 60603 "ISQ Sales Order" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Sales Quota Approval"; Rec."Sales Quota Approval")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Sales Quota Approval Required';
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