

[scriptblock]$sbTripAdd = {
    [datetime[]]$dtDatewithTrips =@()
    Foreach ($TripItems in $lvTrips.Items){
        $dtDatewithTrips += [datetime]::ParseExact($TripItems.SubItems[1].Text, "dd-MM-yyyy", $null)
    }

    $frmTripAdd =           New-Form                 -width 360 -height 320 -header "Add trip" -borderstyle FixedSingle -icon $sFile_ico -hide_maximizebox 
                            New-Formlabel -x 1 -y 70 -width 100 -height 25  -ParentObject $frmTripAdd -Text "Date:" | Out-Null

    $calTripSelection =     New-Formcalendar  -x 100 -y 1 -width 150 -height 150 -ParentObject $frmTripAdd -ShowTodayCircle -MaxSelectionCount 5 -bolteddates $dtDatewithTrips

                            New-Formlabel   -x 1   -y 160 -width 100 -height 25 -ParentObject $frmTripAdd -Text "KM To:" | Out-Null
    $txtAddTripTo =         New-Formtextbox -x 100 -y 160 -width 100 -height 25 -ParentObject $frmTripAdd 
                            New-Formlabel   -x 1   -y 190 -width 100 -height 25 -ParentObject $frmTripAdd -Text "KM Return:" | Out-Null
    $txtAddTripFrom =       New-Formtextbox -x 100 -y 190 -width 100 -height 25 -ParentObject $frmTripAdd 
                            New-Formlabel   -x 1   -y 220 -width 100 -height 25 -ParentObject $frmTripAdd -Text "Description:" | Out-Null
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

[scriptblock]$sbTripChangeYearAdd = {
    $txtTripYear.text =  (get-date "1/1/$($txtTripYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbTripRefresh
}

[scriptblock]$sbTripChangeYearRemove = {
    $txtTripYear.text =  (get-date "1/1/$($txtTripYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbTripRefresh
}

[scriptblock]$sbTripEdit = {
    entryEdit -iEntryId $lvTrips.SelectedItems.SubItems[0].Text -sHeader "View trip" -ViewOnly
}

[scriptblock]$sbTripRefresh = {
    $lvTrips.Items.Clear()
    $acTrips = Get-ReportTripCompensations -AcumulusAuthentication $authAcumulus -year $($txtTripYear.Text)
    foreach($acTrip in $acTrips) {
        $lviTripitem = New-Object System.Windows.Forms.ListViewItem($acTrip.entryid)
        $lviTripitem.SubItems.Add([Convert]::toString($acTrip.tripcompensationdate))         | Out-Null
        $lviTripitem.SubItems.Add([Convert]::toString($acTrip.tripcompensationkm))           | Out-Null
        $lviTripitem.SubItems.Add([Convert]::toString($acTrip.tripcompensationamount))       | Out-Null
        $lviTripitem.SubItems.Add([Convert]::toString($acTrip.tripcompensationdescription))  | Out-Null
        $lvTrips.Items.Add($lviTripitem)                                                     | Out-Null
    }      
}

