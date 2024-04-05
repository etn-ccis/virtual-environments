################################################################################
##  File:  Install-Mingw64.ps1
##  Desc:  Install GNU tools for Windows
################################################################################

$toolsetVersion = (Get-ToolsetContent).mingw.version
Choco-Install -PackageName mingw -ArgumentList "--version=$toolsetVersion"

# Make a copy of mingw32-make.exe to make.exe, which is a more discoverable name
# and so the same command line can be used on Windows as on macOS and Linux
# $path = "C:\$_\bin\mingw32-make.exe" | Get-Item
$path = where.exe mingw32-make.exe | Get-Item
foreach ($path in $path) {
    Copy-Item -Path $path -Destination (Join-Path $path.Directory 'make.exe')
}

Invoke-PesterTests -TestFile "Tools" -TestName "Mingw64"
