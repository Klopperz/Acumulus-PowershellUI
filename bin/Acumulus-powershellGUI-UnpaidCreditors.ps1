[scriptblock]$sbUnpaidCreditorsChangeYearAdd = {
    $txtUnpaidCreditorsYear.text =  (get-date "1/1/$($txtUnpaidCreditorsYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbUnpaidCreditorsRefresh
}

[scriptblock]$sbUnpaidCreditorsChangeYearRemove = {
    $txtUnpaidCreditorsYear.text =  (get-date "1/1/$($txtUnpaidCreditorsYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbUnpaidCreditorsRefresh
}

[scriptblock]$sbUnpaidCreditorsRefresh = {
    $lvUnpaidCreditors.Items.Clear()
    $acUnpaidCreditors = Get-ReportUnpaidCreditors -AcumulusAuthentication $authAcumulus -year $($txtUnpaidCreditorsYear.Text)
    foreach($acUnpaidCreditor in $acUnpaidCreditors) {
        $lviUnpaidCreditoritem = New-Object System.Windows.Forms.ListViewItem($acUnpaidCreditor.numberunpaidcreditors)
        $lviUnpaidCreditoritem.SubItems.Add([Convert]::toString($acUnpaidCreditor.numberunpaidcreditors))  | Out-Null
        $lvUnpaidCreditors.Items.Add($lviUnpaidCreditoritem)                                               | Out-Null
    }  
}