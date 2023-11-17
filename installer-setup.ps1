# set environmental variables
Write-Output "set-Alias -Name hpe -Value $INSTALLLOC\hpe.ps1" >> $PROFILE

# Setup VM Name dynamically

#install vcxsrv

# Add profile to windows terminal
# $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
# Define the new profile
$newProfile = @{
    "commandline" = "powershell.exe -command `"ssh -Y username@`$env:KaliHyperVAddr`""
    "elevate" = $false
    "hidden" = $false
    "name" = "Kali"
}

# Convert the profile to a JSON string
$newProfileJson = $newProfile | ConvertTo-Json -Depth 100

# Get the path to the Windows Terminal settings file
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Load the current settings
$settings = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json -Depth 100

# Add the new profile to the list of profiles
$settings.profiles.list += $newProfileJson | ConvertFrom-Json -Depth 100

# Save the updated settings
$settings | ConvertTo-Json -Depth 100 | Set-Content -Path $settingsPath
