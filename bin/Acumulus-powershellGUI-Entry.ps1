Function entryEdit {
param ( [Parameter(Mandatory=$true)][int]$iEntryId,
        [Parameter(Mandatory=$false)][String]$sHeader,
        [Parameter(Mandatory=$false)][Switch]$ViewOnly )
    [Boolean]$bDisabled = $false
    [Boolean]$bInitialypaid = $false
    [int]$iFormHeight = 812
    [String]$sAccountnumber = ""
    [String]$sContacts = ""
    [String]$sCostCenter = ""
    [String]$sCosttype = ""
    [String]$sInvoicelayout = ""
    if ($ViewOnly) {
        $bDisabled = $true
    }
    if (-not($sHeader)){
        if ($ViewOnly) {
            $sHeader = "View entry"
        } else {
            $sHeader = "Edit entry"
        }
    }
    $acEntryDetails = Get-Entry -AcumulusAuthentication $authAcumulus -entryid $iEntryId

    if ( $acEntryDetails.paymentstatus -eq "2" ) {
        $bInitialypaid = $true
    }
    if ( -not ([String]::IsNullOrEmpty($acEntryDetails.accountnumber))) {
        Foreach ($acPicklistAccounts in (Get-PicklistAccounts -AcumulusAuthentication $authAcumulus)) {
            if ($acPicklistAccounts.accountid -eq $acEntryDetails.accountnumber){
                $sAccountnumber = "$($acPicklistAccounts.accountnumber) / $($acPicklistAccounts.accountdescription)"
            }
        }
    }
    if ( -not ([String]::IsNullOrEmpty($acEntryDetails.contactid))) {
        Foreach ($acContacts in (Get-Contacts -AcumulusAuthentication $authAcumulus)) {
            if ($acContacts.contactid -eq $acEntryDetails.contactid){
                $sContacts = $acContacts.contactname
            }
        }
    }
    if ( -not ([String]::IsNullOrEmpty($acEntryDetails.costcenterid))) {
        Foreach ($acPicklistCostCenter in (Get-PicklistCostcenters -AcumulusAuthentication $authAcumulus)) {
            if ($acPicklistCostCenter.costcenterid -eq $acEntryDetails.costcenterid){
                $sCostCenter = $acPicklistCostCenter.costcentername
            }
        }
    }
    if ( -not ([String]::IsNullOrEmpty($acEntryDetails.costtypeid))) {
        Foreach ($acPicklistCosttype in (Get-PicklistCostheadings -AcumulusAuthentication $authAcumulus)) {
            if ($acPicklistCosttype.costheadingid -eq $acEntryDetails.costtypeid){
                $sCosttype = $acPicklistCosttype.costheadingname
            }
        }
    }
    if ( -not ([String]::IsNullOrEmpty($acEntryDetails.invoicelayoutid))) {
        Foreach ($acPicklistInvoicetemplates in (Get-PicklistInvoicetemplates -AcumulusAuthentication $authAcumulus)) {
            if ($acPicklistInvoicetemplates.invoicetemplateid -eq $acEntryDetails.invoicelayoutid){
                $sInvoicelayout = $acPicklistInvoicetemplates.invoicetemplatename
            }
        }
    }

    $frmEntryEdit =             New-Form                              -width 450 -height $iFormHeight -header $sHeader -borderstyle FixedSingle -icon $sFile_ico -hide_maximizebox 
                                New-Formlabel           -x 1   -y 1   -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_entryid"])            -AltText $($htScript_config["$sLanguage_String"]["Alttext_entryid"]) | Out-Null
    $txtEditEntryid =           New-Formtextbox         -x 150 -y 1   -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.entryid -disabled                                    -AltText $($htScript_config["$sLanguage_String"]["Alttext_entryid"]) 
                                New-Formlabel           -x 1   -y 25  -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_entrydate"])          -AltText $($htScript_config["$sLanguage_String"]["Alttext_entrydate"]) | Out-Null
    $dtpEditEntrydate =         New-Formdatetimepicker  -x 150 -y 25  -width 280 -height 20  -ParentObject $frmEntryEdit -SelectDate $acEntryDetails.entrydate -disabled                            -AltText $($htScript_config["$sLanguage_String"]["Alttext_entrydate"])
                                New-Formlabel           -x 1   -y 50  -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_entrytype"])          -AltText $($htScript_config["$sLanguage_String"]["Alttext_entrytype"]) | Out-Null
    $txtEditEntryType =         New-Formtextbox         -x 150 -y 50  -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.entrytype -disabled                                  -AltText $($htScript_config["$sLanguage_String"]["Alttext_entrytype"])
                                New-Formlabel           -x 1   -y 75  -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_entrydescription"])   -AltText $($htScript_config["$sLanguage_String"]["Alttext_entrydescription"]) | Out-Null
    $rtbEditEntrydescription =  New-Formrichtextbox     -x 150 -y 75  -width 280 -height 45  -ParentObject $frmEntryEdit -Text $acEntryDetails.entrydescription -disabled                           -AltText $($htScript_config["$sLanguage_String"]["Alttext_entrydescription"])
                                New-Formlabel           -x 1   -y 125 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_entrynote"])          -AltText $($htScript_config["$sLanguage_String"]["Alttext_entrynote"]) | Out-Null
    $rtbEditEntrynote =         New-Formrichtextbox     -x 150 -y 125 -width 280 -height 120 -ParentObject $frmEntryEdit -Text $acEntryDetails.entrynote -disabled -Multiline                       -AltText $($htScript_config["$sLanguage_String"]["Alttext_entrynote"])
                                New-Formlabel           -x 1   -y 250 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_fiscaltype"])         -AltText $($htScript_config["$sLanguage_String"]["Alttext_fiscaltype"]) | Out-Null
    $txtEditFiscaltype =        New-Formtextbox         -x 150 -y 250 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.fiscaltype -disabled                                 -AltText $($htScript_config["$sLanguage_String"]["Alttext_fiscaltype"])
                                New-Formlabel           -x 1   -y 275 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_vatreversecharge"])   -AltText $($htScript_config["$sLanguage_String"]["Alttext_vatreversecharge"]) | Out-Null
    $txtEditVatreversecharge =  New-Formtextbox         -x 150 -y 275 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.vatreversecharge -disabled                           -AltText $($htScript_config["$sLanguage_String"]["Alttext_vatreversecharge"]) 
                                New-Formlabel           -x 1   -y 300 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_foreigneu"])          -AltText $($htScript_config["$sLanguage_String"]["Alttext_foreigneu"]) | Out-Null
    $txtEditForeigneu =         New-Formtextbox         -x 150 -y 300 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.foreigneu -disabled                                  -AltText $($htScript_config["$sLanguage_String"]["Alttext_foreigneu"]) 
                                New-Formlabel           -x 1   -y 325 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_foreignnoneu"])       -AltText $($htScript_config["$sLanguage_String"]["Alttext_foreignnoneu"]) | Out-Null
    $txtEditForeignnoneu =      New-Formtextbox         -x 150 -y 325 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.foreignnoneu -disabled                               -AltText $($htScript_config["$sLanguage_String"]["Alttext_foreignnoneu"]) 
                                New-Formlabel           -x 1   -y 350 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_marginscheme"])       -AltText $($htScript_config["$sLanguage_String"]["Alttext_marginscheme"]) | Out-Null
    $txtEditMarginscheme =      New-Formtextbox         -x 150 -y 350 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.marginscheme -disabled                               -AltText $($htScript_config["$sLanguage_String"]["Alttext_marginscheme"]) 
                                New-Formlabel           -x 1   -y 375 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_foreignvat"])         -AltText $($htScript_config["$sLanguage_String"]["Alttext_foreignvat"]) | Out-Null
    $txtEditForeignvat =        New-Formtextbox         -x 150 -y 375 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.foreignvat -disabled                                 -AltText $($htScript_config["$sLanguage_String"]["Alttext_foreignvat"]) 
                                New-Formlabel           -x 1   -y 400 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_contactid"])          -AltText $($htScript_config["$sLanguage_String"]["Alttext_contactid"]) | Out-Null
    $txtEditContactid =         New-Formtextbox         -x 150 -y 400 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $sContacts -disabled                                                 -AltText $($htScript_config["$sLanguage_String"]["Alttext_contactid"]) 
                                New-Formlabel           -x 1   -y 425 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_accountnumber"])      -AltText $($htScript_config["$sLanguage_String"]["Alttext_accountnumber"]) | Out-Null
    $txtEditAccountnumber =     New-Formtextbox         -x 150 -y 425 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $sAccountnumber -disabled                                            -AltText $($htScript_config["$sLanguage_String"]["Alttext_accountnumber"]) 
                                New-Formlabel           -x 1   -y 450 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_costcenterid"])       -AltText $($htScript_config["$sLanguage_String"]["Alttext_costcenterid"]) | Out-Null
    $txtEditCostcenterid =      New-Formtextbox         -x 150 -y 450 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $sCostCenter -disabled                                               -AltText $($htScript_config["$sLanguage_String"]["Alttext_costcenterid"]) 
                                New-Formlabel           -x 1   -y 475 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_costtypeid"])         -AltText $($htScript_config["$sLanguage_String"]["Alttext_costtypeid"]) | Out-Null
    $txtEditCosttypeid =        New-Formtextbox         -x 150 -y 475 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $sCosttype -disabled                                                 -AltText $($htScript_config["$sLanguage_String"]["Alttext_costtypeid"]) 
                                New-Formlabel           -x 1   -y 500 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_invoicenumber"])      -AltText $($htScript_config["$sLanguage_String"]["Alttext_invoicenumber"]) | Out-Null
    $txtEditInvoicenumber =     New-Formtextbox         -x 150 -y 500 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.invoicenumber -disabled                              -AltText $($htScript_config["$sLanguage_String"]["Alttext_invoicenumber"]) 
                                New-Formlabel           -x 1   -y 525 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_invoicenote"])        -AltText $($htScript_config["$sLanguage_String"]["Alttext_invoicenote"]) | Out-Null
    $txtEditInvoicenote =       New-Formtextbox         -x 150 -y 525 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.invoicenote -disabled                                -AltText $($htScript_config["$sLanguage_String"]["Alttext_invoicenote"]) 
                                New-Formlabel           -x 1   -y 550 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_descriptiontext"])    -AltText $($htScript_config["$sLanguage_String"]["Alttext_descriptiontext"]) | Out-Null
    $txtEditDescriptiontext =   New-Formtextbox         -x 150 -y 550 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.descriptiontext -disabled                            -AltText $($htScript_config["$sLanguage_String"]["Alttext_descriptiontext"]) 
                                New-Formlabel           -x 1   -y 575 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_Invoicelayoutid"])    -AltText $($htScript_config["$sLanguage_String"]["Alttext_Invoicelayoutid"]) | Out-Null
    $txtEditInvoicelayoutid =   New-Formtextbox         -x 150 -y 575 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $sInvoicelayout -disabled                                            -AltText $($htScript_config["$sLanguage_String"]["Alttext_Invoicelayoutid"]) 
                                New-Formlabel           -x 1   -y 600 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_totalvalueexclvat"])  -AltText $($htScript_config["$sLanguage_String"]["Alttext_totalvalueexclvat"]) | Out-Null
    $txtEditTotalvalueexclvat = New-Formtextbox         -x 150 -y 600 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.totalvalueexclvat -disabled                          -AltText $($htScript_config["$sLanguage_String"]["Alttext_totalvalueexclvat"]) 
                                New-Formlabel           -x 1   -y 625 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_totalvalue"])         -AltText $($htScript_config["$sLanguage_String"]["Alttext_totalvalue"]) | Out-Null
    $txtEditTotalvalue =        New-Formtextbox         -x 150 -y 625 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.totalvalue -disabled                                 -AltText $($htScript_config["$sLanguage_String"]["Alttext_totalvalue"]) 
                                New-Formlabel           -x 1   -y 650 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_paymenttermdays"])    -AltText $($htScript_config["$sLanguage_String"]["Alttext_paymenttermdays"]) | Out-Null
    $txtEditPaymenttermdays =   New-Formtextbox         -x 150 -y 650 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.paymenttermdays -disabled                            -AltText $($htScript_config["$sLanguage_String"]["Alttext_paymenttermdays"]) 
                                New-Formlabel           -x 1   -y 675 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_paymentdate"])        -AltText $($htScript_config["$sLanguage_String"]["Alttext_paymentdate"]) | Out-Null
    $dtpEditPaymentdate =       New-Formdatetimepicker  -x 150 -y 675 -width 280 -height 20  -ParentObject $frmEntryEdit                -disabled:$bDisabled                                        -AltText $($htScript_config["$sLanguage_String"]["Alttext_paymentdate"]) 
                                New-Formlabel           -x 1   -y 700 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_paymentstatus"])      -AltText $($htScript_config["$sLanguage_String"]["Alttext_paymentstatus"]) | Out-Null
    $chbEditPaymentstatus =     New-Formcheckbox        -x 150 -y 700 -width 20  -height 20  -ParentObject $frmEntryEdit -checked:$bInitialypaid -disabled:$bDisabled                               -AltText $($htScript_config["$sLanguage_String"]["Alttext_paymentstatus"])
                                New-Formlabel           -x 1   -y 725 -width 150 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Label_deleted"])            -AltText $($htScript_config["$sLanguage_String"]["Alttext_deleted"]) | Out-Null
    $txtEditDeleted =           New-Formtextbox         -x 150 -y 725 -width 280 -height 20  -ParentObject $frmEntryEdit -Text $acEntryDetails.deleted -disabled                                    -AltText $($htScript_config["$sLanguage_String"]["Alttext_deleted"]) 
    $btnEditEntrySave =         New-Formbutton          -x 150 -y 750 -width 130 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Button_save"])              -Script $sbEditEntrySave    -disabled:$bDisabled
    $btnEditEntryDelete =       New-Formbutton          -x 300 -y 750 -width 130 -height 20  -ParentObject $frmEntryEdit -Text $($htScript_config["$sLanguage_String"]["Button_delete"])            -Script $sbEditEntryDelete
    if ( -not ([String]::IsNullOrEmpty($acEntryDetails.paymentdate))) {
        $dtpEditPaymentdate.Value = $acEntryDetails.paymentdate
    } else {
        if ($bDisabled ) {
            $dtpEditPaymentdate.Visible = $false
            New-Formtextbox        -x 150 -y 675 -width 280 -height 20  -ParentObject $frmEntryEdit -Text "" -disabled  -AltText $($htScript_config["$sLanguage_String"]["Alttext_paymentdate"]) | Out-Null
        }
    }
    $dtpEditPaymentdate
    $frmEntryEdit.ShowDialog()
}

[scriptblock]$sbEditEntrySave = {
    Write-host "hihi no finito => $($txtEditEntryid.text)"
}

[scriptblock]$sbEditEntryDelete = {
    Write-host "hihi no finito al deleto => $($txtEditEntryid.text)"
}