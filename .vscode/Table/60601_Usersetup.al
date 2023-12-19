tableextension 60601 UserSetupSalesQ extends "User Setup"
{
    fields
    {
        field(80700; "SO Override MaxQty Calculation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'SO Override Max. Qty. Calculation';
        }
        field(80701; "PO Override MaxQty Calculation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'PO Override Max. Qty. Calculation';
        }
    }

    var
        myInt: Integer;
}