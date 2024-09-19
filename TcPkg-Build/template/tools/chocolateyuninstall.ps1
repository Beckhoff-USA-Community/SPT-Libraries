$SPT_Base_Version="3.2.10"

$RepToolLocations = @(Join-Path "C:\Program Files (x86)\Beckhoff\TwinCAT\3.1\Components\Plc\Build_4026.*\" "Common\RepTool.exe" -Resolve)
if ($RepToolLocations.Length -gt 0) {
	$RepToolLocation = $RepToolLocations[$RepToolLocations.Length-1]
	$index = $RepToolLocation.IndexOf("\Build_4026.")
	$plcProfile = $RepToolLocation.Substring($index + 1)
	$index = $plcProfile.IndexOf("\Common\RepTool.exe")
	$plcProfile = $plcProfile.Substring(0, $index)
	$RepToolArgs = "--profile=`"TwinCAT PLC Control_$plcProfile`"", "--uninstallLib `"SPT Base Types, $SPT_Base_Version (Beckhoff Automation LLC)`""
	Start-Process $RepToolLocation -ArgumentList $RepToolArgs -Wait -WindowStyle Hidden
}
