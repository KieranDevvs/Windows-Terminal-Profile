winget install Microsoft.WindowsTerminal --accept-source-agreements
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-source-agreements
winget install Microsoft.PowerShell -s winget --accept-source-agreements

if (!(Test-Path $profile))
{
   New-Item -Type File -Force $profile
   Write-Host "Created ps profile..."
}

$profileContent = '& ([ScriptBlock]::Create((oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\microverse-power.omp.json --print) -join "`n"))'
$profileContent | Out-File -FilePath $profile

$SourceDir   = ".\fonts"
$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)

Get-ChildItem -Path $SourceDir -Include '*.ttf','*.ttc','*.otf' -Recurse | ForEach {
	# Install font
	$Destination.CopyHere($_.FullName,0x10)
}

$winTerminalSettings = "$($env:LOCALAPPDATA)\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (!(Test-Path $winTerminalSettings))
{
   New-Item -Type File -Force $winTerminalSettings
   Write-Host "Created Windows Terminal local state folder..."
}

Copy-Item ".\settings.json" -Destination $winTerminalSettings