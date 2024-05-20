pageextension 60601 CustCardSalesQ extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(PaymentRegistration)
        {
            /*action("Max. Order Quantity")
            {
                Caption = 'Sales Quota';
                Image = ItemAvailability;
                RunObject = Page 80700;
                RunPageLink = "Sales Code" = FIELD("No.");
                ApplicationArea = all;
            }
            */
            group("Sales Quota")

            {
                Image = Sales;
                action("Quota By Quantity")
                {
                    Caption = 'Quota By Quantity';
                    Image = ItemAvailability;
                    RunObject = Page 60602;
                    RunPageLink = "Sales Code" = FIELD("No.");
                    ApplicationArea = all;

                    /*
                    trigger OnAction()
                    var
                        QuotaByQty: Page 80704;
                        RecSalesQuota: Record "Sales Quota";
                    begin
                        Clear(QuotaByQty);
                        RecSalesQuota.Reset();
                        RecSalesQuota.SetRange("Restriction Type", RecSalesQuota."Restriction Type"::"By Quantity");
                        RecSalesQuota.SetRange("Sales Code", Rec."No.");
                        if RecSalesQuota.FindSet() then begin
                            QuotaByQty.SetTableView(RecSalesQuota);
                            QuotaByQty.getitemfilterCustomer(Rec."No.");
                            QuotaByQty.Run();
                        end;
                    end;*/
                }
                // action("Quota By Amount")
                // {
                //     Caption = 'Quota By Amount';
                //     Image = ItemAvailability;
                //     RunObject = Page 60603;
                //     RunPageLink = "Sales Code" = FIELD("No.");
                //     ApplicationArea = all;
                //     /* trigger OnAction()
                //      var
                //          QuotaByQty: Page 80705;
                //          RecSalesQuota: Record "Sales Quota";
                //      begin
                //          Clear(QuotaByQty);
                //          RecSalesQuota.Reset();
                //          RecSalesQuota.SetRange("Restriction Type", RecSalesQuota."Restriction Type"::"By Quantity");
                //          RecSalesQuota.SetRange("Sales Code", Rec."No.");
                //          if RecSalesQuota.FindSet() then begin
                //              QuotaByQty.SetTableView(RecSalesQuota);
                //              QuotaByQty.getitemfilterCustomer(Rec."No.");
                //              QuotaByQty.Run();
                //          end;
                //      end;
                //      */
                // }
            }
        }
    }

    var
        myInt: Integer;
}