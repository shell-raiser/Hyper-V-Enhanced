# get admin access
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition)) -WindowStyle Hidden
exit $LASTEXITCODE
}

# shutdown vm
Stop-VM -Name kali-linux

# Kill Xming, in this case vcxrv
Get-process vcxsrv | Stop-Process