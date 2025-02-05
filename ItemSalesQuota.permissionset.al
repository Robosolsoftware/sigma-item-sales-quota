permissionset 60600 ItemSalesQuota
{
    Assignable = true;
    Permissions = tabledata "Purchase Quota" = RIMD,
        tabledata "Sales Quota" = RIMD,
        table "Purchase Quota" = X,
        table "Sales Quota" = X,
        codeunit "All Event" = X,
        codeunit "Purchase Order Restriction" = X,
        page "Purchase Quota By Amount" = X,
        page "Quota By Quantity" = X,
        query "DayShippe Amt" = X,
        query "DayShippe Qty" = X,
        query "Daywise order Amt" = X,
        query "Daywise order quantity" = X,
        query "PO DayReceived Amt" = X,
        query "PO Daywise order Amt" = X,
        tabledata "Purchase Budget Summary" = RIMD,
        table "Purchase Budget Summary" = X,
        page "Purchase Budget Summary" = X;
}