tableextension 60601 UserSetupSalesQ extends "User Setup"
{
    fields
    {
        field(80700; "Override Max. Qty. Calculation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}