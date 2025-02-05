tableextension 60603 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
    }

    trigger OnBeforeInsert()
    var
        L_PurchaseHeader: Record "Purchase Header";
    begin
        L_PurchaseHeader.Reset();
        L_PurchaseHeader.SetRange("Document Type", L_PurchaseHeader."Document Type"::Order);
        L_PurchaseHeader.SetRange("No.", Rec."Document No.");
        if L_PurchaseHeader.FindFirst() then begin
            L_PurchaseHeader.TestField("Order Date");
        end;
    end;
}