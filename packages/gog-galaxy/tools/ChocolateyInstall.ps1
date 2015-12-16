
$packageName = 'gog-galaxy'
$installerType = 'exe'
$32BitUrl = 'http://cdn.gog.com/open/galaxy/client/setup_galaxy_1.1.5.28.exe'
$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$32BitUrl" -validExitCodes $validExitCodes
