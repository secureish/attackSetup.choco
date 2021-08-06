New-VM -Name DC -MemoryStartupBytes 512MB -Path D:\ws2012.local
New-VHD -Path D:\ws2012.localDCDC.vhdx -SizeBytes 60GB -Dynamic
Add-VMHardDiskDrive -VMName DC -Path "C:\ws2012.localDCDC.vhdx" 
Set-VMDvdDrive -VMName DC -ControllerNumber 1 -Path "<path to ISO>"
Set-VMMemory -VMName DC -DynamicMemoryEnabled $true -StartupBytes 512MB -MinimumByte 512
Start-VM –Name DC
Get-VM DC
