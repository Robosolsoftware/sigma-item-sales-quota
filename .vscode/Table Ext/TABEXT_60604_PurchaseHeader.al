tableextension 60604 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        // modify("Order Date")
        // {
        //     trigger OnBeforeValidate()
        //     var
        //         L_PurchaseLine: Record "Purchase Line";
        //     begin
        //         if Rec."Order Date" <> xRec."Order Date" then begin
        //             L_PurchaseLine.Reset();
        //             L_PurchaseLine.SetRange("Document Type", L_PurchaseLine."Document Type"::Order);
        //             L_PurchaseLine.SetRange("Document No.", Rec."No.");
        //             if L_PurchaseLine.FindFirst() then begin
        //                 Error('Due to available lines, you are unable to modify the order date.');
        //             end;
        //         end;
        //     end;
        // }
    }
}