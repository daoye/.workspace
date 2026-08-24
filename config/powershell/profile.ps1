$localBin = Join-Path $HOME '.local\bin'
if (Test-Path $localBin) {
    $env:Path = "$localBin;$env:Path"
}

$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim -Scope Global
    Set-Alias -Name vi -Value nvim -Scope Global
}

if (Get-Module -ListAvailable PSReadLine) {
    Set-PSReadLineOption -EditMode Windows
    if (-not [Console]::IsOutputRedirected) {
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue
    }
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init powershell | Out-String)
}

if (-not [Console]::IsOutputRedirected -and (Get-Command starship -ErrorAction SilentlyContinue)) {
    Invoke-Expression (& starship init powershell | Out-String)
}

if ($env:OS -eq 'Windows_NT' -and (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    function global:tc { wsl.exe -d Arch -- zsh -lic tc }
    function global:tcx { wsl.exe -d Arch -- zsh -lic tcx }
}
