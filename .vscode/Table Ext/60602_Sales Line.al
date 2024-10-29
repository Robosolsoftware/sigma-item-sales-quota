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
                L_SalesHeader: Record "Sales Header";
            begin
                //Added IRP = false order to ignore quota validation in consolidation from Web order+++
                //For Web Orders Quota Validation we have managed on codeunit 90203 "Manage Time duration" Ochannel Extension]  
                L_SalesHeader.Reset();
                L_SalesHeader.SetRange("Document Type", Rec."Document Type");
                L_SalesHeader.SetRange("No.", Rec."Document No.");
                if L_SalesHeader.FindFirst() then begin
                    if L_SalesHeader."IRP Order" = false then begin
                        if L_SalesHeader."Document Type" <> L_SalesHeader."Document Type"::"Return Order" then begin
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

                    end;
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