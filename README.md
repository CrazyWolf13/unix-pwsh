# Contents
- [Contents](#contents)
- [Personal PowerShell Configuration 🖥️](#personal-powershell-configuration-️)
  - [Features 🌟](#features-)
  - [Components Installed 🛠️](#components-installed-️)
  - [Configuration 📁](#configuration-)
  - [Usage 🚀](#usage-)
  - [Contributing 🤝](#contributing-)
  - [Personalization 🎨](#personalization-)


# Personal PowerShell Configuration 🖥️

This repository contains a collection of PowerShell scripts tailored to enhance the command-line experience on Windows systems. 
Developed for personal use, feel free to use, fork, and customize this as you like. 🚀
Note: Loading this profile may take 2-4 seconds, in the future, support for local cache will be implemented.
This repo also contains some other personal assets, like my windows-terminal config, some linux scripts, for my personal use only.

## Features 🌟
- **Bash-like Shell Experience**: Mimics Unix shell functionality, bringing familiarity to Windows PowerShell. 🐧
- **Oh My Posh Integration**: Enhances the user interface with stylish prompts and Git status indicators. ⚡
- **Deferred Loading**: Improves function loading time for a smoother experience. 🕒
- **Automatic Installation**: The scripts automatically install necessary modules and components on first execution. 🛠️

## Components Installed 🛠️
- **Terminal-Icons Module**: Enhances terminal UI with icons. 🎨
- **Powershell-Yaml**: Facilitates configuration with a YAML file, saving time. 📝
- **PoshFunctions**: Essential functions for PowerShell. ⚙️
- **FiraCode Nerd Font**: Installs a stylish font for code readability. 🅰️
- **Oh My Posh**: Provides customizable prompt themes. 🎨

## Configuration 📁
- The configuration file is located at: `~/pwsh_custom_config.yml`. This file stores all the configuration variables, facilitating faster loading by eliminating the need to check for installed elements every time.

- All configurable options, including module installation preferences and feature toggles, are centralized within this YAML file. This centralized approach streamlines the initialization process, ensuring a quicker and more efficient startup experience. 🚀

## Usage 🚀
- To activate this configuration:
  1. Paste in this command: `iex (iwr "https://raw.githubusercontent.com/CrazyWolf13/home-configs/pwsh/main/Microsoft.PowerShell_profile.ps1").Content`.
  2. The PowerShell profile is automatically created and the profile injected into, if it does not exist. If it exists, manually place the snippet provided above at the top of the PowerShell profile.
  3. Edit the profile easily by typing `notepad $PROFILE` into PowerShell. 🛠️
- Make sure to point Windows Terminal to `pwsh` instead of `powershell`, as `pwsh` is the open-sourced 7.x.x version of PowerShell (PowerShell Core). 🔄
- Enjoy the enhanced PowerShell experience! 🎉

## Contributing 🤝
- Feel free to fork, modify, and contribute improvements or additional features.
- For any issues, questions, or help, please create an issue in the repository. 💬

## Personalization 🎨
- Customize the scripts according to personal preferences or specific system requirements.
- To use a forked version, update the `githubUser` variable to point to your own forked repository.

---

*Developed by CrazyWolf13 with ❤️*