$DomainName = "mayorsec.local"
$SecureStringPw = (ConvertTo-SecureString -String "Password123!" -asplaintext -Force)
Write-Host $SecureStringPw

function ShowBanner {
    $banner  = @()
    $banner+= $Global:Spacing + ''
$banner+= $Global:Spacing + '     ______                     __        ____             __           '
$banner+= $Global:Spacing + '    / ____/___  ________  _____/ /_      / __ \___  ____  / /___  __  __'
$banner+= $Global:Spacing + '   / /_  / __ \/ ___/ _ \/ ___/ __/_____/ / / / _ \/ __ \/ / __ \/ / / /'
$banner+= $Global:Spacing + '  / __/ / /_/ / /  /  __(__  ) /_/_____/ /_/ /  __/ /_/ / / /_/ / /_/ / '
$banner+= $Global:Spacing + ' /_/    \____/_/   \___/____/\__/     /_____/\___/ .___/_/\____/\__, /  '
$banner+= $Global:Spacing + '                                                /_/            /____/   '
$banner+= $Global:Spacing + 'Domain Deployment Script by TheMayor'
$banner+= $Global:Spacing + ''
	$banner | foreach-object {
        Write-Host $_ -ForegroundColor "Yellow"
	}
}

function Write-Good { param( $String ) Write-Host $Global:InfoLine $String $Global:InfoLine1 -ForegroundColor 'Green' }
function Write-Info { param( $String ) Write-Host $String -ForegroundColor 'Gray'}
$Global:Spacing = "`t"
$Global:PlusLine = "`t[+]"
$Global:InfoLine = "`t[*]"
$Global:InfoLine1 = "[*]"


function addsInstall {
Write-Good "Installing Windows AD Domain Services Toolset."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Write-Info "`n`nToolset installed.`n`n"
}

function forestDeploy {
Write-Good "Generating the domain.Using mayorsec.local and Password123! for safemode password."
$DomainNetBiosName = $DomainName.split('.')[0]
Install-ADDSForest -DomainName $DomainName -DomainNetBiosName $DomainNetBiosName -InstallDNS:$true -SafeModeAdministratorPassword $SecureStringPw -Force
Write-Info "`n`nDone with forestDeploy, please wait!."
}

function Invoke-ForestDeploy {
	Param(
	[Parameter(Mandatory=$True)]
	[ValidateNotNullOrEmpty()]
	[System.String]
	$DomainName
)

}

function promoteUser {
$username = ((gwmi win32_computersystem).username).split('\')[1]
Write-Good "Promoting $username to appropriate Domain Administrative roles required for the course."
Write-Info "Promoting $username to Enterprise Administrator."
net group "Enterprise Admins" $username /add /domain
Write-Info "Promoting $username to Domain Administrator."
net group "Domain Admins" $username /add /domain
Write-Info "Promoting $username to Group Policy Creator Owners."
net group "Group Policy Creator Owners" $username /add /domain
Write-Info "Promoting $username to Local Administrator (error output may occur - this is expected)."
net localgroup "administrators" $username /add
}


ShowBanner
addsInstall
forestDeploy
promoteUser
