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
        L_CustomerPriceGroup: Record "Customer Price Group";
        L_Dimension: Record Dimension;
        L_DimensionValue: Record "Dimension Value";
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
            end else begin
                if UpperCase(GetValueAtIndex(RowNo, 1)) = UpperCase('Customer') then begin
                    Reccustomer.Reset();
                    Reccustomer.SetRange("No.", GetValueAtIndex(RowNo, 2));
                    if not Reccustomer.FindFirst() then begin
                        ErrorLog_excelbuffer.AddColumn('Invalid sales code value. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                        ErrorFound := true;
                    end;
                end else begin
                    if UpperCase(GetValueAtIndex(RowNo, 1)) = UpperCase('Customer Price Group') then begin
                        L_CustomerPriceGroup.Reset();
                        L_CustomerPriceGroup.SetRange(Code, GetValueAtIndex(RowNo, 2));
                        if not L_CustomerPriceGroup.FindFirst() then begin
                            ErrorLog_excelbuffer.AddColumn('Invalid sales code value. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                            ErrorFound := true;
                        end;
                    end else begin
                        if UpperCase(GetValueAtIndex(RowNo, 1)) = UpperCase('Dimension') then begin
                            L_Dimension.Reset();
                            L_Dimension.SetRange(Code, GetValueAtIndex(RowNo, 2));
                            if not L_Dimension.FindFirst() then begin
                                ErrorLog_excelbuffer.AddColumn('Invalid sales code value. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                                ErrorFound := true;
                            end else begin
                                if GetValueAtIndex(RowNo, 4) = '' then begin
                                    ErrorLog_excelbuffer.AddColumn('Dimenion value should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                                    ErrorFound := true;
                                end else begin
                                    L_DimensionValue.Reset();
                                    L_DimensionValue.SetRange("Dimension Code", GetValueAtIndex(RowNo, 2));
                                    L_DimensionValue.SetRange(Code, GetValueAtIndex(RowNo, 4));
                                    if not L_DimensionValue.FindFirst() then begin
                                        ErrorLog_excelbuffer.AddColumn('Invalid Dimension value. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                                        ErrorFound := true;
                                    end;
                                end;
                            end;
                        end else begin
                            if UpperCase(GetValueAtIndex(RowNo, 1)) = UpperCase('All Customer') then begin
                                if GetValueAtIndex(RowNo, 2) <> '' then begin
                                    ErrorLog_excelbuffer.AddColumn('sales code value should not be blank for All Customer. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                                    ErrorFound := true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;


            //+++Only For Item. Will discuss for All Item & Item Category+++
            if GetValueAtIndex(RowNo, 5) = '' then begin
                ErrorLog_excelbuffer.AddColumn('Item Code should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                ErrorFound := true;
            end else begin
                RecItem.Reset();
                RecItem.SetRange("No.", GetValueAtIndex(RowNo, 5));
                if not RecItem.FindFirst() then begin
                    ErrorLog_excelbuffer.AddColumn('Invalid Item Code. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                    ErrorFound := true;
                end;
            end;

            //Max Quantity++
            if GetValueAtIndex(RowNo, 6) = '' then begin
                ErrorLog_excelbuffer.AddColumn('Max Quantity should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                ErrorFound := true;
            end;

            //Warning Type+++
            if GetValueAtIndex(RowNo, 7) = '' then begin
                ErrorLog_excelbuffer.AddColumn('Warning Type should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                ErrorFound := true;
            end else begin
                if UpperCase(GetValueAtIndex(RowNo, 7)) <> UpperCase('error') then
                    if UpperCase(GetValueAtIndex(RowNo, 7)) <> UpperCase('warning') then begin
                        ErrorLog_excelbuffer.AddColumn('Invalid Warning Type. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                        ErrorFound := true;
                    end;
            end;

            //Quantity Restriction+++
            if GetValueAtIndex(RowNo, 8) = '' then begin
                ErrorLog_excelbuffer.AddColumn('Quantity Restriction should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                ErrorFound := true;
            end else begin
                if UpperCase(GetValueAtIndex(RowNo, 8)) <> UpperCase('Per Day') then
                    if UpperCase(GetValueAtIndex(RowNo, 8)) <> UpperCase('Per Order') then
                        if UpperCase(GetValueAtIndex(RowNo, 8)) <> UpperCase('Per Month') then
                            if UpperCase(GetValueAtIndex(RowNo, 8)) <> UpperCase('Exception Per Day') then begin
                                ErrorLog_excelbuffer.AddColumn('Invalid Quantity Restriction. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                                ErrorFound := true;
                            end;

                if (UpperCase(GetValueAtIndex(RowNo, 8)) = UpperCase('Per Day')) OR (UpperCase(GetValueAtIndex(RowNo, 8)) = UpperCase('Per Order')) then begin
                    if UpperCase(GetValueAtIndex(RowNo, 10)) <> '' then begin
                        ErrorLog_excelbuffer.AddColumn('Start Date should be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                        ErrorFound := true;
                    end;
                end;
            end;

            //No of Months+++
            if UpperCase(GetValueAtIndex(RowNo, 8)) = UpperCase('Per Month') then begin
                if UpperCase(GetValueAtIndex(RowNo, 9)) = '' then begin
                    ErrorLog_excelbuffer.AddColumn('No of Months should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                    ErrorFound := true;
                end;
            end;

            //Start Date++
            if UpperCase(GetValueAtIndex(RowNo, 8)) = UpperCase('Per Month') then begin
                if UpperCase(GetValueAtIndex(RowNo, 10)) = '' then begin
                    ErrorLog_excelbuffer.AddColumn('Start Date should not be blank. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                    ErrorFound := true;
                end;
            end;

            //+++
            if UpperCase(GetValueAtIndex(RowNo, 8)) = UpperCase('Exception Per Day') then begin
                if UpperCase(GetValueAtIndex(RowNo, 1)) <> UpperCase('Customer') then begin
                    ErrorLog_excelbuffer.AddColumn('Exception Per Day only work for sales type customer. RowNo: ' + Format(RowNo), false, '', false, false, false, '', ErrorLog_excelbuffer."Cell Type"::Text);
                    ErrorFound := true;
                end;
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
            RecILETemp."Item No." := GetValueAtIndex(RowNo, 5);//Item No.
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
            if GetValueAtIndex(RowNo, 11) <> '' then
                RecILETemp."External Document No." := GetValueAtIndex(RowNo, 11);//External Doc.No
            if GetValueAtIndex(RowNo, 3) <> '' then
                RecILETemp."Del Adress Temp" := GetValueAtIndex(RowNo, 3);
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
        Excelbuffer.AddColumn('Item Code', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Maximum Quantity', false, '', false, false, false, '', excelbuffer."Cell Type"::Number);
        Excelbuffer.AddColumn('Warning Type', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Quantity Restriction', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('No of Months', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
        Excelbuffer.AddColumn('Start Date', false, '', false, false, false, '', excelbuffer."Cell Type"::Date);
        Excelbuffer.AddColumn('External Document No.', false, '', false, false, false, '', excelbuffer."Cell Type"::Text);
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
        SalesQuota.SetRange("Dimension Value", _ItemLedgerEntry."Job Task No.");
        SalesQuota.SetRange("Item Type", SalesQuota."Item Type"::Item);// It is only for Item. will discuss for All Item and Item Category
        SalesQuota.SetRange("Item Code", _ItemLedgerEntry."Item No.");
        SalesQuota.SetRange("Start Date", _ItemLedgerEntry."Posting Date");
        SalesQuota.SetFilter("Quantity Restriction", _ItemLedgerEntry.Description);
        SalesQuota.SetRange("Restriction Type", SalesQuota."Restriction Type"::"By Quantity");
        if SalesQuota.FindFirst() then begin
            //+++++++++++++++++++++++++++++++++++++++ Will discuss +++++++++++++++++++++++++++++++++++++
            // SalesQuota.Validate("Maximum Quantity", _ItemLedgerEntry.Quantity);
            // Evaluate(SalesQuota."Warning Type", _ItemLedgerEntry."Your ref Temp");
            // Evaluate(SalesQuota."No of Months", _ItemLedgerEntry."Area");
            // SalesQuota.Validate("External Document No.", _ItemLedgerEntry."External Document No.");
            // SalesQuota.Modify();
            //+++++++++++++++++++++++++++++++++++++++ Will discuss +++++++++++++++++++++++++++++++++++++
        end else begin
            SalesQuota.Init();
            Evaluate(SalesQuota."Sales Type", _ItemLedgerEntry."Source No.");
            SalesQuota.Validate("Sales Code", _ItemLedgerEntry."Document No.");
            SalesQuota.Validate("Dimension Value", _ItemLedgerEntry."Job Task No.");
            SalesQuota."Item Type" := SalesQuota."Item Type"::Item;
            SalesQuota.Validate("Item Code", _ItemLedgerEntry."Item No.");
            SalesQuota.Validate("Start Date", _ItemLedgerEntry."Posting Date");
            SalesQuota.Validate("Maximum Quantity", _ItemLedgerEntry.Quantity);
            SalesQuota.Validate("External Document No.", _ItemLedgerEntry."External Document No.");
            Evaluate(SalesQuota."Warning Type", _ItemLedgerEntry."Your ref Temp");
            Evaluate(SalesQuota."Quantity Restriction", _ItemLedgerEntry.Description);
            Evaluate(SalesQuota."No of Months", _ItemLedgerEntry."Area");
            Evaluate(SalesQuota."Sales Name", RecILETemp."Del Adress Temp");
            Evaluate(SalesQuota."Sheet Name", SheetName);
            SalesQuota."Restriction Type" := SalesQuota."Restriction Type"::"By Quantity";
            SalesQuota.Insert(true);
        end;
    end;
}
