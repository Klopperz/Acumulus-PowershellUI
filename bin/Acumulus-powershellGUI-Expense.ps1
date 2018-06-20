[scriptblock]$sbExpenseAdd = {
    $frmAddExpense =                    New-Form                 -width 810 -height 600 -header "Add expense" -borderstyle FixedSingle -icon $sFile_ico -hide_maximizebox 
                                        New-Formlabel    -x 1   -y 1   -width 100 -height 25 -ParentObject $frmAddExpense -Text "Type*" | Out-Null
    $cbAddExpanseType =                 New-Formcombobox -x 100 -y 1   -width 280 -height 20 -ParentObject $frmAddExpense
                                        New-Formlabel    -x 1   -y 25  -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Companyname1"])      -Text $($htScript_config["$sLanguage_String"]["Label_Companyname1"])       | Out-Null
    $txtAddExpanseCompanyname1 =        New-Formtextbox  -x 100 -y 25  -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Companyname1"])
                                        New-Formlabel    -x 1   -y 50  -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Companyname2"])      -Text $($htScript_config["$sLanguage_String"]["Label_Companyname2"])       | Out-Null
    $txtAddExpanseCompanyname2 =        New-Formtextbox  -x 100 -y 50  -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Companyname2"])
                                        New-Formlabel    -x 1   -y 75  -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Fullname"])          -Text $($htScript_config["$sLanguage_String"]["Label_Fullname"])           | Out-Null
    $txtAddExpanseFullname =            New-Formtextbox  -x 100 -y 75  -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Fullname"])
                                        New-Formlabel    -x 1   -y 100 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Salutation"])        -Text $($htScript_config["$sLanguage_String"]["Label_Salutation"])         | Out-Null
    $txtAddExpanseSalutation =          New-Formtextbox  -x 100 -y 100 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Salutation"])
                                        New-Formlabel    -x 1   -y 125 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Address1"])          -Text $($htScript_config["$sLanguage_String"]["Label_Address1"])           | Out-Null
    $txtAddExpanseAddress1 =            New-Formtextbox  -x 100 -y 125 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Address1"])
                                        New-Formlabel    -x 1   -y 150 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Address2"])          -Text $($htScript_config["$sLanguage_String"]["Label_Address2"])           | Out-Null
    $txtAddExpanseAddress2 =            New-Formtextbox  -x 100 -y 150 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Address2"])
                                        New-Formlabel    -x 1   -y 175 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Postalcode"])        -Text $($htScript_config["$sLanguage_String"]["Label_Postalcode"])         | Out-Null
    $txtAddExpansePostalcode =          New-Formtextbox  -x 100 -y 175 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Postalcode"])
                                        New-Formlabel    -x 1   -y 200 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_City"])              -Text $($htScript_config["$sLanguage_String"]["Label_City"])               | Out-Null
    $txtAddExpanseCity =                New-Formtextbox  -x 100 -y 200 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_City"])
                                        New-Formlabel    -x 1   -y 225 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Countrycode"])       -Text $($htScript_config["$sLanguage_String"]["Label_Countrycode"])          | Out-Null
    $txtAddExpanseCountrycode =         New-Formtextbox  -x 100 -y 225 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Countrycode"])
                                        New-Formlabel    -x 1   -y 250 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Vatnumber"])         -Text $($htScript_config["$sLanguage_String"]["Label_Vatnumber"])        | Out-Null
    $txtAddExpanseVatnumber =           New-Formtextbox  -x 100 -y 250 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Vatnumber"])
                                        New-Formlabel    -x 1   -y 275 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Telephone"])         -Text $($htScript_config["$sLanguage_String"]["Label_Telephone"])          | Out-Null
    $txtAddExpanseTelephone =           New-Formtextbox  -x 100 -y 275 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Telephone"])
                                        New-Formlabel    -x 1   -y 300 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Fax"])               -Text $($htScript_config["$sLanguage_String"]["Label_Fax"])                | Out-Null
    $txtAddExpanseFax =                 New-Formtextbox  -x 100 -y 300 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Fax"])
                                        New-Formlabel    -x 1   -y 325 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Email"])             -Text $($htScript_config["$sLanguage_String"]["Label_Email"])              | Out-Null
    $txtAddExpanseEmail =               New-Formtextbox  -x 100 -y 325 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Email"])
                                        New-Formlabel    -x 1   -y 350 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Overwriteifexists"]) -Text $($htScript_config["$sLanguage_String"]["Label_Overwriteifexists"])  | Out-Null
    $txtAddExpanseOverwriteifexists =   New-Formtextbox  -x 100 -y 350 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Overwriteifexists"])
                                        New-Formlabel    -x 1   -y 375 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Bankaccountnumber"]) -Text $($htScript_config["$sLanguage_String"]["Label_Bankaccountnumber"])  | Out-Null
    $txtAddExpanseBankaccountnumber =   New-Formtextbox  -x 100 -y 375 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Bankaccountnumber"])
                                        New-Formlabel    -x 1   -y 400 -width 100 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Mark"])              -Text $($htScript_config["$sLanguage_String"]["Label_Mark"])               | Out-Null
    $txtAddExpanseMark =                New-Formtextbox  -x 100 -y 400 -width 280 -height 25 -ParentObject $frmAddExpense -AltText $($htScript_config["$sLanguage_String"]["Alttext_Mark"])

                                        New-Formlabel    -x 405 -y 300 -width 100 -height 25  -ParentObject $frmAddExpense -Text "Issuedate:" | Out-Null
    $calAddExpenseIssuedate =           New-Formcalendar -x 505 -y 300 -width 280 -height 150 -ParentObject $frmAddExpense -ShowTodayCircle -MaxSelectionCount 1

                                        New-Formlabel    -x 405 -y 600 -width 100 -height 25  -ParentObject $frmAddExpense -Text "Paymentdate:" | Out-Null
    $calAddExpensePaymentdate =         New-Formcalendar -x 505 -y 600 -width 280 -height 150 -ParentObject $frmAddExpense -ShowTodayCircle -MaxSelectionCount 1

    Add-ComboboxItem -oComboBox $cbAddExpanseType -Text "Debtor"
    Add-ComboboxItem -oComboBox $cbAddExpanseType -Text "Creditor"
    Add-ComboboxItem -oComboBox $cbAddExpanseType -Text "Debitor/Creditor"
    $txtAddExpanseCountrycode.Text = ([System.Threading.Thread]::CurrentThread.CurrentUICulture).Name.split("-")[0].toUpper()
    $cbAddExpanseType.SelectedIndex = 1
    

    $frmAddExpense.ShowDialog()
}