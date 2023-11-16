# Get Admin Access
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition)) -WindowStyle Hidden
exit $LASTEXITCODE
}

# start VM
Start-VM  kali-linux

# Start Xming
& 'C:\Program Files\VcXsrv\vcxsrv.exe' -multiwindow -dpi 150

# wait for bootup
do {
	start-sleep -s 3

	# extract the IP address and store it in a user environment variable
	$output = get-vm -Name kali-linux | select -ExpandProperty networkadapters | select ipaddresses
	$output = $output.IPAddresses[0]
} until ($null -ne $output)

# set the user env var
[System.Environment]::SetEnvironmentVariable('KaliHyperVAddr',$output,[System.EnvironmentVariableTarget]::User)