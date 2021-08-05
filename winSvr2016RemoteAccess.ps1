# Configure TLS1.2 to allow downloading from github
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download and install powershell core (or latest version from: https://github.com/PowerShell/PowerShell)
Invoke-WebRequest -OutFile C:\windows\Temp\pscore.msi -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.1.3/PowerShell-7.1.3-win-x64.msi
msiexec.exe /qn /i  C:\windows\Temp\pscore.msi

# Unzip Openssh (or latest version from: https://github.com/PowerShell/Win32-OpenSSH/releases)                                  
Invoke-WebRequest -OutFile C:\windows\Temp\openssh.zip -Uri https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win64.zip
Expand-Archive -Path C:\Windows\Temp\openssh.zip -DestinationPath 'C:\Program Files\'
Rename-Item -Path 'C:\Program Files\OpenSSH-Win64' -NewName OpenSSH

# Install openssh
cd 'C:\Program Files\OpenSSH'
.\install-sshd.ps1

# Configure firewall rule (Windows 2012 and above servers only)
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22                      

# Configure firewall rule (others incl. windows clients)
# netsh advfirewall firewall add rule name=sshd dir=in action=allow protocol=TCP localport=22

# Start openssh and set to auto-start
net start sshd
Set-Service sshd -StartupType Automatic
Set-Service ssh-agent -StartupType Automatic

# Add line to sshd_config to add powershell subsystem
Add-Content "$env:PROGRAMDATA\SSH\sshd_config" "Subsystem\tpowershell\t'C:\Program Files\PowerShell\7\pwsh.exe' -sshs -NoLogo -NoProfile"

# Add line to sshd_config to add powershell subsystem
$fileName = "$env:PROGRAMDATA\SSH\sshd_config"
(Get-Content $fileName) |
   Foreach-Object {
      $_
      if ($_ -match "override default of no subsystems")
      {
         "Subsystem`tpowershell`t'C:\Program Files\PowerShell\7\pwsh.exe' -sshs -NoLogo -NoProfile"
      }
   } | Set-Content $fileName

# Check password authentication is set to yes (this is default so if commented, its ok too)
Write-Host 'Check password authentication is set to yes (this is default so if commented, its ok too) ...'
Select-String -Path $env:PROGRAMDATA\SSH\sshd_config -Pattern 'PasswordAuth'

# Restart sshd
Restart-Service sshd

# Add openssh to path
$env:Path += ";C:\Program Files\OpenSSH"

# Enable RDP also
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop" 
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1