$vmname = "cli1"
$vmpath = "C:\VMs\"+$vmname+"\"
$hddpath = $vmpath+"hdds\"
$isospath = "C:\VMs\isos\"
$isoname = "Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO"
$vhdpath = $hddpath+$vmname+".vhdx"

New-VM -Name $vmname -MemoryStartupBytes 512MB -Path $vmpath
New-VHD -Path $vhdpath -SizeBytes 40GB -Dynamic
Add-VMHardDiskDrive -VMName $vmname -Path $vhdpath
Set-VMDvdDrive -VMName $vmname -ControllerNumber 1 -Path $isospath$isoname
Set-VMMemory -VMName $vmname -DynamicMemoryEnabled $true -StartupBytes 8GB
Start-VM -Name $vmname
Get-VM $vmname
