tableextension 60602 "ISQ Sales Line" extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(60600; "Sales Quota Approval"; Boolean)
        {
            Caption = 'Sales Quota Approval Required';
        }

        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                RecUserSetup: Record "User Setup";
                AllEvent: Codeunit "All Event";
            begin
                if Rec.Quantity > 0 then begin
                    IF RecUserSetup.GET(USERID) THEN BEGIN
                        IF NOT RecUserSetup."SO Override MaxQty Calculation" THEN BEGIN
                            AllEvent.CheckMaxOrderQty2(Rec);
                        END;
                    END ELSE BEGIN
                        AllEvent.CheckMaxOrderQty2(Rec);
                    END;
                end;
            end;
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