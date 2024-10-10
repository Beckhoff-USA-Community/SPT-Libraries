#Push the packages
$packages = Get-ChildItem "build\"
foreach ($package in $packages){
    dotnet nuget push $package.FullName -s "https://packages.beckhoff-usa.com/repository/tcpkg-community/"
}