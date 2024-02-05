tableextension 60602 "ISQ Sales Line" extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(60600; "Sales Quota Approval"; Boolean)
        {
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