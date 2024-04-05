$commonPackages = (Get-ToolsetContent).choco.common_packages

choco install kb2919355 -y
choco install kb2999226 -y

foreach ($package in $commonPackages)
{
    Choco-Install -PackageName $package.name -ArgumentList $package.args
}

Invoke-PesterTests -TestFile "ChocoPackages"