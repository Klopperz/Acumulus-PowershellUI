
[scriptblock]$sbAccountbalanceRefresh = {
    $lvAccountbalance.Items.Clear()
    $acAccountbalances = Get-ReportAccountbalances -AcumulusAuthentication $authAcumulus -year $($txtAccountbalanceYear.Text)
    foreach($acAccountbalance in $acAccountbalances) {
        $lviAccountbalance = New-Object System.Windows.Forms.ListViewItem($acAccountbalance.accountid)
        $lviAccountbalance.SubItems.Add($acAccountbalance.accountnumber)      | Out-Null
        $lviAccountbalance.SubItems.Add($acAccountbalance.accountbalance)     | Out-Null
        $lviAccountbalance.SubItems.Add($acAccountbalance.accountdescription) | Out-Null
        $lvAccountbalance.Items.Add($lviAccountbalance)                       | Out-Null
    }
}




