<#
  PowerShell equivalent of the CLIENT02 network fix and domain join.
  Run on CLIENT02 as a local Administrator. Adjust the adapter name (Get-NetAdapter).
#>

$adapter = "Ethernet 2"   # host-only adapter

# Correct the IP settings (mask /24 = 255.255.255.0) and point DNS at DC01
Set-NetIPInterface -InterfaceAlias $adapter -Dhcp Disabled
Get-NetIPAddress -InterfaceAlias $adapter -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Remove-NetIPAddress -Confirm:$false
New-NetIPAddress -InterfaceAlias $adapter -IPAddress 192.168.56.20 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias $adapter -ServerAddresses 192.168.56.10

# Verify connectivity and DNS before joining
Test-NetConnection 192.168.56.10 -Port 53
Resolve-DnsName lab.local -Server 192.168.56.10

# Join the domain and restart
Add-Computer -DomainName "lab.local" -Credential "LAB\Administrator" -Restart

# After logging in as LAB\jjones:
#   whoami   ->  lab\jjones
