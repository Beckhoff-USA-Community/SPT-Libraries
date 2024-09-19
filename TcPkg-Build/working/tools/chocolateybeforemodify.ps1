$ManLibPath="$($env:ALLUSERSPROFILE)\Beckhoff\TwinCAT\PlcEngineering\Managed Libraries\"
if (Test-Path -Path $ManLibPath) {
	$cachefiles = Get-ChildItem -Path $ManLibPath* -Include "cache*"
	foreach($cf in $cachefiles) 
	{
		Remove-Item -Path $cf.FullName
	}
}