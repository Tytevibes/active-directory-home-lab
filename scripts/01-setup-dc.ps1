<#
  PowerShell equivalent of the DC01 setup done through the GUI.
  Run on DC01 as Administrator. Adjust the adapter name to match yours (Get-NetAdapter).
#>

# Rename the server (reboot required)
Rename-Computer -NewName "DC01" -Restart

# --- after reboot ---

# Static IP on the host-only adapter
$adapter = "Ethernet 2"   # host-only adapter
New-NetIPAddress -InterfaceAlias $adapter -IPAddress 192.168.56.10 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias $adapter -ServerAddresses 192.168.56.10

# Install AD DS and promote to a new forest
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSForest `
    -DomainName "lab.local" `
    -DomainNetbiosName "LAB" `
    -InstallDns `
    -SafeModeAdministratorPassword (Read-Host -AsSecureString "DSRM password")
