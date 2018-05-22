[scriptblock]$sbAccountbalanceChangeYearAdd = {
    $txtAccountbalanceYear.text = (get-date "1/1/$($txtAccountbalanceYear.text)").addYears(1).ToString("yyyy"); Invoke-Command $sbAccountbalanceRefresh
}

[scriptblock]$sbAccountbalanceChangeYearRemove = {
    $txtAccountbalanceYear.text = (get-date "1/1/$($txtAccountbalanceYear.text)").addYears(-1).ToString("yyyy"); Invoke-Command $sbAccountbalanceRefresh
}

[scriptblock]$sbAccountbalanceRefresh = {
    $lvAccountbalance.Items.Clear()
    $acAccountbalances = Get-ReportAccountbalances -AcumulusAuthentication $authAcumulus -year $($txtAccountbalanceYear.Text)
    foreach($acAccountbalance in $acAccountbalances) {
        $lviAccountbalance = New-Object System.Windows.Forms.ListViewItem($acAccountbalance.accountid)
        $lviAccountbalance.SubItems.Add([Convert]::toString($acAccountbalance.accountnumber))      | Out-Null
        $lviAccountbalance.SubItems.Add([Convert]::toString($acAccountbalance.accountbalance))     | Out-Null
        $lviAccountbalance.SubItems.Add([Convert]::toString($acAccountbalance.accountdescription)) | Out-Null
        $lvAccountbalance.Items.Add($lviAccountbalance)                                            | Out-Null
    }

}