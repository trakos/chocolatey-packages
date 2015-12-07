$packageName = 'intellitype'
$installerType = 'msi'
$32BitUrl = 'http://download.microsoft.com/download/8/2/5/82583391-DABD-4392-9219-1C249BAD2BDD/ITPx86_1033_8.20.469.0.exe'
$64BitUrl = 'http://download.microsoft.com/download/9/4/B/94B55335-FAC0-4A99-A038-5FE1C2F5CF09/ITPx64_1033_8.20.469.0.exe'
$silentArgs = 'BUNDLE=1 REBOOT=ReallySuppress INSTALLGUID="{8979881A-8E43-467f-B387-E37B914A0E53}"'
$validExitCodes = @(0)

$tempSetupDir = Join-Path $env:TEMP -ChildPath "chocolatey" | Join-Path -ChildPath "$packageName"
if ($env:packageVersion -ne $null) {$tempSetupDir = Join-Path $tempSetupDir "$env:packageVersion"; }
if (![System.IO.Directory]::Exists($tempSetupDir)) {[System.IO.Directory]::CreateDirectory($tempSetupDir)}
$fileFullPath = Join-Path $tempSetupDir "$($packageName)Install.exe"

# determine where the real msi installer (itp.exe) will land 
$setupSubDir = "setup"
if (Get-ProcessorBits 64) {
  $setupSubDir = "setup64"
}
$setupFile = Join-Path $tempSetupDir -ChildPath "itype" | Join-Path -ChildPath $setupSubDir | Join-Path -ChildPath "itp.msi"

echo "Downloading installer to $fileFullPath..."
Get-ChocolateyWebFile $packageName $fileFullPath $32BitUrl $64BitUrl
echo "Extracting $fileFullPath..."
Get-ChocolateyUnzip $fileFullPath $tempSetupDir
echo "Installing from $setupFile..."
Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" "$setupFile" -validExitCodes $validExitCodes
# clean up is probably not worth risking breaking stuff:
# Remove-Item -Recurse -Force $tempSetupDir

# @todo: check if prereq/msxml and prereq/watson are needed