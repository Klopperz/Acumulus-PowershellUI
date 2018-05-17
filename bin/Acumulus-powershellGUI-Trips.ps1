

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

[scriptblock]$sbTripEdit = {
    Write-host "Not yet finito"
}

[scriptblock]$sbTripRefresh = {
    $lvTrips.Items.Clear()
    $acTrips = Get-ReportTripCompensations -AcumulusAuthentication $authAcumulus -year $($txtTripYear.Text)
    foreach($acTrip in $acTrips) {
        $lviTripitem = New-Object System.Windows.Forms.ListViewItem($acTrip.entryid)
        $lviTripitem.SubItems.Add($acTrip.tripcompensationdate)         | Out-Null
        $lviTripitem.SubItems.Add($acTrip.tripcompensationkm)           | Out-Null
        $lviTripitem.SubItems.Add($acTrip.tripcompensationamount)       | Out-Null
        $lviTripitem.SubItems.Add($acTrip.tripcompensationdescription)  | Out-Null
        $lvTrips.Items.Add($lviTripitem)                                | Out-Null
    }      
}

