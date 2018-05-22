

[scriptblock]$sbTripAdd = {
    [datetime[]]$dtDatewithTrips =@()
    Foreach ($TripItems in $lvTrips.Items){
        $dtDatewithTrips += [datetime]::ParseExact($TripItems.SubItems[1].Text, "dd-MM-yyyy", $null)
    }

    $frmTripAdd =           New-Form                 -width 360 -height 320 -header "AddTrip" -borderstyle FixedSingle -icon $sFile_ico -hide_maximizebox 
                            New-Formlabel -x 1 -y 70 -width 100 -height 25  -ParentObject $frmTripAdd -Text "Datum:" | Out-Null

    $calTripSelection =     New-Formcalendar  -x 100 -y 1 -width 150 -height 150 -ParentObject $frmTripAdd -ShowTodayCircle -MaxSelectionCount 5 -bolteddates $dtDatewithTrips

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

[scriptblock]$sbTripChangeYearAdd = {
    $txtTripYear.text =  (get-date "1/1/$($txtTripYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbTripRefresh
}

[scriptblock]$sbTripChangeYearRemove = {
    $txtTripYear.text =  (get-date "1/1/$($txtTripYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbTripRefresh
}

[scriptblock]$sbTripEdit = {
    $acTripDetails = Get-Entry -AcumulusAuthentication $authAcumulus -entryid $lvTrips.SelectedItems.SubItems[0].Text


    $frmTripEdit =                  New-Form                      -width 400 -height 780 -header "ViewTrip" -borderstyle FixedSingle -icon $sFile_ico -hide_maximizebox 
                                    New-Formlabel   -x 1   -y 1   -width 100 -height 20 -ParentObject $frmTripEdit -Text "EntryID" | Out-Null
    $txtTripEditEntryid =           New-Formtextbox -x 100 -y 1   -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.entryid -disabled
                                    New-Formlabel   -x 1   -y 30  -width 100 -height 20 -ParentObject $frmTripEdit -Text "Entrydate" | Out-Null
    $txtTripEditentrydate =         New-Formtextbox -x 100 -y 30  -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.entrydate -disabled
                                    New-Formlabel   -x 1   -y 60  -width 100 -height 20 -ParentObject $frmTripEdit -Text "Entrytype" | Out-Null
    $txtTripEditEntryid =           New-Formtextbox -x 100 -y 60  -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.entrytype -disabled
                                    New-Formlabel   -x 1   -y 90  -width 100 -height 20 -ParentObject $frmTripEdit -Text "Entrydescription" | Out-Null
    $txtTripEditEntrydescription =  New-Formtextbox -x 100 -y 90  -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.entrydescription -disabled
                                    New-Formlabel   -x 1   -y 120 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Entrynote" | Out-Null
    $txtTripEditEntrynote =         New-Formtextbox -x 100 -y 120 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.entrynote -disabled
                                    New-Formlabel   -x 1   -y 150 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Fiscaltype" | Out-Null
    $txtTripEditFiscaltype =        New-Formtextbox -x 100 -y 150 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.fiscaltype -disabled
                                    New-Formlabel   -x 1   -y 180 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Vatreversecharge" | Out-Null
    $txtTripEditVatreversecharge =  New-Formtextbox -x 100 -y 180 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.vatreversecharge -disabled
                                    New-Formlabel   -x 1   -y 210 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Foreigneu" | Out-Null
    $txtTripEditForeigneu =         New-Formtextbox -x 100 -y 210 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.foreigneu -disabled
                                    New-Formlabel   -x 1   -y 240 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Foreignnoneu" | Out-Null
    $txtTripEditForeignnoneu =      New-Formtextbox -x 100 -y 240 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.foreignnoneu -disabled
                                    New-Formlabel   -x 1   -y 270 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Marginscheme" | Out-Null
    $txtTripEditMarginscheme =      New-Formtextbox -x 100 -y 270 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.marginscheme -disabled
                                    New-Formlabel   -x 1   -y 300 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Foreignvat" | Out-Null
    $txtTripEditForeignvat =        New-Formtextbox -x 100 -y 300 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.foreignvat -disabled
                                    New-Formlabel   -x 1   -y 330 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Contactid" | Out-Null
    $txtTripEditContactid =         New-Formtextbox -x 100 -y 330 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.contactid -disabled
                                    New-Formlabel   -x 1   -y 360 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Accountnumber" | Out-Null
    $txtTripEditAccountnumber =     New-Formtextbox -x 100 -y 360 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.accountnumber -disabled
                                    New-Formlabel   -x 1   -y 390 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Costcenterid" | Out-Null
    $txtTripEditCostcenterid =      New-Formtextbox -x 100 -y 390 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.costcenterid -disabled
                                    New-Formlabel   -x 1   -y 420 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Costtypeid" | Out-Null
    $txtTripEditCosttypeid =        New-Formtextbox -x 100 -y 420 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.costtypeid -disabled
                                    New-Formlabel   -x 1   -y 450 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Invoicenumber" | Out-Null
    $txtTripEditInvoicenumber =     New-Formtextbox -x 100 -y 450 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.invoicenumber -disabled
                                    New-Formlabel   -x 1   -y 480 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Invoicenote" | Out-Null
    $txtTripEditInvoicenote =       New-Formtextbox -x 100 -y 480 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.invoicenote -disabled
                                    New-Formlabel   -x 1   -y 510 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Descriptiontext" | Out-Null
    $txtTripEditDescriptiontext =   New-Formtextbox -x 100 -y 510 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.descriptiontext -disabled
                                    New-Formlabel   -x 1   -y 540 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Invoicelayoutid" | Out-Null
    $txtTripEditInvoicelayoutid =   New-Formtextbox -x 100 -y 540 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.invoicelayoutid -disabled
                                    New-Formlabel   -x 1   -y 570 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Totalvalueexclvat" | Out-Null
    $txtTripEditTotalvalueexclvat = New-Formtextbox -x 100 -y 570 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.totalvalueexclvat -disabled
                                    New-Formlabel   -x 1   -y 600 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Totalvalue" | Out-Null
    $txtTripEditTotalvalue =        New-Formtextbox -x 100 -y 600 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.totalvalue -disabled
                                    New-Formlabel   -x 1   -y 630 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Paymenttermdays" | Out-Null
    $txtTripEditPaymenttermdays =   New-Formtextbox -x 100 -y 630 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.paymenttermdays -disabled
                                    New-Formlabel   -x 1   -y 660 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Paymentdate" | Out-Null
    $txtTripEditPaymentdate =       New-Formtextbox -x 100 -y 660 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.paymentdate -disabled
                                    New-Formlabel   -x 1   -y 690 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Paymentstatus" | Out-Null
    $txtTripEditPaymentstatus =     New-Formtextbox -x 100 -y 690 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.paymentstatus -disabled
                                    New-Formlabel   -x 1   -y 720 -width 100 -height 20 -ParentObject $frmTripEdit -Text "Deleted" | Out-Null
    $txtTripEditDeleted =           New-Formtextbox -x 100 -y 720 -width 280 -height 20 -ParentObject $frmTripEdit -Text $acTripDetails.deleted -disabled
    $frmTripEdit.ShowDialog()
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

