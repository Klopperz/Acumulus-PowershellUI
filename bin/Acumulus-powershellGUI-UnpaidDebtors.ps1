[scriptblock]$sbUnpaidDebtorsChangeYearAdd = {
    $txtUnpaidDebtorsYear.text =  (get-date "1/1/$($txtUnpaidDebtorsYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbUnpaidDebtorsRefresh
}

[scriptblock]$sbUnpaidDebtorsChangeYearRemove = {
    $txtUnpaidDebtorsYear.text =  (get-date "1/1/$($txtUnpaidDebtorsYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbUnpaidDebtorsRefresh
}

[scriptblock]$sbUnpaidDebtorsRefresh = {
    $lvUnpaidDebtors.Items.Clear()
    $acUnpaidDebtors = Get-ReportUnpaidDebtors -AcumulusAuthentication $authAcumulus -year $($txtUnpaidDebtorsYear.Text) -due
    foreach($acUnpaidDebtor in $acUnpaidDebtors) {
        $lviUnpaidDebtoritem = New-Object System.Windows.Forms.ListViewItem($acUnpaidDebtor.numberunpaiddebtors)
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtor.amountunpaiddebtors))  | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtor.numberoverduedebtors)) | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtor.amountoverduedebtors)) | Out-Null
        $lvUnpaidDebtors.Items.Add($lviUnpaidDebtoritem)                                             | Out-Null
    }  
}