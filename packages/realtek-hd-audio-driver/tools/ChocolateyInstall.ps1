Import-Module (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'IniParser.psm1')

$packageName = 'realtek-hd-audio-driver'
$installerType = 'exe'
$32BitUrl = 'http://12244.wpc.azureedge.net/8012244/drivers/rtdrivers/pc/audio/0006-32bit_Win7_Win8_Win81_Win10_R279.exe'
$64BitUrl = 'http://12244.wpc.azureedge.net/8012244/drivers/rtdrivers/pc/audio/0006-64bit_Win7_Win8_Win81_Win10_R279.exe'
$setupConfig = Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "..\setup.iss"
$silentArgs = ('/s /a /s /sms /f1' + $setupConfig)
$validExitCodes = @(0)

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$32BitUrl" "$64BitUrl" -validExitCodes $validExitCodes

$setupLog = Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "..\setup.log"
$logData = IniParser-ParseFile($setupLog)
$resultCode = $logData['ResponseResult']['ResultCode']
if (-not ($resultCode -eq 0)) {
	Throw "Installation ResultCode was $($resultCode), expected 0!"
}
echo "You need to restart your computer for the driver to work."
