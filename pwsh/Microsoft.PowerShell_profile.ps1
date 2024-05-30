Write-Host ""
Write-Host "Welcome Tobias ⚡" -ForegroundColor DarkCyan
Write-Host ""

#All Colors: Black, Blue, Cyan, DarkBlue, DarkCyan, DarkGray, DarkGreen, DarkMagenta, DarkRed, DarkYellow, Gray, Green, Magenta, Red, White, Yellow.

# Check Internet and exit if it takes longer than 1 second
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1
$configPath = "$HOME\pwsh_custom_config.yml"

function Initialize-DevEnv {
    if (-not $global:canConnectToGitHub) {
        Write-Host "❌ Skipping Dev Environment Initialization due to GitHub.com not responding within 1 second." -ForegroundColor Red
        return
    }
    $modules = @(
        @{ Name = "Terminal-Icons"; ConfigKey = "Terminal-Icons_installed" },
        @{ Name = "Powershell-Yaml"; ConfigKey = "Powershell-Yaml_installed" },
        @{ Name = "PoshFunctions"; ConfigKey = "PoshFunctions_installed" }
    )
    foreach ($module in $modules) {
        $isInstalled = Get-ConfigValue -Key $module.ConfigKey
        if ($isInstalled -ne "True") {
            Write-Host "Initializing $($module.Name) module..."
            Initialize-Module $module.Name
        } else {
            Import-Module $module.Name
            Write-Host "✅ $($module.Name) module is already installed." -ForegroundColor Green
        }
    }
    if ($vscode_installed -ne "True") { 
        Write-Host "⚡ Invoking Helper-Script" -ForegroundColor Yellow
        . Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/pwsh_helper.ps1" -UseBasicParsing).Content
        Test-vscode 
    }
    if ($ohmyposh_installed -ne "True") { 
        Write-Host "⚡ Invoking Helper-Script" -ForegroundColor Yellow
        . Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/pwsh_helper.ps1" -UseBasicParsing).Content
        Test-ohmyposh 
        }
    if ($FiraCode_installed -ne "True") {
        Write-Host "⚡ Invoking Helper-Script" -ForegroundColor Yellow
        . Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/pwsh_helper.ps1" -UseBasicParsing).Content
        Test-firacode 
        }
    
    Write-Host "✅ Successfully initialized Pwsh with all Modules and applications" -ForegroundColor Green
}

# Function to create config file
function Install-Config {
    if (-not (Test-Path -Path $configPath)) {
        New-Item -ItemType File -Path $configPath | Out-Null
        Write-Host "Configuration file created at $configPath ❗" -ForegroundColor Yellow
    } else {
        Write-Host "✅ Successfully loaded Config file" -ForegroundColor Green
    }
    Initialize-Keys
    Initialize-DevEnv
}

# Function to set a value in the config file
function Set-ConfigValue {
    param (
        [string]$Key,
        [string]$Value
    )
    $config = @{}

    # Try to load the existing config file content
    if (Test-Path -Path $configPath) {
        $content = Get-Content $configPath -Raw
        if (-not [string]::IsNullOrEmpty($content)) {
            $config = $content | ConvertFrom-Yaml
        }
    }

    # Ensure $config is a hashtable
    if (-not $config) {
        $config = @{}
    }

    $config[$Key] = $Value
    $config | ConvertTo-Yaml | Set-Content $configPath
    # Write-Host "Set '$Key' to '$Value' in configuration file." -ForegroundColor Green
    Initialize-Keys
}

# Function to get a value from the config file
function Get-ConfigValue {
    param (
        [string]$Key
    )
    $config = @{}
    # Try to load the existing config file content
    if (Test-Path -Path $configPath) {
        $content = Get-Content $configPath -Raw
        if (-not [string]::IsNullOrEmpty($content)) {
            $config = $content | ConvertFrom-Yaml
        }
    }
    # Ensure $config is a hashtable
    if (-not $config) {
        $config = @{}
    }
    return $config[$Key]
}

function Initialize-Module {
    param (
        [string]$moduleName
    )
    if ($global:canConnectToGitHub) {
        try {
            Install-Module -Name $moduleName -Scope CurrentUser -SkipPublisherCheck
            Set-ConfigValue -Key "${moduleName}_installed" -Value "True"
        } catch {
            Write-Error "❌ Failed to install module ${moduleName}: $_"
        }
    } else {
        Write-Host "❌ Skipping Module Initialization check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
    }
}

function Initialize-Keys {
    $keys = "Terminal-Icons_installed", "Powershell-Yaml_installed", "PoshFunctions_installed", "FiraCode_installed", "vscode_installed", "ohmyposh_installed"
    foreach ($key in $keys) {
        $value = Get-ConfigValue -Key $key
        Set-Variable -Name $key -Value $value -Scope Global
    }
}

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Host "$command does not exist"; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
} 

# Source my custom functions
. Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/custom_functions.ps1" -UseBasicParsing).Content
. Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/functions.ps1" -UseBasicParsing).Content



# TEMP:
#Update all my Configs to the new subfolder:
Set-Content -Path $PROFILE -Value 'iex (iwr "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/Microsoft.PowerShell_profile.ps1").Content'


# -------------
# Run section

Install-Config
# Update PowerShell in the background
Start-Job -ScriptBlock {
    Write-Host "⚡ Invoking Helper-Script" -ForegroundColor Yellow
    . Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/pwsh_helper.ps1" -UseBasicParsing).Content
    Update-PowerShell 
} > $null 2>&1
# Try to import MS PowerToys WinGetCommandNotFound
Import-Module -Name Microsoft.WinGet.CommandNotFound > $null 2>&1
if (-not $?) { Write-Host "💭 Make sure to install WingetCommandNotFound by MS Powertoys" -ForegroundColor Yellow }

# Create profile if not exists
if (-not (Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE | Out-Null
    Add-Content -Path $PROFILE -Value 'iex (iwr "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/Microsoft.PowerShell_profile.ps1").Content'
    Write-Host "PowerShell profile created at $PROFILE." -ForegroundColor Yellow
}
# Inject OhMyPosh
oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/pwsh/montys.omp.json' | Invoke-Expression
