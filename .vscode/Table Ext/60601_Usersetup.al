tableextension 60601 UserSetupSalesQ extends "User Setup"
{
    fields
    {
        field(60600; "SO Override MaxQty Calculation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'SO Override Max. Qty. Calculation';
        }
        field(60602; "PO Override MaxQty Calculation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'PO Override Max. Qty. Calculation';
        }
        field(60603; "Allowed Quota Manag. for CD"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Allowed Quota Management for CD';
        }
    }

    var
        myInt: Integer;
}