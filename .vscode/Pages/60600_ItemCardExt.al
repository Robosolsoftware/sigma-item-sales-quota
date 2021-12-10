pageextension 60600 ItemCardSalesQ extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Item Tracing")
        {
            group("Sales Quota")

            {
                Image = Sales;
                action("Quota By Quantity")
                {
                    Caption = 'Quota By Quantity';
                    Image = ItemAvailability;
                    RunObject = Page 60602;
                    RunPageLink = "Item Code" = FIELD("No.");
                    ApplicationArea = all;
                }
                action("Quota By Amount")
                {
                    Caption = 'Quota By Amount';
                    Image = ItemAvailability;
                    RunObject = Page 60603;
                    RunPageLink = "Item Code" = FIELD("No.");
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        myInt: Integer;
}