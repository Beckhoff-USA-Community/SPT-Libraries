param($apikey)

#Push the packages
$packages = Get-ChildItem "build\"
foreach ($package in $packages){
    dotnet nuget push $package.FullName -s "https://community.beckhoff-usa.com" -k "private_key"
}