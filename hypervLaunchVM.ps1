$vmname = "kali"
$vmpath = "C:\VMs\"+$vmname+"\"
$hddpath = $vmpath+"hdds\"
$isospath = "C:\VMs\isos\"
$isoname = "kali-linux-2021-W31-installer-amd64.iso"
$vhdpath = $hddpath+$vmname+".vhdx"

New-VM -Name $vmname -MemoryStartupBytes 512MB -Path $vmpath
New-VHD -Path $vhdpath -SizeBytes 60GB -Dynamic
Add-VMHardDiskDrive -VMName $vmname -Path $vhdpath
Set-VMDvdDrive -VMName $vmname -ControllerNumber 1 -Path $isospath$isoname
Set-VMMemory -VMName $vmname -DynamicMemoryEnabled $true -StartupBytes 12GB
Start-VM –Name $vmname
Get-VM $vmname