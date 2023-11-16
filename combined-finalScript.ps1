if ($args[0] -eq '--shutdown') {
    & .\shutdown.ps1
}
elseif ($args.Length -eq 0) {
    & .\startUp.ps1
}