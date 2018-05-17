param (
    [Parameter(Mandatory=$true, HelpMessage="The contract code of your acumulus account")][string]$contractcode,
    [Parameter(Mandatory=$true, HelpMessage="The username of your acumulus account")]     [string]$username,
    [Parameter(Mandatory=$true, HelpMessage="The password of your acumulus account")]     [Security.SecureString]$SecurePassword,
    [Parameter(Mandatory=$false)]                                                         [string]$emailonerror = "noreplay@planetearth.com",
    [Parameter(Mandatory=$false)]                                                         [switch]$testmode
)

[System.String]$sScript_Version         = "0.2"
[System.String]$sScript_Name            = "Acumulus-powershellGUI"
[System.String]$sUser                   = $env:username
[System.String]$sFolder_Root            = (Get-Item $PSScriptRoot).parent.FullName
[System.String]$sFolder_Bin             = "$sFolder_Root\bin"
[System.String]$sFolder_Etc             = "$sFolder_Root\etc"
[System.String]$sFolder_Home            = "$sFolder_Root\home"
[System.String]$sFolder_Lib             = "$sFolder_Root\lib"
[System.String]$sFolder_Log             = "$sFolder_Root\log"
[System.String]$sFolder_Srv             = "$sFolder_Root\srv"
[System.String]$sFolder_User            = "$sFolder_Home\$sUser"
[System.String]$sScript_Config          = "$sFolder_Etc\$sScript_Name.ini"
[System.String]$sFile_Log               = "$sFolder_Log\$sScript_Name.log"

. $sFolder_Lib\AcumulusAPI-functions.ps1
. $sFolder_Lib\Form-functions.ps1
. $sFolder_Lib\Get-functions.ps1
. $sFolder_Lib\Set-functions.ps1
. $sFolder_Bin\Acumulus-powershellGUI-Accountbalance.ps1
. $sFolder_Bin\Acumulus-powershellGUI-Trips.ps1
. $sFolder_Bin\Acumulus-powershellGUI-Main.ps1

[Hashtable]$htScript_config             = Get-IniContent $sScript_Config
[System.String]$sFile_ico               = $($htScript_config["Files"]["ico"]).Replace("%SVR%",$sFolder_Srv)
[System.String]$sFile_usersettings      = $($htScript_config["Files"]["usersettings"]).Replace("%USERHOME%",$sFolder_User)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword))
$authAcumulus = Get-AuthenticationObject -contractcode $contractcode -username $username -password $password -emailonerror $emailonerror -testmode:$testmode

Invoke-Command $sbTripRefresh
Invoke-Command $sbAccountbalanceRefresh
$frmMain.ShowDialog()