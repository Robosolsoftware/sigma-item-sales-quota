query 60604 "PO order Amt"
{
    querytype = Normal;

    elements
    {
        dataitem(Purchase_Line; "Purchase Line")
        {
            column(Type; Type)
            {

            }
            column(Document_Type; "Document Type")
            {

            }
            column(Document_No_; "Document No.")
            {

            }
            column(Line_No_; "Line No.")
            {

            }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {

            }
            column(Parent_Category; "Parent Category")
            {

            }
            column(Custom_Order_Date; "Custom Order Date")
            {

            }
            column(Outstanding_Amt__Ex__VAT__LCY_; "Outstanding Amt. Ex. VAT (LCY)")
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetFilter(Type, '%1', Type::Item);
        SetFilter(Outstanding_Amt__Ex__VAT__LCY_, '>%1', 0);
    end;
}

