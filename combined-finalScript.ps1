$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" '+$args+ ' -elevated' -f ($myinvocation.MyCommand.Definition))
}

if ($args[0] -eq '--shutdown') {
    # shutdown vm
    Stop-VM -Name kali-linux

    # Kill Xming, in this case vcxrv
    Get-process vcxsrv | Stop-Process
}
elseif ($args.Length -eq 0) {
    # start VM
    Start-VM  kali-linux

    # Start Xming
    & 'C:\Program Files\VcXsrv\vcxsrv.exe' -multiwindow -dpi 150

    # wait for bootup
    do {
        start-sleep -s 3

        # extract the IP address and store it in a user environment variable
        $output = get-vm -Name kali-linux | Select-Object -ExpandProperty networkadapters | Select-Object ipaddresses
        $output = $output.IPAddresses[0]
    } until ($null -ne $output)

    # set the user env var
    [System.Environment]::SetEnvironmentVariable('KaliHyperVAddr', $output, [System.EnvironmentVariableTarget]::User)
}