# Contents
- [Contents](#contents)
- [PowerShell Config](#powershell-config)
- [OhMyPosh Config](#ohmyposh-config)



# PowerShell Config
```
$url = "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/Microsoft.PowerShell_profile.ps1?token=GHSAT0AAAAAACMVU6LRVMCJ2XAVAQSNS4JGZOD66OQ"

$profileScript = Invoke-WebRequest -Uri $url | Select-Object -ExpandProperty Content

# Execute the profile script
Invoke-Expression $profileScript
```
# OhMyPosh Config
