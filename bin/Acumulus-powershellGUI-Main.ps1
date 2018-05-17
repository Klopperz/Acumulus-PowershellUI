
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Form]  $frmMain =         New-Form                     -width 1000 -height 800 -header $("$sScript_Name - v$sScript_Version") -borderstyle FixedDialog -icon $sFile_ico -hide_maximizebox
[System.Windows.Forms.TabControl]$tcMain =      New-Formtabcontrol -x 0 -y 0 -width 1000 -height 800 -ParentObject $frmMain -appearance FlatButtons
[System.Windows.Forms.TabPage]$tpTrips =        New-Formtabpage                                      -ParentObject $tcMain -text "Trips"
[System.Windows.Forms.TabPage]$tpAccountbalance = New-Formtabpage                                    -ParentObject $tcMain -text "Accountbalance"

                                            New-Formbutton  -x 1   -y 1 -width 20   -height 20  -ParentObject $tpTrips -Text "<" -Script {$txtTripYear.text = (get-date "1/1/$($txtTripYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbTripRefresh} | Out-null
[System.Windows.Forms.textbox]$txtTripYear =  New-Formtextbox -x 20  -y 1 -width 95   -height 20  -ParentObject $tpTrips -Text $((get-date).ToString("yyyy")) -Disabled
                                            New-Formbutton  -x 115 -y 1 -width 20   -height 20  -ParentObject $tpTrips -Text ">" -Script {$txtTripYear.text =  (get-date "1/1/$($txtTripYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbTripRefresh} | Out-null
                                            New-Formbutton  -x 140 -y 1 -width 200  -height 20  -ParentObject $tpTrips -Script $sbTripRefresh -Text "Refresh" | Out-null
                                            New-Formbutton  -x 342 -y 1 -width 200  -height 20  -ParentObject $tpTrips -Script $sbTripAdd -Text "Add trip" | Out-null
[System.Windows.Forms.ListView]$lvTrips =     New-Formlistview -x 1  -y 25 -width 977 -height 709 -ParentObject $tpTrips -view "Details" -onclickscript $sbTripEdit
$lvTrips.columns.Add("entryid")     | Out-Null
$lvTrips.columns.Add("date")        | Out-Null
$lvTrips.columns.Add("km")          | Out-Null
$lvTrips.columns.Add("Amount")      | Out-Null
$lvTrips.columns.Add("description") | Out-Null
$lvTrips.columns[0].Width = 0
$lvTrips.columns[1].Width = 100
$lvTrips.columns[4].Width = 600


                                                        New-Formbutton  -x 1   -y 1 -width 20   -height 20  -ParentObject $tpAccountbalance -Text "<" -Script {$txtAccountbalanceYear.text = (get-date "1/1/$($txtAccountbalanceYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbAccountbalanceRefresh} | Out-null
[System.Windows.Forms.textbox]$txtAccountbalanceYear =  New-Formtextbox -x 20  -y 1 -width 95   -height 20  -ParentObject $tpAccountbalance -Text $((get-date).ToString("yyyy")) -Disabled
                                                        New-Formbutton  -x 115 -y 1 -width 20   -height 20  -ParentObject $tpAccountbalance -Text ">" -Script {$txtAccountbalanceYear.text =  (get-date "1/1/$($txtAccountbalanceYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbAccountbalanceRefresh} | Out-null
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