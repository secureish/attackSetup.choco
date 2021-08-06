$vmname
$vmpath = "C:\VMs\"+$vmname
$hddath = $vmpath+"hdds\"
$isospath = "C:\VMs\isos\"
$isoname = "windows10x64.iso"

New-VM -Name $vmname -MemoryStartupBytes 512MB -Path $vmpath
New-VHD -Path D:\ws2012.localDCDC.vhdx -SizeBytes 60GB -Dynamic
Add-VMHardDiskDrive -VMName $vmname -Path $hddpath+$vmname+".vhdx" 
Set-VMDvdDrive -VMName $vmname -ControllerNumber 1 -Path $isospath+$isoname
Set-VMMemory -VMName $vmname -DynamicMemoryEnabled $true -StartupBytes 512MB -MinimumByte 512
Start-VM –Name $vmname
Get-VM $vmname