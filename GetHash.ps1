# Function to restart the script as Administrator if not already running with elevated privileges
function Run-AsAdmin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Output "Restarting script as Administrator..."
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        Exit
    }
}

# Call the function to check for admin privileges
Run-AsAdmin

# This script requires the Microsoft-Windows-Deployment-Diagnostics PowerShell module
# Check if the required module is available
if (!(Get-Module -ListAvailable -Name "WindowsAutoPilotIntune")) {
    Install-Module -Name WindowsAutoPilotIntune -Force -Scope CurrentUser
}

# Import the module
Import-Module WindowsAutoPilotIntune

# Get the device hash
$deviceHash = Get-WindowsAutoPilotInfo

# Export the device hash to a CSV file (optional)
$deviceHash | Export-Csv -Path "$env:USERPROFILE\Desktop\DeviceHash.csv" -NoTypeInformation

Write-Output "Device hash collected. You can find it at $env:USERPROFILE\Desktop\DeviceHash.csv"
