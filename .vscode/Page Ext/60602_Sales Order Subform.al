pageextension 60602 "ISQ Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Pallet Qty.")
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