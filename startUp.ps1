# Get Admin Access
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
	Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition)) -WindowStyle Hidden
	exit $LASTEXITCODE
}

# start VM
Start-VM kali-linux

# Start Xming
& 'C:\Program Files\VcXsrv\vcxsrv.exe' -multiwindow -dpi 150

# wait for bootup
do {
	# extract the IP address and store it in a user environment variable
	$output = get-vm -Name kali-linux | Select-Object -ExpandProperty networkadapters | Select-Object ipaddresses
	$output = $output.IPAddresses[0]

} until ($null -ne $output -and $output -match '^(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$')

# set the user env var
[System.Environment]::SetEnvironmentVariable('KaliHyperVAddr', $output, [System.EnvironmentVariableTarget]::User)