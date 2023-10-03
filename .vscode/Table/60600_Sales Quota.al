table 60600 "Sales Quota"
{

    fields
    {
        field(1; "Sales Type"; Option)
        {
            OptionCaption = ' ,All Customer,Customer,Customer Price Group';
            OptionMembers = " ","All Customer",Customer,"Customer Price Group";

            trigger OnValidate()
            begin
                IF ("Sales Type" = "Sales Type"::"All Customer") or ("Sales Type" = "Sales Type"::"Customer Price Group") THEN begin
                    CLEAR("Sales Code");
                    Clear("Sales Name");
                    Clear("Ship-to Code");
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
            IF ("Sales Type" = CONST("Customer Price Group")) "Customer Price Group";
            ValidateTableRelation = true;
            trigger OnValidate()
            var
                Reccustomer: Record Customer;
            begin
                if "Sales Type" = "Sales Type"::Customer then begin
                    Reccustomer.Reset();
                    Reccustomer.SetRange("No.", "Sales Code");
                    if Reccustomer.FindFirst() then begin
                        Validate("Sales Name", Reccustomer.Name);
                    end else begin
                        Validate("Sales Name", '');
                    end;
                end else begin
                    Validate("Sales Name", '');
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
                if ("Item Type" = "Item Type"::"All Items") or ("Item Type" = "Item Type"::"Item Category") then begin
                    Clear("Item Code");
                    Clear("Item Description");
                    Clear("Unit of Measure Code");
                end;
            end;

        }
        field(3; "Item Code"; Code[20])
        {
            TableRelation = if ("Item Type" = const(Item)) Item else
            if ("Item Type" = const("Item Category")) "Item Category";
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                L_Item: Record 27;
            begin
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
        }
        field(14; "Currency Code "; Code[10])
        {
            TableRelation = Currency;
            DataClassification = ToBeClassified;
        }
        field(15; "No of Months"; DateFormula)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                //StartDateCalculationEnddate(Rec."No of Months");//CAS-28103-W6D1M0
            end;
        }
        field(16; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Maximum Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(80002; "Warning Type"; Option)
        {
            OptionCaptionML = ENU = ' ,warning,error';
            OptionMembers = " ",warning,error;
        }
        field(6; "Quantity Restriction"; Option)
        {
            OptionCaption = 'Per Day,Per Order,Per Month';
            OptionMembers = "Per Day","Per Order","Per Month";

        }
        field(7; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sales Code"));
        }
        field(9; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            begin
                if Format(Rec."No of Months") = '' then begin
                    Error('Please enter No. of Months');
                end;
                StartDateCalculationEnddate2(Rec."No of Months");//CAS-28103-W6D1M0
            end;
        }
        field(10; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(80000; "B2B Nav Maximum Order Id"; Code[20])
        {
            Description = 'WCL V.03-+';
        }
        field(80001; "B2B Nav Maximum Order IdV3"; Code[20])
        {
            Description = 'WCL V.03-+';
        }


    }

    keys
    {
        key(Key1; "Sales Type", "Sales Code", "Item Type", "Item Code", "Restriction Type", "Start Date", "Ship-to Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //"Creation Date Time" :=CURRENTDATETIME;//WCL V.03
    end;

    trigger OnModify()
    begin
        //"Update Date Time" :=CURRENTDATETIME;//WCL V.03
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
}

