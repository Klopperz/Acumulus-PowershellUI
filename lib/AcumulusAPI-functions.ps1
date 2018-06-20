

Function Add-Trip
{
param (
    [Parameter(Mandatory=$true)]  $AcumulusAuthentication,
    [Parameter(Mandatory=$false)] [datetime]$tripdate,
    [Parameter(Mandatory=$false)] [string]$tripdescription,
    [Parameter(Mandatory=$true)]  [string]$tripkmwayout,
    [Parameter(Mandatory=$true)]  [string]$tripkmreturn,
    [Parameter(Mandatory=$false)] [string]$tripkmcompensation,
    #[Parameter(Mandatory=$false)][string]$tripcompensationtotal,
    [Parameter(Mandatory=$false)] [string]$tripcostcenterid
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication

    $trip = $SubmitXML.CreateElement('trip')

    $elementtripdate = $trip.AppendChild($SubmitXML.CreateElement("tripdate"))
    if ($tripdate) { $elementtripdate.AppendChild($SubmitXML.CreateTextNode($tripdate.ToString("yyyy-MM-dd")))  | Out-Null }

    $elementtripdescription = $trip.AppendChild($SubmitXML.CreateElement("tripdescription"))
    if ($tripdescription) { $elementtripdescription.AppendChild($SubmitXML.CreateTextNode($tripdescription))  | Out-Null }

    $elementtripkmwayout = $trip.AppendChild($SubmitXML.CreateElement("tripkmwayout"))
    $elementtripkmwayout.AppendChild($SubmitXML.CreateTextNode($tripkmwayout)) | Out-Null

    $elementtripkmreturn = $trip.AppendChild($SubmitXML.CreateElement("tripkmreturn"))
    $elementtripkmreturn.AppendChild($SubmitXML.CreateTextNode($tripkmreturn)) | Out-Null

    $elementtripkmcompensation = $trip.AppendChild($SubmitXML.CreateElement("tripkmcompensation"))
    if ($tripkmcompensation) { $elementtripkmcompensation.AppendChild($SubmitXML.CreateTextNode($tripkmcompensation))  | Out-Null }

    $elementtripcompensationtotal = $trip.AppendChild($SubmitXML.CreateElement("tripcompensationtotal"))
    if ($tripcompensationtotal) { $elementtripcompensationtotal.AppendChild($SubmitXML.CreateTextNode($tripcompensationtotal)) | Out-Null }

    $elementtripcostcenterid = $trip.AppendChild($SubmitXML.CreateElement("tripcostcenterid"))
    if ($tripcostcenterid) { $elementtripcostcenterid.AppendChild($SubmitXML.CreateTextNode($tripcostcenterid)) | Out-Null }

    $SubmitXML.myxml.AppendChild($trip) 
    Write-verbose $($SubmitXML.InnerXml)
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/trips/trip_add.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.trip
}

Function Get-AuthenticationObject
{
param (
    [Parameter(Mandatory=$true, HelpMessage="The contract code of your acumulus account")][string]$contractcode,
    [Parameter(Mandatory=$true, HelpMessage="The username of your acumulus account")]     [string]$username,
    [Parameter(Mandatory=$true, HelpMessage="The password of your acumulus account")]     [string]$password,
    [Parameter(Mandatory=$true)]                                                          [string]$emailonerror,
    [Parameter(Mandatory=$false)]                                                         [switch]$testmode
)
    $authAcumulus = New-Object PSObject
    $authAcumulus | add-member Noteproperty contractcode $contractcode
    $authAcumulus | add-member Noteproperty username $username
    $authAcumulus | add-member Noteproperty password $password
    $authAcumulus | add-member Noteproperty emailonerror $emailonerror
    if ($testmode){
        $authAcumulus | add-member Noteproperty testmode 1
    }
    else {
        $authAcumulus | add-member Noteproperty testmode 0
    }
    return $authAcumulus
}

Function Get-BasicSubmit
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication
)

    [xml]$PostXML = @"
<?xml version="1.0" encoding="UTF-8"?>
<myxml>
    <contract>
        <contractcode>$($AcumulusAuthentication.contractcode)</contractcode>
        <username>$($AcumulusAuthentication.username)</username>
        <password>$($AcumulusAuthentication.password)</password>
        <emailonerror>$($AcumulusAuthentication.emailonerror)</emailonerror>
        <emailonwarning>$($AcumulusAuthentication.emailonerror)</emailonwarning>
    </contract>
    <format>json</format>
    <testmode>$($AcumulusAuthentication.testmode)</testmode>
</myxml>
"@
    return $PostXML
}

Function Get-Entry
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication,
    [Parameter(Mandatory=$true)][string]$entryid
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $NewXMLElement = $SubmitXML.CreateElement('entryid')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    $SubmitXML.myxml.entryid = $entryid
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/entry/entry_info.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.entry
}

Function Get-PicklistAccounts
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/picklists/picklist_accounts.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.accounts
}

Function Get-PicklistProducts
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication,
    [Parameter(Mandatory=$true)][string]$producttagid
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $NewXMLElement = $SubmitXML.CreateElement('producttagid')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    $SubmitXML.myxml.producttagid = $producttagid
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/picklists/picklist_products.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.trips
}

Function Get-PicklistProducttags
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/picklists/picklist_producttags.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.trips
}

Function Get-PicklistProjects
{
param (
    [Parameter(Mandatory=$true)] $AcumulusAuthentication,
    [Parameter(Mandatory=$false)][string]$projectid,
    [Parameter(Mandatory=$false)][ValidateSet('0','1','2')][string]$projectstatus
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    if ($projectid)
    {
        $NewXMLElement = $SubmitXML.CreateElement('projectid')
        $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
        $SubmitXML.myxml.projectid = $projectid
    }
    if ($projectstatus)
    {
        $NewXMLElement = $SubmitXML.CreateElement('projectstatus')
        $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
        $SubmitXML.myxml.projectstatus = $projectstatus
    }
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/picklists/picklist_projects.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.projects
}

Function Get-PicklistProjectItems
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication,
    [Parameter(Mandatory=$true)][string]$projectid
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $NewXMLElement = $SubmitXML.CreateElement('projectid')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    $SubmitXML.myxml.projectid = $projectid
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/picklists/picklist_projectitems.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.project
}

Function Get-PicklistTrips
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/picklists/picklist_trips.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.trips
}

Function Get-ReportAccountbalances
{
param (
    [Parameter(Mandatory=$true)] $AcumulusAuthentication,
    [Parameter(Mandatory=$false)][string]$year = $((Get-date).tostring("yyyy"))
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $NewXMLElement = $SubmitXML.CreateElement('year')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    $SubmitXML.myxml.year = $year
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/reports/report_accountbalances.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.accountbalances.account
}

Function Get-ReportProfitPerMonth
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication,
    [Parameter(Mandatory=$false, HelpMessage="year of the accountbalance")][string]$year = $((Get-date).tostring("yyyy"))
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $NewXMLElement = $SubmitXML.CreateElement('year')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    $SubmitXML.myxml.year = $year
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/reports/report_profit_per_month.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.profit
}

Function Get-ReportTripCompensations
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication,
    [Parameter(Mandatory=$false, HelpMessage="year of the accountbalance")][string]$year = $((Get-date).tostring("yyyy"))
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $NewXMLElement = $SubmitXML.CreateElement('year')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    $SubmitXML.myxml.year = $year
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/reports/report_tripcompensations.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.tripcompensations.tripcompensation
}
Function Get-ReportUnpaidCreditors
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication,
    [Parameter(Mandatory=$false)][string]$year = $((Get-date).tostring("yyyy"))
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $NewXMLElement = $SubmitXML.CreateElement('year')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    $SubmitXML.myxml.year = $year
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/reports/report_unpaid_creditors.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.unpaidcreditorinvoices
}

Function Get-ReportUnpaidDebtors
{
param (
    [Parameter(Mandatory=$true)]$AcumulusAuthentication,
    [Parameter(Mandatory=$false)][string]$year = $((Get-date).tostring("yyyy")),
    [Parameter(Mandatory=$false)][switch]$due
)
    [xml]$SubmitXML = Get-BasicSubmit -AcumulusAuthentication $AcumulusAuthentication
    $NewXMLElement = $SubmitXML.CreateElement('year')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    $SubmitXML.myxml.year = $year
    $NewXMLElement = $SubmitXML.CreateElement('due')
    $SubmitXML.myxml.AppendChild($NewXMLElement) | out-null
    if ($due)
    {
        $SubmitXML.myxml.due = "1"
    }
    else 
    {
        $SubmitXML.myxml.due = "0"
    }
    $Response = Invoke-WebRequest 'https://api.sielsystems.nl/acumulus/stable/reports/report_unpaid_debtors.php' -Body "xmlstring=$($SubmitXML.InnerXml)" -Method 'POST' 
    $Response = $Response | ConvertFrom-Json
    return $Response.unpaiddebtorinvoices
}