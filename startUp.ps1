# Get Admin Access
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
	Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition)) -WindowStyle Hidden
	exit $LASTEXITCODE
}

# start VM
Start-VM kali-linux

# Start Vcxsrv with Vsock
& 'C:\Program Files\VcXsrv\vcxsrv.exe' :0 -vmid '{0c67e76b-97dd-43e4-8e2b-3bc633c465e4}' -vsockport 6000 -multiwindow -dpi 150
# use socat for port forwarding on the vm
# socat -b65536 UNIX-LISTEN:/tmp/.X11-unix/X0,fork,mode=777 vsock-connect:2:6000 &; export DISPLAY=:0.0

# wait for bootup
do {
	# extract the IP address and store it in a user environment variable
	$output = get-vm -Name kali-linux | Select-Object -ExpandProperty networkadapters | Select-Object ipaddresses
	$output = $output.IPAddresses[0]

} until ($null -ne $output -and $output -match '^(?:(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}(?:0?0?\d|0?[1-9]\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$')

# set the user env var
[System.Environment]::SetEnvironmentVariable('KaliHyperVAddr', $output, [System.EnvironmentVariableTarget]::User)