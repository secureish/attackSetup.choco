$vmname = "cli1"
$vmpath = "C:\VMs\"+$vmname+"\"
$hddpath = $vmpath+"hdds\"
$isospath = "C:\VMs\isos\"
$isoname = "19043.928.210409-1212.21h1_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-gb.iso"
$vhdpath = $hddpath+$vmname+".vhdx"

New-VM -Name $vmname -MemoryStartupBytes 8GB -Path $vmpath
New-VHD -Path $vhdpath -SizeBytes 45GB -Dynamic
Add-VMHardDiskDrive -VMName $vmname -Path $vhdpath
Set-VMDvdDrive -VMName $vmname -ControllerNumber 1 -Path $isospath$isoname
Set-VMMemory -VMName $vmname -DynamicMemoryEnabled $true -StartupBytes 8GB
Add-VMNetworkAdapter -VMName $vmname -Name "ExtSwitch"
Start-VM -Name $vmname
Get-VM $vmname
