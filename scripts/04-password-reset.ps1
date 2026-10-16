<#
  PowerShell equivalent of the help desk password reset done in ADUC.
  Run on DC01.
#>

Import-Module ActiveDirectory

$user = "jjones"

# Check the account's current state
Get-ADUser $user -Properties LockedOut, Enabled, PasswordLastSet |
    Select-Object Name, Enabled, LockedOut, PasswordLastSet

# Reset the password, unlock, and force a change at next logon
Set-ADAccountPassword -Identity $user -Reset -NewPassword (Read-Host -AsSecureString "Temporary password")
Unlock-ADAccount -Identity $user
Set-ADUser -Identity $user -ChangePasswordAtLogon $true
