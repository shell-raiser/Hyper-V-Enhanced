. .\getVMStatus.ps1
if ($args[0] -eq '--shutdown') {

    & $PSScriptRoot\shutdown.ps1

    # block terminal until operation is completed fully
    do {
        Start-Sleep -Seconds 1
    } until (
        $null -eq [System.Environment]::GetEnvironmentVariable('KaliHyperVAddr', 'User')
    )
}
elseif ($args.Length -eq 0) {
    # check if vm already booted
    if (($null -eq [System.Environment]::GetEnvironmentVariable('KaliHyperVAddr', 'User')) -and (Get-VMStatus -eq $true) ) {
        & $PSScriptRoot\startUp.ps1
        # block terminal until operation is completed fully
        do {
            Start-Sleep -Seconds 1
        } until (
            $null -ne [System.Environment]::GetEnvironmentVariable('KaliHyperVAddr', 'User')
        )
    }
    # ssh into machine
    $ip = [System.Environment]::GetEnvironmentVariable('KaliHyperVAddr', 'User')
    ssh kss@$ip
}


start-sleep -Seconds 3
