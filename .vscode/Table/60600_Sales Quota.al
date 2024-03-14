table 60600 "Sales Quota"
{

    fields
    {
        field(1; "Sales Type"; Option)
        {
            OptionCaption = ' ,All Customer,Customer,Customer Price Group,Dimension';
            OptionMembers = " ","All Customer",Customer,"Customer Price Group",Dimension;

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");


                IF ("Sales Type" = "Sales Type"::"All Customer") or ("Sales Type" = "Sales Type"::"Customer Price Group") or ("Sales Type" = "Sales Type"::Dimension) THEN begin
                    CLEAR("Sales Code");
                    Clear("Sales Name");
                    Clear("Ship-to Code");
                    Clear("Dimension Value");
                end;
            end;
        }
        field(11; "Restriction Type"; Option)
        {
            OptionCaption = 'By Quantity,By Amount';
            OptionMembers = "By Quantity","By Amount";

        }
        field(8; "Sales Code"; Code[20])
        {
            TableRelation = IF ("Sales Type" = CONST(Customer)) Customer
            ELSE
            IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group"
            else
            if ("Sales Type" = const(Dimension)) Dimension.Code;

            ValidateTableRelation = true;
            trigger OnValidate()
            var
                Reccustomer: Record Customer;
                L_Dimension: Record Dimension;
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");

                case Rec."Sales Type" of
                    Rec."Sales Type"::Customer:
                        begin
                            Reccustomer.Reset();
                            Reccustomer.SetRange("No.", Rec."Sales Code");
                            if Reccustomer.FindFirst() then begin
                                Validate("Sales Name", Reccustomer.Name);
                            end;
                        end;
                    Rec."Sales Type"::Dimension:
                        begin
                            L_Dimension.Reset();
                            L_Dimension.SetRange(Code, Rec."Sales Code");
                            if L_Dimension.FindFirst() then begin
                                Validate("Sales Name", L_Dimension.Name);
                            end;
                        end;
                    Rec."Sales Type"::"All Customer",
                    Rec."Sales Type"::"Customer Price Group":
                        begin
                            Validate("Sales Name", '');
                        end;
                end;
            end;
        }


        field(2; "Sales Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Item Type"; Option)
        {
            OptionCaption = 'All Items,Item,Item Category';
            OptionMembers = "All Items","Item","Item Category";
            trigger OnValidate()
            var
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");

                //Clear Fields++
                Clear("Item Code");
                Clear("Item Description");
                Clear("Unit of Measure Code");
                Clear("Warehouse Class code");
            end;

        }
        field(3; "Item Code"; Code[20])
        {
            TableRelation = if ("Item Type" = const(Item)) Item else
            if ("Item Type" = const("Item Category")) "Item Category";
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                L_Item: Record Item;
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                if xRec."Item Code" <> '' then
                    CheckPermissionForCDProducts(xRec."Item Code");


                CheckPermissionForCDProducts(Rec."Item Code");
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:--------


                CLEAR("Item Description");
                Clear("Warehouse Class code");
                if L_Item.GET("Item Code") then begin
                    "Item Description" := L_Item.Description;
                    "Warehouse Class code" := L_Item."Warehouse Class Code";
                end else begin
                    "Item Description" := '';
                end;
            end;
        }
        field(4; "Item Description"; Code[50])
        {
            Editable = false;
        }
        field(17; "Warehouse Class code"; Code[50])
        {
            Editable = false;
        }
        field(13; "Unit of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Item Type" = const(Item)) "Item Unit of Measure".Code where("Item No." = field("Item Code"));

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }

        field(14; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }
        field(15; "No of Months"; DateFormula)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");

                //StartDateCalculationEnddate(Rec."No of Months");//CAS-28103-W6D1M0
            end;
        }
        field(16; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }
        field(5; "Maximum Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }
        field(80002; "Warning Type"; Option)
        {
            OptionCaptionML = ENU = 'warning,error';
            OptionMembers = warning,error;

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }
        field(6; "Quantity Restriction"; Option)
        {
            OptionCaption = 'Per Day,Per Order,Per Month';
            OptionMembers = "Per Day","Per Order","Per Month";

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;

        }
        field(7; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sales Code"));

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");

            end;
        }
        field(9; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");

                if Format(Rec."No of Months") = '' then begin
                    Error('Please enter No. of Months');
                end;
                StartDateCalculationEnddate2(Rec."No of Months");//CAS-28103-W6D1M0
            end;
        }
        field(10; "End Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }

        field(80000; "B2B Nav Maximum Order Id"; Code[20])
        {
            Description = 'WCL V.03-+';

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }
        field(80001; "B2B Nav Maximum Order IdV3"; Code[20])
        {
            Description = 'WCL V.03-+';

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }

        field(27; "Dimension Value"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Sales Code"));

            trigger OnValidate()
            begin
                //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
                //16th Training Points:+++++++
                CheckPermissionForCDProducts(Rec."Item Code");
            end;
        }


    }

    keys
    {
        key(Key1; "Sales Type", "Sales Code", "Item Type", "Item Code", "Restriction Type", "Start Date", "Ship-to Code", "Dimension Value", "Quantity Restriction")
        {
        }
    }

    fieldgroups
    {
    }
    var
    //AllEvent: Codeunit "All Event";

    trigger OnInsert()
    begin
        //"Creation Date Time" :=CURRENTDATETIME;//WCL V.03

        //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
        //16th Training Points:+++++++
        CheckPermissionForCDProducts(Rec."Item Code");
    end;

    trigger OnModify()
    begin
        //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
        //16th Training Points:+++++++
        CheckPermissionForCDProducts(Rec."Item Code");
    end;

    trigger OnDelete()
    begin
        //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
        //16th Training Points:+++++++
        CheckPermissionForCDProducts(Rec."Item Code");
    end;

    procedure StartDateCalculationEnddate(NoOfMontVar: DateFormula)
    var
        CurrentMonthStartDate: Date;
        CurrentYear: Integer;
        currentMonth: Integer;
        CurrentMonth_Text: Text;
        EndDate: Date;
    begin
        //CurrentMonthStartDate++
        if format(NoOfMontVar) <> '' then begin
            currentMonth := Date2DMY(Today, 2);
            CurrentYear := Date2DMY(Today, 3);
            if currentMonth > 9 then
                CurrentMonth_Text := Format(currentMonth)
            else
                CurrentMonth_Text := '0' + Format(currentMonth);
            Evaluate(CurrentMonthStartDate, '01' + CurrentMonth_Text + Format(CurrentYear));
            //CurrentMonthStartDate--

            //EndDate++
            EndDate := CalcDate('+' + format(NoOfMontVar), CurrentMonthStartDate);
            EndDate := CalcDate('-1D', EndDate);
            //EndDate--
            Rec.Validate("Start Date", CurrentMonthStartDate);
            Rec.Validate("End Date", EndDate);
        end else begin
            Rec.Validate("Start Date", 0D);
            Rec.Validate("End Date", 0D);
        end;
    end;
    //CAS-28103-W6D1M0++
    procedure StartDateCalculationEnddate2(NoOfMontVar: DateFormula)
    var
        CurrentMonthStartDate: Date;
        CurrentYear: Integer;
        currentMonth: Integer;
        CurrentMonth_Text: Text;
        EndDate: Date;
    begin

        if format(NoOfMontVar) <> '' then begin
            if Rec."Start Date" <> 0D then begin
                EndDate := CalcDate('+' + format(NoOfMontVar), Rec."Start Date");
                EndDate := CalcDate('-1D', EndDate);//azhar 11 11 2021
                Rec.Validate("End Date", EndDate);
            end;
        end else begin
            Rec.Validate("End Date", 0D);
        end;
    end;
    //CAS-28103-W6D1M0--



    procedure CheckPermissionForCDProducts(_ItemNo: Code[20])
    var
        L_Item: Record 27;
        L_UserSetup: Record "User Setup";
        L_WarehouseClassCode: Record "Warehouse Class";
    begin
        //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
        //16th Training Points:+++++++
        L_Item.Reset();
        L_Item.SetRange("No.", _ItemNo);
        if L_Item.FindFirst() then begin
            L_WarehouseClassCode.Reset();
            L_WarehouseClassCode.SetRange(Code, L_Item."Warehouse Class Code");
            if L_WarehouseClassCode.FindFirst() then begin
                if (L_WarehouseClassCode.CD = true) then begin
                    L_UserSetup.Reset();
                    L_UserSetup.SetRange("User ID", UserId);
                    L_UserSetup.SetRange("Allowed Quota Manag. for CD", true);
                    if not L_UserSetup.FindFirst() then
                        Error('You do not have permission to Add/Edit/Remove CD product');
                end;
            end;
        end;
        //User Story https://dev.azure.com/Robosol2020/Sigma%20PLC/_workitems/edit/11624
        //16th Training Points:--------
    end;
}

