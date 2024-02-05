tableextension 60600 "ISQ Sales Header" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(60600; "Sales Quota Approval"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "Sales Quota Approval" = const(true)));
            Caption = 'Sales Quota Approval Required';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}