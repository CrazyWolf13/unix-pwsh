# Contents
- [Contents](#contents)
- [Command to inject Profile](#command-to-inject-profile)
- [Systems with Scripts Disabled](#on-systems-with-scripts-disabled)
- [Windows Terminal Config Files](#windows-terminal-config-files)
- [Terminal-Icons](#terminal-icons)



# Command to inject Profile
```
iex (iwr "https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/Microsoft.PowerShell_profile.ps1").Content

```
Open the $PROFILE with `code $profile`.

# On Systems with Scripts disabled

Add the folllowing Code into Windows Terminal Command Line field of a new profile:

```
powershell -NoExit -Command "function cdtbz {cd 'C:\Users\MTO\OneDrive - Halter AG\Dokumente\Daten\TBZ'}" ; "function cdbmz {cd 'C:\Users\MTO\OneDrive - Halter AG\Dokumente\Daten\BMZ'}" ; "function cdhalter {cd 'C:\Users\MTO\OneDrive - Halter AG\Dokumente\Daten\Halter'}"  ; "function reboot {shutdown -r -t 0}"  ; "function gitpush {param([string]$commitMessage) git pull; git add .; git commit -m "$($commitMessage)"; git push}" ; function touch { param([string]$file); New-Item $file -ItemType File -Force }
 ; "oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/CrazyWolf13/home-configs/main/montys.omp.json' | Invoke-Expression" 

```
#Terminal-Icons
To get Terminal-Icons working use the following Command:
`install-module terminal-icons`

# Windows Terminal Config Files

Paste the Files inside [windows-terminal](./wt/) into the folder: <br>
`C:\Users\{user}\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState` .
