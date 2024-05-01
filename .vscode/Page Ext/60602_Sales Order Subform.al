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

        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                RecUserSetup: Record "User Setup";
                SalesQuotaManagement: Codeunit "All Event";
            begin
                //This code for Maunal Sales Order++
                CurrPage.Update();
                if Rec.Quantity <> 0 then begin
                    IF RecUserSetup.GET(USERID) THEN BEGIN
                        IF NOT RecUserSetup."SO Override MaxQty Calculation" THEN BEGIN
                            SalesQuotaManagement.CheckMaxOrderQty2(Rec);
                        END;
                    END ELSE BEGIN
                        SalesQuotaManagement.CheckMaxOrderQty2(Rec);
                    END;
                end;
            end;
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}