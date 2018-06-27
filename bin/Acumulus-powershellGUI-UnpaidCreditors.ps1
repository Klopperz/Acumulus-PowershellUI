[scriptblock]$sbUnpaidCreditorsChangeYearAdd = {
    $txtUnpaidCreditorsYear.text =  (get-date "1/1/$($txtUnpaidCreditorsYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbUnpaidCreditorsRefresh
}

[scriptblock]$sbUnpaidCreditorsChangeYearRemove = {
    $txtUnpaidCreditorsYear.text =  (get-date "1/1/$($txtUnpaidCreditorsYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbUnpaidCreditorsRefresh
}

[scriptblock]$sbUnpaidCreditorsRefresh = {
    $lvUnpaidCreditors.Items.Clear()
    $acUnpaidCreditors = Get-ReportUnpaidCreditors -AcumulusAuthentication $authAcumulus -year $($txtUnpaidCreditorsYear.Text)
    foreach($acUnpaidCreditorEntry in $acUnpaidCreditors.entry) {
        $lviUnpaidCreditoritem = New-Object System.Windows.Forms.ListViewItem($acUnpaidCreditorEntry.entryid)
        $lviUnpaidCreditoritem.SubItems.Add([Convert]::toString($acUnpaidCreditorEntry.issuedate))          | Out-Null
        $lviUnpaidCreditoritem.SubItems.Add([Convert]::toString($acUnpaidCreditorEntry.contactname))        | Out-Null
        $lviUnpaidCreditoritem.SubItems.Add([Convert]::toString($acUnpaidCreditorEntry.accountnumber))      | Out-Null
        $lviUnpaidCreditoritem.SubItems.Add([Convert]::toString($acUnpaidCreditorEntry.amount))             | Out-Null
        $lvUnpaidCreditors.Items.Add($lviUnpaidCreditoritem)                                                | Out-Null
    }  
}

[scriptblock]$sbUnpaidCreditorsEdit = {
    entryEdit -iEntryId $lvUnpaidCreditors.SelectedItems.SubItems[0].Text
}