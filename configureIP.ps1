$IP = "172.17.2.40"
$MaskBits = 24 # This means subnet mask = 255.255.255.0
$Gateway = "172.17.2.1"
$Dns = "172.17.2.1"
$Dns2 = "8.8.4.4"
$IPType = "IPv4"
$hostname = "somename"

# Retrieve the network adapter that you want to configure
$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}
 # Configure the IP address and default gateway
$adapter | New-NetIPAddress `
 -AddressFamily $IPType `
 -IPAddress $IP `
 -PrefixLength $MaskBits `
 -DefaultGateway $Gateway
# Configure the DNS client server IP addresses
$adapter | Set-DnsClientServerAddress -ServerAddresses ($Dns,$Dns2)

Write-Host "Remaming to"$hostname " ... but you must restart to kick that in."
Rename-Computer -NewName $hostname



$IP = "192.168.152.99"
$MaskBits = 24 # This means subnet mask = 255.255.255.0
$Gateway = "192.168.152.1"
$IPType = "IPv4"

# Retrieve the network adapter that you want to configure
$adapter = Get-NetIPAddress -InterfaceAlias 'vEthernet (IntSwitch)'
# Remove any existing IP, gateway from our ipv4 adapter
If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}
 # Configure the IP address and default gateway
$adapter | New-NetIPAddress `
 -AddressFamily $IPType `
 -IPAddress $IP `
 -PrefixLength $MaskBits `
 -DefaultGateway $Gateway