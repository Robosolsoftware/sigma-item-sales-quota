query 60605 "PO DayReceived Amt"
{

    elements
    {
        dataitem(QueryElement1000000000; "Purch. Inv. Header")
        {
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            dataitem(QueryElement1000000001; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = QueryElement1000000000."No.";
                DataItemTableFilter = Type = FILTER(Item);
                column(No; "No.")
                {
                }
                column(Item_Category_Code; "Child Category")
                {

                }
                column(Sum_Amt; "Line Amount")
                {
                    Method = Sum;
                }
            }
        }
    }
}

