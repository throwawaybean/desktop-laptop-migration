################################
###         INSEAD           ###
## Contact Pio for any change ##
################################


# Menu
function Show-Menu
{
    param (
        [string]$Title = 'My Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================ `n "
    Write-Host "Press '1' to list all the installed software."
    Write-Host "Press '2' to list mapped drives"
    Write-Host "Press '3' to copy user's profile"
    Write-Host "Press 'Q' to quit."
}
 
##############################
#This shows the installed app#
##############################
 
function List-App
{


$ConfirmComp = $null

while( $ConfirmComp -ne 'y' ){
    $Computer = Read-Host -Prompt 'Enter the computer name (Example: sgp-dt-xxx)'

    if( -not ( Test-Connection -ComputerName $Computer -Count 2 -Quiet ) ){
        Write-Warning "$Computer is not online. Please enter another computer name."
        continue
        }

    $ConfirmComp = Read-Host -Prompt "The entered computer name was:`t$Computer`r`nIs this correct? (y/n)"
    }

Get-CimInstance -ComputerName $Computer -ClassName win32_product -ErrorAction SilentlyContinue| Select-Object PSComputerName, Name, PackageName, InstallDate | Out-GridView

}

#############################
#This shows the shared drive#
#############################

function List-Share
{


$ConfirmComp = $null
$ConfirmUser = $null

while( $ConfirmComp -ne 'y' ){
    $Computer = Read-Host -Prompt 'Enter the computer name (Example: sgp-dt-xxx)'

    if( -not ( Test-Connection -ComputerName $Computer -Count 2 -Quiet ) ){
        Write-Warning "$Computer is not online. Please enter another computer name."
        continue
        }

    $ConfirmComp = Read-Host -Prompt "The entered computer name was:`t$Computer`r`nIs this correct? (y/n)"
    }

while( $ConfirmUser -ne 'y' ){
    $User = Read-Host -Prompt 'Enter the username (Example: jsmith)'

    if( -not ( Test-Path -Path "\\$Computer\c$\Users\$User" -PathType Container ) ){
        Write-Warning "$User could not be found on $Computer. Please enter another user profile."
        continue
        }

    $ConfirmUser = Read-Host -Prompt "The entered user profile was:`t$User`r`nIs this correct? (y/n)"
    }

$sid = (New-Object System.Security.Principal.NTAccount($User)).Translate([System.Security.Principal.SecurityIdentifier]).value


write-host "`nThese drives have been mapped to $User"

invoke-command -computer $computer -scriptblock {

$drives = (gci -Path Microsoft.PowerShell.Core\Registry::HKEY_USERS\$($args[0])\Network -recurse)

$driveresults = foreach ($d in $drives){$q =  ("Microsoft.PowerShell.Core\Registry::HKEY_USERS\$($args[0])\Network\" + $d.pschildname);get-itemproperty -Path $q;}

$driveresults|Format-Table @{L='Drive Letter';E={$_.PSChildName}}, @{L='Path'; E={$_.RemotePath}} -autosize

$SourcePath = Get-Item Registry::HKEY_USERS\$sid\Network | Select-Object -ExpandProperty PSPath # this is to copy the shared drive registry hive

} -argumentlist $sid

$DestinationPath = Get-Item Registry::HKEY_USERS\$sid\Network | Select-Object -ExpandProperty PSPath # this is to copy the shared drive registry hive
Get-ChildItem -Recurse -Path $SourcePath  | Copy-Item -Destination $DestinationPath # this is to copy the shared drive registry hive


}

##############################
#This copies the user profile#
##############################

function Copy-Profile
{


$FoldersToCopy = @(
    'Desktop'
    'Downloads'
    'Favorites'
    'Documents'
    'Pictures'
    'Videos'
    'AppData\Local\Google'
    'Appdata\Local\Firefox'
    'Appdata\Roaming\Microsoft\Template'
    'Appdata\Roaming\Microsoft\Signatures'
    
    )

$ConfirmComp = $null
$ConfirmUser = $null

while( $ConfirmComp -ne 'y' ){
    $Computer = Read-Host -Prompt 'Enter the computer to copy from (Example: sgp-dt-xxx)'

    if( -not ( Test-Connection -ComputerName $Computer -Count 2 -Quiet ) ){
        Write-Warning "$Computer is not online. Please enter another computer name."
        continue
        }

    $ConfirmComp = Read-Host -Prompt "The entered computer name was:`t$Computer`r`nIs this correct? (y/n)"
    }

while( $ConfirmUser -ne 'y' ){
    $User = Read-Host -Prompt 'Enter the user profile to copy from (Example: jsmith)'

    if( -not ( Test-Path -Path "\\$Computer\c$\Users\$User" -PathType Container ) ){
        Write-Warning "$User could not be found on $Computer. Please enter another user profile."
        continue
        }

    $ConfirmUser = Read-Host -Prompt "The entered user profile was:`t$User`r`nIs this correct? (y/n)"
    }

$SourceRoot      = "\\$Computer\c$\Users\$User"
$DestinationRoot = "C:\Users\$User"

foreach( $Folder in $FoldersToCopy ){
    $Source      = Join-Path -Path $SourceRoot -ChildPath $Folder
    $Destination = Join-Path -Path $DestinationRoot -ChildPath $Folder

    if( -not ( Test-Path -Path $Source -PathType Container ) ){
        Write-Warning "Could not find path`t$Source"
        continue
        }

    Robocopy.exe $Source $Destination /E /IS /NP /NFL
    }


}

##############################
#  This controls your menu   #
##############################

do
{
    Show-Menu –Title 'Migration Script'
    $input = Read-Host "`n what do you want to do?"
    switch ($input)
    {
        '1' {    
                cls
                List-App
            }

        '2' {
                cls
                List-Share
            }

         '3' {
                cls
                Copy-Profile
            }

        'q' {
                 return
            }
    }
    pause
}
until ($input -eq 'q')
