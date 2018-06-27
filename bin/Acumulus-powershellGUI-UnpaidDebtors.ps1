[scriptblock]$sbUnpaidDebtorsChangeYearAdd = {
    $txtUnpaidDebtorsYear.text =  (get-date "1/1/$($txtUnpaidDebtorsYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbUnpaidDebtorsRefresh
}

[scriptblock]$sbUnpaidDebtorsChangeYearRemove = {
    $txtUnpaidDebtorsYear.text =  (get-date "1/1/$($txtUnpaidDebtorsYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbUnpaidDebtorsRefresh
}

[scriptblock]$sbUnpaidDebtorsRefresh = {
    $lvUnpaidDebtors.Items.Clear()
    $acUnpaidDebtors = Get-ReportUnpaidDebtors -AcumulusAuthentication $authAcumulus -year $($txtUnpaidDebtorsYear.Text) -due
    foreach($acUnpaidDebtorEntry in $acUnpaidDebtors.entry) {
        $lviUnpaidDebtoritem = New-Object System.Windows.Forms.ListViewItem($acUnpaidDebtorEntry.entryid)
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtorEntry.number))         | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtorEntry.issuedate))      | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtorEntry.expirationdate)) | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtorEntry.daysdue))        | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add("$((new-timespan -Start ($acUnpaidDebtorEntry.issuedate) -End (Get-Date)).Days) / $([Convert]::toString($acUnpaidDebtorEntry.invoicedaylimit))") | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtorEntry.contactname))    | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtorEntry.accountnumber))  | Out-Null
        $lviUnpaidDebtoritem.SubItems.Add([Convert]::toString($acUnpaidDebtorEntry.amount))         | Out-Null
        $lvUnpaidDebtors.Items.Add($lviUnpaidDebtoritem)                                            | Out-Null
    }  
}

[scriptblock]$sbUnpaidDebtorsEdit = {
    entryEdit -iEntryId $lvUnpaidDebtors.SelectedItems.SubItems[0].Text
}