<#
  PowerShell equivalent of the OU, user and group setup done in ADUC.
  Run on DC01.
#>

Import-Module ActiveDirectory

$domainDN = "DC=lab,DC=local"
$ouPath   = "OU=Company,$domainDN"

New-ADOrganizationalUnit -Name "Company" -Path $domainDN

$password = Read-Host -AsSecureString "Initial password for new users"

$users = @(
    @{ First = "Jane"; Last = "Jones"; Sam = "jjones" },
    @{ First = "Mark"; Last = "Lee";   Sam = "mlee"   },
    @{ First = "Dana"; Last = "Lee";   Sam = "dlee"   }
)

foreach ($u in $users) {
    New-ADUser `
        -Name "$($u.First) $($u.Last)" `
        -GivenName $u.First `
        -Surname $u.Last `
        -SamAccountName $u.Sam `
        -UserPrincipalName "$($u.Sam)@lab.local" `
        -Path $ouPath `
        -AccountPassword $password `
        -Enabled $true
}

New-ADGroup -Name "Sales" -GroupScope Global -GroupCategory Security -Path $ouPath
Add-ADGroupMember -Identity "Sales" -Members "jjones", "mlee", "dlee"

Get-ADGroupMember -Identity "Sales" | Select-Object Name, SamAccountName
