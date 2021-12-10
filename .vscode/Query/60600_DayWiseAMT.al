query 60600 "Daywise order Amt"
{

    elements
    {
        dataitem(QueryElement1000000000; 36)
        {
            column(Document_Type; "Document Type")
            {
            }
            column(Doc_No; "No.")
            {
            }
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(Ship_to_Code; "Ship-to Code")
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            dataitem(QueryElement1000000001; 37)
            {
                //DataItemLink= "Document Type"= QueryElement1000000000.doc
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
                column(Customer_Price_Group; "Customer Price Group")
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

