param (
    [Parameter(Mandatory=$true, HelpMessage="The contract code of your acumulus account")][string]$contractcode,
    [Parameter(Mandatory=$true, HelpMessage="The username of your acumulus account")]     [string]$username,
    [Parameter(Mandatory=$true, HelpMessage="The password of your acumulus account")]     [Security.SecureString]$SecurePassword,
    [Parameter(Mandatory=$false)]                                                         [string]$emailonerror = "noreplay@planetearth.com",
    [Parameter(Mandatory=$false)]                                                         [switch]$testmode
)

Add-Type -AssemblyName System.Windows.Forms

[System.String]$sScript_Version         = "0.1"
[System.String]$sScript_Name            = "Acumulus-powershellGUI"
[System.String]$sUser                   = $env:username
[System.String]$sFolder_Root            = (Get-Item $PSScriptRoot).parent.FullName
[System.String]$sFolder_Bin             = "$sFolder_Root\bin"
[System.String]$sFolder_Etc             = "$sFolder_Root\etc"
[System.String]$sFolder_Home            = "$sFolder_Root\home"
[System.String]$sFolder_Lib             = "$sFolder_Root\lib"
[System.String]$sFolder_Log             = "$sFolder_Root\log"
[System.String]$sFolder_Srv             = "$sFolder_Root\srv"
[System.String]$sFolder_User            = "$sFolder_Home\$sUser"
[System.String]$sScript_Config          = "$sFolder_Etc\$sScript_Name.ini"
[System.String]$sFile_Log               = "$sFolder_Log\$sScript_Name.log"

. $sFolder_Lib\AcumulusAPI-functions.ps1
. $sFolder_Lib\Form-functions.ps1
. $sFolder_Lib\Get-functions.ps1
. $sFolder_Lib\Set-functions.ps1

[Hashtable]$htScript_config             = Get-IniContent $sScript_Config
[System.String]$sFile_ico               = $($htScript_config["Files"]["ico"]).Replace("%SVR%",$sFolder_Srv)
[System.String]$sFile_usersettings      = $($htScript_config["Files"]["usersettings"]).Replace("%USERHOME%",$sFolder_User)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))
$authAcumulus = Get-AuthenticationObject -contractcode $contractcode -username $username -password $password -emailonerror $emailonerror -testmode:$testmode

[scriptblock]$sbAccountbalanceRefresh = {
    $lbAccountbalance.Items.Clear()
    $acAccountbalances = Get-ReportAccountbalances -AcumulusAuthentication $authAcumulus -year $($txtAccountbalanceYear.Text)
    foreach($acAccountbalance in $acAccountbalances) {
        Add-ListboxItem -oListbox $lbAccountbalance -Text "$($acAccountbalance.accountnumber)`t`tE$($acAccountbalance.accountbalance)`t`t$($acAccountbalance.accountdescription)" |out-null
    }
}

[scriptblock]$sbTripRefresh = {
    $lbTrips.Items.Clear()
    $acTrips = Get-ReportTripCompensations -AcumulusAuthentication $authAcumulus -year $($txtTripYear.Text)
    foreach($acTrip in $acTrips) {
        Add-ListboxItem -oListbox $lbTrips -Text "$($acTrip.tripcompensationdate)`t$($acTrip.tripcompensationkm)`tE$($acTrip.tripcompensationamount)`t$($acTrip.tripcompensationdescription)" |out-null
    }
}

[scriptblock]$sbTripAdd = {
    $frmTripAdd =           New-Form                 -width 360 -height 320 -header "AddTrip" -borderstyle FixedSingle -hide_maximizebox
                            New-Formlabel -x 1 -y 70 -width 100 -height 25  -ParentObject $frmTripAdd -Text "Datum:" | Out-Null

    [System.Windows.Forms.MonthCalendar]$calTripSelection = New-Formcalendar  -x 100 -y 1 -width 150 -height 150 -ParentObject $frmTripAdd -ShowTodayCircle -MaxSelectionCount 5

                            New-Formlabel   -x 1   -y 160 -width 100 -height 25 -ParentObject $frmTripAdd -Text "KM Heen:" | Out-Null
    $txtAddTripTo =         New-Formtextbox -x 100 -y 160 -width 100 -height 25 -ParentObject $frmTripAdd 
                            New-Formlabel   -x 1   -y 190 -width 100 -height 25 -ParentObject $frmTripAdd -Text "KM Terug:" | Out-Null
    $txtAddTripFrom =       New-Formtextbox -x 100 -y 190 -width 100 -height 25 -ParentObject $frmTripAdd 
                            New-Formlabel   -x 1   -y 220 -width 100 -height 25 -ParentObject $frmTripAdd -Text "Omschrijving:" | Out-Null
    $txtAddTripDescription =New-Formtextbox -x 100 -y 220 -width 240 -height 25 -ParentObject $frmTripAdd 
                            New-Formbutton  -x 100 -y 250 -width 100 -height 25 -ParentObject $frmTripAdd -Text "Submit" -Script {
        $startDate = $calTripSelection.SelectionStart
        $endDate = $calTripSelection.SelectionEnd
        while($startDate -le $endDate) {
            Add-Trip -tripkmwayout $txtAddTripTo.text -tripkmreturn $txtAddTripFrom.text -tripdescription $txtAddTripDescription.text -tripdate $startDate -AcumulusAuthentication $authAcumulus
            $startDate = $startDate.AddDays(1)
        }
        $frmTripAdd.Close()
    } | Out-Null

    $frmTripAdd.ShowDialog()
    Invoke-Command $sbTripRefresh
}

[System.Windows.Forms.Form]  $frmMain =         New-Form                     -width 1000 -height 800 -header $("$sScript_Name - v$sScript_Version") -borderstyle FixedDialog -icon $sFile_ico -hide_maximizebox
[System.Windows.Forms.TabControl]$tcMain =      New-Formtabcontrol -x 0 -y 0 -width 1000 -height 800 -ParentObject $frmMain -appearance FlatButtons
[System.Windows.Forms.TabPage]$tpTrips =        New-Formtabpage                                      -ParentObject $tcMain -text "Trips"
[System.Windows.Forms.TabPage]$tpAccountbalance = New-Formtabpage                                    -ParentObject $tcMain -text "Accountbalance"

[System.Windows.Forms.textbox]$txtTripYear =  New-Formtextbox -x 1  -y 1 -width 95   -height 28  -ParentObject $tpTrips -Text $((get-date).ToString("yyyy"))
                                              New-Formbutton -x 100 -y 1 -width 246  -height 28  -ParentObject $tpTrips -Script $sbTripRefresh -Text "Refresh" | Out-null
                                              New-Formbutton -x 348 -y 1 -width 246  -height 28  -ParentObject $tpTrips -Script $sbTripAdd -Text "Add trip" | Out-null
[System.Windows.Forms.ListBox]$lbTrips =      New-Formlistbox -x 1  -y 30 -width 977 -height 709 -ParentObject $tpTrips -SelectionMode $([System.Windows.Forms.SelectionMode]::None)

[System.Windows.Forms.textbox]$txtAccountbalanceYear =  New-Formtextbox -x 1  -y 1 -width 95   -height 28  -ParentObject $tpAccountbalance -Text $((get-date).ToString("yyyy"))
                                                        New-Formbutton -x 100 -y 1 -width 246  -height 28  -ParentObject $tpAccountbalance -Script $sbAccountbalanceRefresh -Text "Refresh" | Out-null
[System.Windows.Forms.ListBox]$lbAccountbalance =       New-Formlistbox -x 1  -y 30 -width 977 -height 709 -ParentObject $tpAccountbalance -SelectionMode $([System.Windows.Forms.SelectionMode]::None)

Invoke-Command $sbTripRefresh
Invoke-Command $sbAccountbalanceRefresh
$frmMain.ShowDialog()