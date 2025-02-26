codeunit 60602 "Export - Import Quota"
{
    trigger OnRun()
    begin
        Import();
    end;


    var
        Rec_ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        DialoCaption: Text;
        UploadResult: Boolean;
        InStr: InStream;
        FileName: Text[100];
        SheetName: Text[100];
        RowNo: Integer;
        RequestReceiptDate: Date;
        G_DocumentDate: Date;
        SalesLn: Record "Sales Line";
        G_Quantity: Decimal;
        G_UnitCost: Decimal;
        ErrorLog_excelbuffer: Record "Excel Buffer" temporary; //Dont Remove Temp Property
        RecILETemp: Record "Item Ledger Entry" temporary; //Dont Remove Temp Property



    procedure Import()
    var
        ErrorFound: Boolean;
        Reccustomer: Record Customer;
        RecItem: Record Item;
        L_ItemVariant: Record "Item Variant";
        L_Location: Record Location;
        L_ShiptoAddress: Record "Ship-to Address";
        L_Attribute: Code[20];
        L_CompanyLicenseError: Text[100];
        RelSalesHeader: Record "Sales Header";
        RecRef: RecordRef;
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        GetSourceDocInbound: Codeunit "Get Source Doc. Outbound";

        L_Variant: Record "Item Variant";
        L_Qty: Decimal;
        L_OrderDate: Date;
        L_Shippingagentservice: Record "Shipping Agent Services";
        L_RecItemAttValMap: Record "Item Attribute Value Mapping";
        L_ItemAttribute: Record "Item Attribute";
        L_ItemAttributeValue: Record "Item Attribute Value";
        ShippingAgentRestrictItem: Record "Shipping Agent Restrict Item";
        OutStrm: OutStream;
        InStrm: InStream;
        TempBLOB: codeunit "Temp Blob";
        L_filename: Text[100];
        UserSetup: Record "User Setup";
        L_UnitPrice: Decimal;
        L_ItemCharge: Record "Item Charge";
        L_ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        Rec_ExcelBuffer.DeleteAll();
        ErrorLog_excelbuffer.DeleteAll();
        RecILETemp.DeleteAll();


        Rows := 0;
        Columns := 0;
        DialoCaption := 'Select File to upload';

        UploadResult := UploadIntoStream(DialoCaption, '', '', FileName, InStr);

        if FileName <> '' then
            SheetName := Rec_ExcelBuffer.SelectSheetsNameStream(InStr)
        else
            exit;


        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.OpenBookStream(InStr, SheetName);
        Rec_ExcelBuffer.ReadSheet();
        Commit();

        //Finiding Total No of Rows to Import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Column No.", 1);
        If Rec_ExcelBuffer.FindFirst() then
            repeat
                Rows := Rows + 1;
            until Rec_ExcelBuffer.Next() = 0;

        //Finiding Total No of Columns to Import
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Row No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until Rec_ExcelBuffer.Next() = 0;

        #Region Create Excel Header for Error++
        ErrorLog_excelbuffer.NewRow();
        ErrorLog_excelbuffer.AddColumn('Sales Type', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Item Code', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Error Status1', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Error Status2', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Error Status3', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Error Status4', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        ErrorLog_excelbuffer.AddColumn('Error Status5', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
        #EndRegion Create Excel Header for Error++


        for RowNo := 2 to Rows do begin
            Clear(ErrorFound);

            //Create Excel Body For Error Log++
            ErrorLog_excelbuffer.NewRow();
            ErrorLog_excelbuffer.AddColumn(GetValueAtIndex(RowNo, 1), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
            ErrorLog_excelbuffer.AddColumn(GetValueAtIndex(RowNo, 2), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);

            if GetValueAtIndex(RowNo, 1) = '' then begin
                ErrorLog_excelbuffer.AddColumn('Sales Type should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                ErrorFound := true;
            end;



            if GetValueAtIndex(RowNo, 2) = '' then begin
                ErrorLog_excelbuffer.AddColumn('Item No. should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                ErrorFound := true;
            end;

            //If No Error++
            if ErrorFound = false then begin
                ErrorLog_excelbuffer.AddColumn('No Error', false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
            end;


            //Insert temp Record++
            RecILETemp.Init();
            RecILETemp."Entry No." := RowNo;
            RecILETemp."Source No." := GetValueAtIndex(RowNo, 1);//Sales Type
            RecILETemp."Document No." := GetValueAtIndex(RowNo, 2);//Sales Code
            RecILETemp."Job Task No." := GetValueAtIndex(RowNo, 4);//Dimension Value
                                                                   // RecILETemp."Job No." := GetValueAtIndex(RowNo, 5);//Item Type
            RecILETemp."Item No." := GetValueAtIndex(RowNo, 5);//Item No.
                                                               //RecILETemp."Location Code" := GetValueAtIndex(RowNo, 7);//Warehouse Class Code
                                                               // RecILETemp."Transport Method" := GetValueAtIndex(RowNo, 10);//Ship-to Code
            if GetValueAtIndex(RowNo, 6) <> '' then
                Evaluate(RecILETemp.Quantity, GetValueAtIndex(RowNo, 6));//Max. Qty
            if GetValueAtIndex(RowNo, 7) <> '' then
                RecILETemp."Your ref Temp" := GetValueAtIndex(RowNo, 7);//Warning Type
            if GetValueAtIndex(RowNo, 8) <> '' then
                RecILETemp.Description := GetValueAtIndex(RowNo, 8);//Qty Restriction
            if GetValueAtIndex(RowNo, 9) <> '' then
                RecILETemp."Area" := GetValueAtIndex(RowNo, 9);//No of Months
            if GetValueAtIndex(RowNo, 10) <> '' then
                Evaluate(RecILETemp."Posting Date", GetValueAtIndex(RowNo, 10)); //Start Date
                                                                                 //if GetValueAtIndex(RowNo, 16) <> '' then
                                                                                 //  Evaluate(RecILETemp."Document Date", GetValueAtIndex(RowNo, 16)); //End Date
            if GetValueAtIndex(RowNo, 11) <> '' then
                RecILETemp."External Document No." := GetValueAtIndex(RowNo, 11);//External Doc.No

            //if GetValueAtIndex(RowNo, 18) <> '' then
            //  RecILETemp."Order No." := GetValueAtIndex(RowNo, 18);//Restriction Type
            if ErrorFound = true then
                RecILETemp.Open := true;
            RecILETemp.Insert();
            Commit();
        end;

        //Create Order++
        RecILETemp.Reset();
        RecILETemp.SetRange(Open, false);
        if RecILETemp.FindSet() then begin
            repeat
                CreateOrder(RecILETemp);
            until RecILETemp.Next = 0;
        end;
        Commit();

        //Create Error Log+++
        Clear(L_filename);
        Clear(OutStrm);
        Clear(InStrm);
        RecILETemp.Reset();
        RecILETemp.SetRange(Open, true);
        if RecILETemp.FindFirst() then begin
            ErrorLog_excelbuffer.CreateNewBook('Errors');
            ErrorLog_excelbuffer.WriteSheet('Errors', CompanyName, UserId);
            ErrorLog_excelbuffer.CloseBook();
            TempBLOB.CreateOutStream(OutStrm);
            ErrorLog_excelbuffer.SaveToStream(OutStrm, false);
            TempBLOB.CreateInStream(InStrm);
            L_filename := 'Errors_' + Format(CurrentDateTime) + '.xlsx';
            DownloadFromStream(
                InStrm,  // InStream to save
                '',   // Not used in cloud
                '',   // Not used in cloud
                '',   // Not used in cloud
                L_filename); // Filename is browser download folder
        end;

    end;

    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text

    var

        Rec_ExcelBuffer: Record "Excel Buffer";

    begin

        Rec_ExcelBuffer.Reset();

        If Rec_ExcelBuffer.Get(RowNo, ColNo) then
            exit(Rec_ExcelBuffer."Cell Value as Text");

    end;


    local procedure GetLastLineNo(OrderNo: Code[50]): Integer
    var
        LastaSalesLine: Record "Sales Line";
    begin
        LastaSalesLine.Reset();
        LastaSalesLine.SetRange("Document Type", LastaSalesLine."Document Type"::Order);
        LastaSalesLine.SetRange("Document No.", OrderNo);
        if LastaSalesLine.FindLast() then
            exit(LastaSalesLine."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure QuotaTemplateExport()
    var
        //excelbuffer2: Record "Excel Buffer" temporary;
        Excelbuffer: Record "Excel Buffer" temporary;
        ins: InStream;
        outs: OutStream;
        TempBLOB: codeunit "Temp Blob";
        filename: Text;
    begin
        Excelbuffer.Reset();
        Excelbuffer.DeleteAll();
        Excelbuffer.NewRow();
        Excelbuffer.AddColumn('Sales Type', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Sales Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Sales Name', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Dimension Value', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        //Excelbuffer.AddColumn('Item Type', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('Item Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        //Excelbuffer.AddColumn('Warehouse Class code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        //Excelbuffer.AddColumn('Item Description', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        //Excelbuffer.AddColumn('Unit of Measure Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        //Excelbuffer.AddColumn('Ship-to Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Maximum Quantity', false, '', false, false, false, '', excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('Warning Type', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Quantity Restriction', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('No of Months', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Start Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        //Excelbuffer.AddColumn('End Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('External Document No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        //Excelbuffer.AddColumn('Restriction Type', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.CreateNewBook('Sample Template');
        Excelbuffer.WriteSheet('Sample Template', CompanyName, UserId);
        Excelbuffer.CloseBook();


        TempBLOB.CreateOutStream(outs);
        Excelbuffer.SaveToStream(outs, false);
        TempBLOB.CreateInStream(ins);
        filename := 'QuotaByQtyTemplate_' + Format(CurrentDateTime) + '.xlsx';
        DownloadFromStream(
            ins,  // InStream to save
            '',   // Not used in cloud
            '',   // Not used in cloud
            '',   // Not used in cloud
            filename); // Filename is browser download folder
    end;

    procedure CreateOrder(_ItemLedgerEntry: Record "Item Ledger Entry" temporary)
    var
        SalesQuota: Record "Sales Quota";
    begin
        SalesQuota.Reset();
        SalesQuota.SetFilter("Sales Type", _ItemLedgerEntry."Source No.");
        SalesQuota.SetRange("Sales Code", _ItemLedgerEntry."Document No.");
        // SalesQuota.SetFilter("Item Type", _ItemLedgerEntry."Job No.");
        SalesQuota.SetRange("Item Code", _ItemLedgerEntry."Item No.");
        //SalesQuota.SetFilter("Restriction Type", _ItemLedgerEntry."Order No.");
        SalesQuota.SetRange("Start Date", _ItemLedgerEntry."Posting Date");
        //SalesQuota.SetRange("Ship-to Code", _ItemLedgerEntry."Transport Method");
        SalesQuota.SetRange("Dimension Value", _ItemLedgerEntry."Job Task No.");
        //SalesQuota.SetFilter("Quantity Restriction", _ItemLedgerEntry.Description);
        if SalesQuota.FindFirst() then begin
            // SalesQuota.Validate("Warehouse Class code", _ItemLedgerEntry."Location Code");
            SalesQuota.Validate("Maximum Quantity", _ItemLedgerEntry.Quantity);
            Evaluate(SalesQuota."Warning Type", _ItemLedgerEntry."Your ref Temp");
            Evaluate(SalesQuota."Quantity Restriction", _ItemLedgerEntry.Description);
            Evaluate(SalesQuota."No of Months", _ItemLedgerEntry."Area");
            SalesQuota.Validate("External Document No.", _ItemLedgerEntry."External Document No.");
            SalesQuota.Modify();
        end else begin
            SalesQuota.Init();
            Evaluate(SalesQuota."Sales Type", _ItemLedgerEntry."Source No.");
            SalesQuota.Validate("Sales Code", _ItemLedgerEntry."Document No.");
            //Evaluate(SalesQuota."Item Type", _ItemLedgerEntry."Job No.");
            SalesQuota.Validate("Item Code", _ItemLedgerEntry."Item No.");
            //Evaluate(SalesQuota."Restriction Type", _ItemLedgerEntry."Order No.");
            SalesQuota.Validate("Start Date", _ItemLedgerEntry."Posting Date");
            //SalesQuota.Validate("Ship-to Code", _ItemLedgerEntry."Transport Method");
            SalesQuota.Validate("Dimension Value", _ItemLedgerEntry."Job Task No.");
            //SalesQuota.Validate("Warehouse Class code", _ItemLedgerEntry."Location Code");
            SalesQuota.Validate("Maximum Quantity", _ItemLedgerEntry.Quantity);
            Evaluate(SalesQuota."Warning Type", _ItemLedgerEntry."Your ref Temp");
            Evaluate(SalesQuota."Quantity Restriction", _ItemLedgerEntry.Description);
            Evaluate(SalesQuota."No of Months", _ItemLedgerEntry."Area");
            SalesQuota.Validate("External Document No.", _ItemLedgerEntry."External Document No.");
            SalesQuota.Insert(true);
        end;
    end;

}
