


function Start-Authenticationbox {
    param (
    [Parameter(Mandatory=$true)][string]$userparamfile,
    [Parameter(Mandatory=$false)][string]$contractcode,
    [Parameter(Mandatory=$false)][string]$username,
    [Parameter(Mandatory=$false)][string]$emailonerror
)
    [System.Windows.Forms.Form]$frmAuthentication =      New-Form                     -width 275 -height 150 -header $("$sScript_Name - v$sScript_Version - Login") -borderstyle FixedDialog -icon $sFile_ico -hide_controlbox 
                                                         New-Formlabel   -x 1   -y 1  -width 100 -height 20 -ParentObject $frmAuthentication -Text "Contractcode:" | Out-Null
    [System.Windows.Forms.TextBox]$txtAuthContractcode = New-Formtextbox -x 105 -y 1  -width 145 -height 20 -ParentObject $frmAuthentication -Text $contractcode
                                                         New-Formlabel   -x 1   -y 30 -width 100 -height 20 -ParentObject $frmAuthentication -Text "Username" | Out-Null
    [System.Windows.Forms.TextBox]$txtAuthusername =     New-Formtextbox -x 105 -y 30 -width 145 -height 20 -ParentObject $frmAuthentication -Text $username
                                                         New-Formlabel   -x 1   -y 60 -width 100 -height 20 -ParentObject $frmAuthentication -Text "E-mail" | Out-Null
    [System.Windows.Forms.TextBox]$txtAuthEmailOnError = New-Formtextbox -x 105 -y 60 -width 145 -height 20 -ParentObject $frmAuthentication -Text $emailonerror
                                                         New-Formbutton  -x 105 -y 90 -width 145 -height 20 -ParentObject $frmAuthentication -Text "Go" -Script { 
        Write-Host $userparamfile
        $Authenticationparams = @{
            "contractcode" = $txtAuthContractcode.Text 
            "username" = $txtAuthusername.Text
            "email" = $txtAuthEmailOnError.Text 
        }
        $NewIniFile = @{"Authenticationparams" = $Authenticationparams}
        New-IniFile -InputObject $NewIniFile -FilePath $userparamfile -Force
        $frmAuthentication.Close()
    } | Out-Null
    $frmAuthentication.ShowDialog()
}


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Form]  $frmMain =             New-Form                     -width 1000 -height 800 -header $("$sScript_Name - v$sScript_Version") -borderstyle FixedDialog -icon $sFile_ico -hide_maximizebox
[System.Windows.Forms.TabControl]$tcMain =          New-Formtabcontrol -x 0 -y 0 -width 1000 -height 800 -ParentObject $frmMain -appearance FlatButtons
[System.Windows.Forms.TabPage]$tpAccountbalance =   New-Formtabpage                                      -ParentObject $tcMain -text $($htScript_config["$sLanguage_String"]["Label_Accountbalance"])
[System.Windows.Forms.TabPage]$tpExpense =          New-Formtabpage                                      -ParentObject $tcMain -text $($htScript_config["$sLanguage_String"]["Label_Expense"])
[System.Windows.Forms.TabPage]$tpTrips =            New-Formtabpage                                      -ParentObject $tcMain -text $($htScript_config["$sLanguage_String"]["Label_Trips"])
[System.Windows.Forms.TabPage]$tpUnpaidCreditors =  New-Formtabpage                                      -ParentObject $tcMain -text $($htScript_config["$sLanguage_String"]["Label_UnpaidCreditors"])
[System.Windows.Forms.TabPage]$tpUnpaidDebtors =    New-Formtabpage                                      -ParentObject $tcMain -text $($htScript_config["$sLanguage_String"]["Label_UnpaidDebitors"])

#tpAccountbalance
New-Formbutton  -x 1   -y 1 -width 20   -height 20  -ParentObject $tpAccountbalance -Text "<" -Script $sbAccountbalanceChangeYearRemove | Out-null
[System.Windows.Forms.textbox]$txtAccountbalanceYear =  New-Formtextbox -x 20  -y 1 -width 95   -height 20  -ParentObject $tpAccountbalance -Text $((get-date).ToString("yyyy")) -Disabled
                                                        New-Formbutton  -x 115 -y 1 -width 20   -height 20  -ParentObject $tpAccountbalance -Text ">" -Script $sbAccountbalanceChangeYearAdd | Out-null
                                                        New-Formbutton  -x 140 -y 1 -width 200  -height 20  -ParentObject $tpAccountbalance -Script $sbAccountbalanceRefresh -Text "Refresh" | Out-null
[System.Windows.Forms.ListView]$lvAccountbalance =      New-Formlistview -x 1  -y 25 -width 977 -height 709 -ParentObject $tpAccountbalance -view "Details"
$lvAccountbalance.columns.Add("accountid")     | Out-Null
$lvAccountbalance.columns.Add("number")      | Out-Null
$lvAccountbalance.columns.Add("balance")     | Out-Null
$lvAccountbalance.columns.Add("description") | Out-Null
$lvAccountbalance.columns[0].Width = 0
$lvAccountbalance.columns[1].Width = 200
$lvAccountbalance.columns[2].Width = 100
$lvAccountbalance.columns[3].Width = 600

#tpExpense
New-Formbutton  -x 1 -y 1 -width 200  -height 20  -ParentObject $tpExpense -Script $sbExpenseAdd -Text "Add Expense" -Disabled | Out-null

#tpTrips
                                             New-Formbutton  -x 1   -y 1 -width 20   -height 20  -ParentObject $tpTrips -Text "<" -Script $sbTripChangeYearRemove | Out-null
[System.Windows.Forms.textbox]$txtTripYear = New-Formtextbox -x 20  -y 1 -width 95   -height 20  -ParentObject $tpTrips -Text $((get-date).ToString("yyyy")) -Disabled
                                             New-Formbutton  -x 115 -y 1 -width 20   -height 20  -ParentObject $tpTrips -Text ">" -Script $sbTripChangeYearAdd | Out-null
                                             New-Formbutton  -x 140 -y 1 -width 200  -height 20  -ParentObject $tpTrips -Script $sbTripRefresh -Text "Refresh" | Out-null
                                             New-Formbutton  -x 342 -y 1 -width 200  -height 20  -ParentObject $tpTrips -Script $sbTripAdd -Text "Add trip" | Out-null
[System.Windows.Forms.ListView]$lvTrips =    New-Formlistview -x 1  -y 25 -width 977 -height 709 -ParentObject $tpTrips -view "Details" -onclickscript $sbTripEdit
$lvTrips.columns.Add("entryid")     | Out-Null
$lvTrips.columns.Add("date")        | Out-Null
$lvTrips.columns.Add("km")          | Out-Null
$lvTrips.columns.Add("Amount")      | Out-Null
$lvTrips.columns.Add("description") | Out-Null
$lvTrips.columns[0].Width = 0
$lvTrips.columns[1].Width = 100
$lvTrips.columns[4].Width = 600

#tpUnpaidCreditors
                                                        New-Formbutton  -x 1   -y 1 -width 20   -height 20  -ParentObject $tpUnpaidCreditors -Text "<" -Script $sbUnpaidCreditorsChangeYearRemove | Out-null
[System.Windows.Forms.textbox]$txtUnpaidCreditorsYear = New-Formtextbox -x 20  -y 1 -width 95   -height 20  -ParentObject $tpUnpaidCreditors -Text $((get-date).ToString("yyyy")) -Disabled
                                                        New-Formbutton  -x 115 -y 1 -width 20   -height 20  -ParentObject $tpUnpaidCreditors -Text ">" -Script $sbUnpaidCreditorsChangeYearAdd | Out-null
                                                        New-Formbutton  -x 140 -y 1 -width 200  -height 20  -ParentObject $tpUnpaidCreditors -Script $sbUnpaidCreditorsRefresh -Text "Refresh" | Out-null
[System.Windows.Forms.ListView]$lvUnpaidCreditors =     New-Formlistview -x 1  -y 25 -width 977 -height 709 -ParentObject $tpUnpaidCreditors -view "Details"
$lvUnpaidCreditors.columns.Add("numberunpaidcreditors") | Out-Null
$lvUnpaidCreditors.columns.Add("amountunpaidcreditors") | Out-Null
$lvUnpaidCreditors.columns[0].Width = 150
$lvUnpaidCreditors.columns[1].Width = 150

#tpUnpaidDebtors
                                                        New-Formbutton  -x 1   -y 1 -width 20   -height 20  -ParentObject $tpUnpaidDebtors -Text "<" -Script $sbUnpaidDebtorsChangeYearRemove | Out-null
[System.Windows.Forms.textbox]$txtUnpaidDebtorsYear =   New-Formtextbox -x 20  -y 1 -width 95   -height 20  -ParentObject $tpUnpaidDebtors -Text $((get-date).ToString("yyyy")) -Disabled
                                                        New-Formbutton  -x 115 -y 1 -width 20   -height 20  -ParentObject $tpUnpaidDebtors -Text ">" -Script $sbUnpaidDebtorsChangeYearAdd | Out-null
                                                        New-Formbutton  -x 140 -y 1 -width 200  -height 20  -ParentObject $tpUnpaidDebtors -Script $sbUnpaidDebtorsRefresh -Text "Refresh" | Out-null
[System.Windows.Forms.ListView]$lvUnpaidDebtors =       New-Formlistview -x 1  -y 25 -width 977 -height 709 -ParentObject $tpUnpaidDebtors -view "Details"
$lvUnpaidDebtors.columns.Add("numberunpaiddebtors")     | Out-Null
$lvUnpaidDebtors.columns.Add("amountunpaiddebtors")     | Out-Null
$lvUnpaidDebtors.columns.Add("numberoverduedebtors")    | Out-Null
$lvUnpaidDebtors.columns.Add("amountoverduedebtors")    | Out-Null
$lvUnpaidDebtors.columns[0].Width = 150
$lvUnpaidDebtors.columns[1].Width = 150
$lvUnpaidDebtors.columns[2].Width = 150
$lvUnpaidDebtors.columns[3].Width = 150