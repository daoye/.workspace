[CmdletBinding()]
param(
    [switch]$NoPackages,
    [switch]$NoNeovimSync
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$Root = $PSScriptRoot
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Write-Log([string]$Message) {
    Write-Host "[workspace] $Message"
}

function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

function Install-WingetPackage([string]$Id) {
    $installed = & winget.exe list --id $Id --exact --source winget --accept-source-agreements 2>$null | Out-String
    if ($LASTEXITCODE -eq 0 -and $installed -match [regex]::Escape($Id)) {
        Write-Log "already installed: $Id"
        return
    }

    Write-Log "installing package $Id"
    & winget.exe install --id $Id --exact --source winget --silent --accept-source-agreements --accept-package-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        throw "winget failed for $Id with exit code $LASTEXITCODE"
    }
}

function Backup-Path([string]$Path) {
    if (Test-Path -LiteralPath $Path) {
        $backup = "$Path.backup.$Stamp"
        Write-Log "backing up $Path -> $backup"
        Move-Item -LiteralPath $Path -Destination $backup
    }
}

function Set-DirectoryJunction([string]$Source, [string]$Target) {
    if (Test-Path -LiteralPath $Target) {
        $item = Get-Item -LiteralPath $Target -Force
        $currentTarget = @($item.Target)[0]
        if ($item.LinkType -eq 'Junction' -and $currentTarget -and
            [IO.Path]::GetFullPath($currentTarget) -eq [IO.Path]::GetFullPath($Source)) {
            Write-Log "already linked: $Target"
            return
        }
        Backup-Path $Target
    }

    New-Item -ItemType Directory -Path (Split-Path -Parent $Target) -Force | Out-Null
    New-Item -ItemType Junction -Path $Target -Target $Source | Out-Null
    Write-Log "linked $Target -> $Source"
}

function Set-ManagedFile([string]$Source, [string]$Target) {
    $content = Get-Content -LiteralPath $Source -Raw
    if ((Test-Path -LiteralPath $Target) -and (Get-Content -LiteralPath $Target -Raw) -eq $content) {
        Write-Log "already installed: $Target"
        return
    }

    Backup-Path $Target
    New-Item -ItemType Directory -Path (Split-Path -Parent $Target) -Force | Out-Null
    [IO.File]::WriteAllText($Target, $content, [Text.UTF8Encoding]::new($false))
    Write-Log "installed $Target"
}

function Install-NerdFont {
    $fontFile = 'JetBrainsMonoNerdFontMono-Regular.ttf'
    if ((Test-Path "$env:WINDIR\Fonts\$fontFile") -or
        (Test-Path "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\$fontFile")) {
        Write-Log 'JetBrainsMono Nerd Font Mono is already installed'
        return
    }

    $temp = Join-Path ([IO.Path]::GetTempPath()) "workspace-font-$([guid]::NewGuid())"
    $archive = Join-Path $temp 'JetBrainsMono.zip'
    $expanded = Join-Path $temp 'font'
    New-Item -ItemType Directory -Path $temp, $expanded -Force | Out-Null

    Write-Log 'installing JetBrainsMono Nerd Font Mono for the current user'
    Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip' -OutFile $archive
    Expand-Archive -LiteralPath $archive -DestinationPath $expanded -Force

    $destination = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
    $registry = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    New-Item -Path $registry -Force | Out-Null

    Get-ChildItem -LiteralPath $expanded -Filter 'JetBrainsMonoNerdFontMono-*.ttf' | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $destination $_.Name) -Force
        New-ItemProperty -Path $registry -Name "$($_.BaseName) (TrueType)" -Value $_.Name -PropertyType String -Force | Out-Null
    }

    Remove-Item -LiteralPath $temp -Recurse -Force
}

function Get-WindowsTerminalSettingsPath {
    $candidates = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
    )
    return $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
}

function Add-NoteProperty([object]$Object, [string]$Name, [object]$Value) {
    if ($Object.PSObject.Properties.Name -contains $Name) {
        $Object.$Name = $Value
    } else {
        $Object | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
    }
}

function Set-WindowsTerminal {
    $template = Get-Content -LiteralPath "$Root\config\windows-terminal\settings.json" -Raw | ConvertFrom-Json
    $settingsPath = Get-WindowsTerminalSettingsPath
    if (-not $settingsPath) {
        $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        New-Item -ItemType Directory -Path (Split-Path -Parent $settingsPath) -Force | Out-Null
        '{"profiles":{"defaults":{},"list":[]},"schemes":[]}' | Set-Content -LiteralPath $settingsPath -Encoding utf8
    }

    $originalJson = Get-Content -LiteralPath $settingsPath -Raw
    $settings = $originalJson | ConvertFrom-Json
    if (-not $settings.profiles) {
        Add-NoteProperty $settings 'profiles' ([pscustomobject]@{ defaults = [pscustomobject]@{}; list = @() })
    }
    if (-not $settings.profiles.defaults) {
        Add-NoteProperty $settings.profiles 'defaults' ([pscustomobject]@{})
    }
    if (-not $settings.profiles.list) {
        Add-NoteProperty $settings.profiles 'list' @()
    }
    if (-not $settings.schemes) {
        Add-NoteProperty $settings 'schemes' @()
    }

    Add-NoteProperty $settings.profiles.defaults 'font' $template.font
    Add-NoteProperty $settings.profiles.defaults 'colorScheme' $template.colorScheme

    foreach ($profile in $settings.profiles.list) {
        $profileSource = if ($profile.PSObject.Properties.Name -contains 'source') { $profile.source } else { '' }
        if ($profile.name -eq 'Arch' -or $profileSource -eq 'Microsoft.WSL') {
            Add-NoteProperty $profile 'font' $template.font
            Add-NoteProperty $profile 'colorScheme' $template.colorScheme
        }
    }

    $schemes = @($settings.schemes | Where-Object { $_.name -ne $template.scheme.name })
    $schemes += $template.scheme
    $settings.schemes = $schemes

    $json = $settings | ConvertTo-Json -Depth 100
    if ($originalJson.Trim() -eq $json.Trim()) {
        Write-Log "Windows Terminal is already configured: $settingsPath"
        return
    }

    Copy-Item -LiteralPath $settingsPath -Destination "$settingsPath.backup.$Stamp" -Force
    [IO.File]::WriteAllText($settingsPath, "$json`n", [Text.UTF8Encoding]::new($false))
    Write-Log "updated Windows Terminal: $settingsPath"
}

if (-not $NoPackages) {
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        throw 'winget is required; install App Installer from Microsoft Store'
    }

    @(
        'Git.Git',
        'Microsoft.PowerShell',
        'Microsoft.WindowsTerminal',
        'Neovim.Neovim',
        'BurntSushi.ripgrep.MSVC',
        'sharkdp.fd',
        'junegunn.fzf',
        'ajeetdsouza.zoxide',
        'Starship.Starship'
    ) | ForEach-Object { Install-WingetPackage $_ }
    Refresh-Path
}

Install-NerdFont

Set-DirectoryJunction "$Root\config\nvim" "$env:LOCALAPPDATA\nvim"
Set-ManagedFile "$Root\config\starship\starship.toml" "$HOME\.config\starship.toml"

$profileLoader = Join-Path ([IO.Path]::GetTempPath()) "workspace-profile-$([guid]::NewGuid()).ps1"
$escapedProfile = "$Root\config\powershell\profile.ps1".Replace("'", "''")
[IO.File]::WriteAllText($profileLoader, ". '$escapedProfile'`n", [Text.UTF8Encoding]::new($false))
Set-ManagedFile $profileLoader $PROFILE.CurrentUserAllHosts
Remove-Item -LiteralPath $profileLoader -Force

Set-WindowsTerminal

if (-not $NoNeovimSync) {
    if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
        throw 'nvim is not available on PATH'
    }
    Write-Log 'synchronizing Neovim plugins'
    & nvim --headless '+Lazy! sync' +qa
    if ($LASTEXITCODE -ne 0) {
        throw "Neovim plugin synchronization failed with exit code $LASTEXITCODE"
    }
}

Write-Log 'installation complete; restart Windows Terminal to load the font and profile'
