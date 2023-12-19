query 60604 "PO Daywise order Amt"
{

    elements
    {
        dataitem(QueryElement1000000000; 38)
        {
            column(Document_Type; "Document Type")
            {
            }
            column(Doc_No; "No.")
            {
            }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            dataitem(QueryElement1000000001; 39)
            {
                DataItemLink = "Document Type" = "QueryElement1000000000"."Document Type", "Document No." = "QueryElement1000000000"."No.";
                DataItemTableFilter = Type = FILTER(Item);
                column(No; "No.")
                {
                }
                //Azhar++
                column(Line_No_; "Line No.")
                {

                }
                column(Item_Category_Code; "Item Category Code")
                {

                }
                //Azhar--
                column(Sum_Amt; "Line Amount")
                {
                    Method = Sum;
                }
            }
        }
    }
}

