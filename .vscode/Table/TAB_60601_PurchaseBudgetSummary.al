table 60601 "Purchase Budget Summary"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Item Category"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Budget CM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Purchase CM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Remaining CM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Purchase LM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "+2M Purchase"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Indentation; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Presentation Order"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
        key(Key2; "Presentation Order")
        {

        }
    }

    procedure GetStyleText(): Text
    begin
        if Indentation = 0 then
            exit('Strong');

        if HasChildren() then
            exit('Strong');

        exit('');
    end;

    procedure HasChildren(): Boolean
    var
        ItemCategory: Record "Item Category";
    begin
        ItemCategory.SetRange("Parent Category", Rec."Item Category");
        exit(not ItemCategory.IsEmpty)
    end;
}