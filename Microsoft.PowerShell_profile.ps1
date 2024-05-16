
#34de4b3d-13a8-4540-b76d-b9e8d3851756 PowerToys CommandNotFound module

Import-Module "C:\Users\tobia\AppData\Local\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1" > $null 2>&1
if (-not $?) {
    Write-Host "Make sure to install WingetCommandNotFound by MS Powertoys" -ForegroundColor Yellow
}

#34de4b3d-13a8-4540-b76d-b9e8d3851756
Import-Module -Name Terminal-Icons

Write-Host ""
Write-Host "Welcome Tobias ⚡" -ForegroundColor DarkCyan
Write-Host ""


#All Colors: Black, Blue, Cyan, DarkBlue, DarkCyan, DarkGray, DarkGreen, DarkMagenta, DarkRed, DarkYellow, Gray, Green, Magenta, Red, White, Yellow.

# Initial GitHub.com connectivity check with 1 second timeout
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

# Import Modules and External Profiles
# Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons


function Update-PowerShell {
    if (-not $global:canConnectToGitHub) {
        Write-Host "Skipping PowerShell update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
        return
    }
    try {
        $updateNeeded = $false
        $currentVersion = $PSVersionTable.PSVersion.ToString()
        $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
        $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
        if ($currentVersion -lt $latestVersion) {
            $updateNeeded = $true
        }

        if ($updateNeeded) {
            Write-Host "Updating PowerShell..." -ForegroundColor Yellow
            winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements
            Write-Host "PowerShell has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
        } else {
            Write-Host "Your PowerShell is up to date." -ForegroundColor Green
        }
    } catch {
        Write-Error "Failed to update PowerShell. Error: $_"
    }
}
Update-PowerShell

function gitpush {
    git pull
    git add .
    git commit -m "$args"
    git push
}

function ssh-copy-key {
    param(
        [parameter(Position=0)]
        [string]$user,

        [parameter(Position=1)]
        [string]$ip
    )

    $pubKeyPath = "~\.ssh\id_ed25519.pub"
    $sshCommand = "cat $pubKeyPath | ssh $user@$ip 'cat >> ~/.ssh/authorized_keys'"
    Invoke-Expression $sshCommand
}

function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}

function df {
    get-volume
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    Get-Process $name
}

function head {
    param($Path, $n = 10)
    Get-Content $Path -Head $n
}

function tail {
    param($Path, $n = 10)
    Get-Content $Path -Tail $n
}


$WastebinServerUrl = "https://bin.crazywolf.dev"
$DefaultExpirationTime = 3600  # Default expiration time: 1 hour (in seconds)
$DefaultBurnAfterReading = $false  # Default value for burn after reading setting

function ptw {
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [string]$FilePath,
        
        [Parameter(Position=1)]
        [int]$ExpirationTime = $DefaultExpirationTime,
        
        [Parameter(Position=2)]
        [bool]$BurnAfterReading = $DefaultBurnAfterReading
    )

    process {
        if (-not $FilePath) {
            Write-Host "File path not provided."
            return
        }
        
        if (-not (Test-Path $FilePath)) {
            Write-Host "File '$FilePath' not found."
            return
        }

        try {
            $FileContent = Get-Content -Path $FilePath -Raw
            
            $Payload = @{
                text = $FileContent
                extension = $null
                expires = $ExpirationTime
                burn_after_reading = $BurnAfterReading
            } | ConvertTo-Json

            $Response = Invoke-RestMethod -Uri $WastebinServerUrl -Method Post -Body $Payload -ContentType 'application/json'
            $Path = $Response.path -replace '\.\w+$'

            Write-Host ""
            Write-Host "$WastebinServerUrl$Path"
        }
        catch {
            Write-Host "Error occurred: $_"
        }
    }
}


function pptw {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string]$InputContent,
        [int]$ExpirationTime = $DefaultExpirationTime,
        [bool]$BurnAfterReading = $DefaultBurnAfterReading
    )
    begin {
        $AllInputContent = @()  # Array to store all lines of input
    }
    process {
        $AllInputContent += $InputContent  # Add each line to the array
    }

    end {
        try {
            # Concatenate all lines into a single string
            $CombinedInput = $AllInputContent -join "`r`n"

            $Payload = @{
                text = $CombinedInput
                extension = $null
                expires = $ExpirationTime
                burn_after_reading = $BurnAfterReading
            } | ConvertTo-Json

            $Response = Invoke-RestMethod -Uri $WastebinServerUrl -Method Post -Body $Payload -ContentType 'application/json'
            $Path = $Response.path -replace '\.\w+$'

            Write-Host ""
            Write-Host "$WastebinServerUrl$Path"
        }
        catch {
            Write-Host "Error occurred: $_"
        }
    }
}


# If so and the current host is a command line, then change to red color 
# as warning to user that they are operating in an elevated context
# Useful shortcuts for traversing directories
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# Compute file hashes - useful for checking successful downloads 
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepad
function n { notepad $args }
function vs { code $args }
function expl { explorer . }

# Set up command prompt and window title. Use UNIX-style convention for identifying 
# whether user is elevated (root) or not. Window title shows current version of PowerShell
# and appends [ADMIN] if appropriate for easy taskbar identification
function prompt { 
    if ($isAdmin) {
        "[" + (Get-Location) + "] # " 
    } else {
        "[" + (Get-Location) + "] $ "
    }
}

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    } else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Simple function to start a new elevated process. If arguments are supplied then 
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin {
    if ($args.Count -gt 0) {   
        $argList = "& '" + $args + "'"
        Start-Process "wt.exe" -Verb runAs -ArgumentList $argList
    } else {
        Start-Process "wt.exe" -Verb runAs
    }
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command
# with elevated rights. 
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Host "$command does not exist"; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
} 
#
# Aliases
#
# If your favorite editor is not here, add an elseif and ensure that the directory it is installed in exists in your $env:Path
#
if (Test-CommandExists code) {
    $EDITOR='code'
}  elseif (Test-CommandExists notepad) {
    $EDITOR='notepad++'
} elseif (Test-CommandExists notepad++) {
    $EDITOR='notepad'
} 
Set-Alias -Name vim -Value $EDITOR


function ll { Get-ChildItem -Path $pwd -File }

# Network Utilities
function Get-PubIP { (Invoke-WebRequest http://ifconfig.me/ip).Content }

# System Utilities
function uptime {
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        Get-WmiObject win32_operatingsystem | Select-Object @{Name='LastBootUpTime'; Expression={$_.ConverttoDateTime($_.lastbootuptime)}} | Format-Table -HideTableHeaders
    } else {
        net statistics workstation | Select-String "since" | ForEach-Object { $_.ToString().Replace('Statistics since ', '') }
    }
}



function unzip ($file) {
    $fullPath = Join-Path -Path $pwd -ChildPath $file
    if (Test-Path $fullPath) {
        Write-Output "Extracting $file to $pwd"
        Expand-Archive -Path $fullPath -DestinationPath $pwd
    } else {
        Write-Output "File $file does not exist in the current directory"
    }
}

function sync-profile {
    clear-host
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | ForEach-Object {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }
}
Set-Alias -Name reload -Value sync-profile

# Function to reboot the system
function Reboot-System {
    Restart-Computer -Force
}

# Function to power off the system
function Poweroff-System {
    Stop-Computer -Force
}

# Aliases for reboot and poweroff
Set-Alias reboot Reboot-System
Set-Alias poweroff Poweroff-System

function cdgit {
    Set-Location 'G:\Informatik\Projekte'
}

# --------------------------------------
# School

function ssh-m122 {
    ssh -i ~\.ssh\06-student.pem -o ServerAliveInterval=30 ubuntu@52.3.134.38
}
function cdtbz {
    Set-Location 'C:\Users\tobia\OneDrive - Halter AG\Dokumente\Daten\TBZ'
}
function cdbmz {
    Set-Location 'C:\Users\tobia\OneDrive - Halter AG\Dokumente\Daten\BMZ'
}
function cdhalter {
    Set-Location 'C:\Users\tobia\OneDrive - Halter AG\Dokumente\Daten\Halter'
}


oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/montys.omp.json' | Invoke-Expression
