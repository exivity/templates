######################################
### Exivity Self Update/Deployment ###
######################################

Write-Host ' ____  _  _  __  _  _  __  ____  _  _ ' -ForegroundColor Cyan -BackgroundColor Black
Write-Host '(  __)( \/ )(  )/ )( \(  )(_  _)( \/ )' -ForegroundColor Cyan -BackgroundColor Black
Write-Host ' ) _)  )  (  )( \ \/ / )(   )(   )  / ' -ForegroundColor Cyan -BackgroundColor Black
Write-Host '(____)(_/\_)(__) \__/ (__) (__) (__/  ' -ForegroundColor Cyan -BackgroundColor Black

## Dependencies
# Internet Access to "https://dex.exivity.com/dex.exe"


## Config
$baseDirectory = 'C:\Exivity'
$baseURL = 'https://dex.exivity.com/dex.exe'
$password = "Password"


## Start Transscript
Start-Transcript -Path "$baseDirectory\AutoInstall.log"
Write-Host "Started writing output to $baseDirectory\AutoInstall.log"
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Reset TaskScheduler
Write-Host "Removing Scheduled Task named InstallExivity" -ForegroundColor Yellow -BackgroundColor Black
Unregister-ScheduledTask -TaskName InstallExivity -Confirm:$false
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## NuGet Provider
Write-Host "Installing NuGet Provider for package installation" -ForegroundColor DarkYellow -BackgroundColor Black
Install-PackageProvider -Name NuGet -Force
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Trust PSGallery
Write-Host "Allowing module install from PSGallery" -ForegroundColor DarkYellow -BackgroundColor Black
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Execution Policy
Write-Host "Unrestrict access for application installation" -ForegroundColor Yellow -BackgroundColor Black
$execPolicyLM = Get-ExecutionPolicy -Scope LocalMachine
$execPolicyCU = Get-ExecutionPolicy -Scope CurrentUser
if ($execPolicyLM -ne 'Unrestricted')
{
    Write-Host "Setting the ExecutionPolicy to Unrestricted for LocalMachine" -ForegroundColor DarkYellow -BackgroundColor Black
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
}
if ($execPolicyCU -ne 'Unrestricted')
{
    Write-Host "Setting the ExecutionPolicy to Unrestricted for CurrentUser" -ForegroundColor DarkYellow -BackgroundColor Black
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
}
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Folder
Write-Host "Creating Download Folder" -ForegroundColor Yellow -BackgroundColor Black
$downloadDirectory = "$baseDirectory\Dex"
New-Item -ItemType directory -Path $downloadDirectory
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Download
Write-Host "Downloading Dex Installer from https://dex.exivity.com/dex.exe" -ForegroundColor Yellow -BackgroundColor Black
$downloadFile = "$downloadDirectory\dex.exe"
Invoke-WebRequest -Uri $baseURL -OutFile $downloadFile
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Add PATH
Write-Host "Adding Dex Directory to PATH" -ForegroundColor Yellow -BackgroundColor Black
$env:Path += $downloadDirectory
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Install Exivity
Write-Host "Installing Exivity using Dex" -ForegroundColor Green -BackgroundColor Black
.$downloadFile install --program "$baseDirectory/program" --home "$baseDirectory/home" --username admin --password $password --start
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Configure RDP
Write-Host "Allowing RDP to the server" -ForegroundColor Yellow -BackgroundColor Black
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Configure Firewall
Write-Host "Configuring Local Firewall for Exivity service" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black

# Inbound
Write-Host "Configuring Inbound Rules" -ForegroundColor DarkYellow -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
New-NetFirewallRule -DisplayName 'Exivity' -Profile Domain -Direction Inbound -Action Allow -Protocol TCP -LocalPort 443
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
New-NetFirewallRule -DisplayName 'Exivity' -Profile Private -Direction Inbound -Action Allow -Protocol TCP -LocalPort 443
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
New-NetFirewallRule -DisplayName 'Exivity' -Profile Public -Direction Inbound -Action Allow -Protocol TCP -LocalPort 443
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black

# Outbound
Write-Host "Configuring Outbound Rules" -ForegroundColor DarkYellow -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
New-NetFirewallRule -DisplayName 'Exivity' -Profile Domain -Direction Outbound -Action Allow -Protocol TCP -LocalPort 443
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
New-NetFirewallRule -DisplayName 'Exivity' -Profile Private -Direction Outbound -Action Allow -Protocol TCP -LocalPort 443
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
New-NetFirewallRule -DisplayName 'Exivity' -Profile Public -Direction Outbound -Action Allow -Protocol TCP -LocalPort 443
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black

# RDP
Write-Host "Configuring RDP Rule" -ForegroundColor DarkYellow -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Cleanup
Write-Host "Removing self deploy script" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
Remove-Item -LiteralPath $MyInvocation.MyCommand.Path -Force
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Done
Write-Host "Welcome to Exivity!" -ForegroundColor Cyan -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black


## Windows Updates
Write-Host "Updating Windows to latest version" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black

# Install PSWindowsUpdate
Write-Host "Installing Powershell Module PSWindowsUpdate" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
Install-Module -Name PSWindowsUpdate
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black

# Update Windows
Write-Host "Installing Windows Updates" -ForegroundColor Green -BackgroundColor Black
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
Write-Host "**********************" -ForegroundColor Cyan -BackgroundColor Black
