param($apikey)

$BaseDir = "..\Library Repository"

Function GetLibraries{
  param ($BaseDir = "..\Library Repository")
    $tcplclibs = @(Get-ChildItem -Path $BaseDir -Recurse -Filter *.library)
    return $tcplclibs
}

Function BuildLibraries{
    param(  $TemplateLocation = "template\", 
            $WorkingLocation = (Join-Path (Convert-Path "~") "\Documents\GitHub\SPT-Libraries\TcPkg-Build\working\"),
            $BuildLocaiton = (Join-Path (Convert-Path "~") "\Documents\GitHub\SPT-Libraries\TcPkg-Build\build\"))

    $tcplclibs = GetLibraries

    #$tcplclib = $tcplclibs

    foreach ($tcplclib in $tcplclibs){


    Get-ChildItem $WorkingLocation | Remove-Item –recurse -Force

    # Find the Common Name of the library (My Library)
    $libraryCommonName = $tcplclib.Basename.Replace("_", " ")
    # Find the Base Name of the library (My_Library)
    $libraryBaseName = $tcplclib.Basename
    # Find the Full Library name (My_Library.libary)
    $libraryFullName = $tcplclib.Name
    # Find the library version
    $libraryVersion = $tcplclib.FullName.split("\")[-2]
    # Find the library dependencies
    $depFile = $tcplclib.DirectoryName + "\dependencies"
    $libraryDependencies = Select-String -Path $depFile -Pattern 'SPT '
    if ($libraryDependencies -ne $null)
    {
        $libraryDependencies = $libraryDependencies -replace '^.*#'
        $libraryDependencies = $libraryDependencies.Replace(" ", "_")
    }

    # Get the template file
    $nuspecContent = Get-Content -Path $TemplateLocation"Custom.Package.nuspec"
    # Create the XML document
    $xmlDocument = [xml]$nuspecContent
    # Modify the package ID
    $xmlDocument.package.metadata.id = "TwinCAT.XAE.PLC.Lib."+$libraryBaseName
    # Modify the package version
    $xmlDocument.package.metadata.version = $libraryVersion
    # Modify the package title
    $xmlDocument.package.metadata.title = "Beckhoff TwinCAT XAE PLC Library "+$libraryCommonName
    # Modify the package summary
    $xmlDocument.package.metadata.summary = "TwinCAT-XAE-PLC-Lib-"+$libraryBaseName+" package"
    # Modify the package description
    $xmlDocument.package.metadata.description = "Contains Beckhoff TwinCAT XAE PLC Library "+$libraryBaseName+" version "+$libraryVersion

    ####################
    ### Dependencies ###
    ####################

    # create dependencies xml document
    $xmlDep = New-Object -TypeName System.Xml.XmlDocument
    # Create root node for dependencies
    $rootDep = $xmlDep.CreateElement("dependencies")
    $mute = $xmlDep.AppendChild($rootDep)
    
    # Add the dependency xml objects
    foreach ($linDep in $libraryDependencies){
        $childDep = $xmlDep.CreateElement("dependency")
        $childDep.SetAttribute("id","TwinCAT.XAE.PLC.Lib." + $linDep)
        $childDep.SetAttribute("version", "0.0.0")
        $mute = $rootDep.AppendChild($childDep)
    }

    # Modify the dependencies
    $xmlDocument.package.metadata.dependencies.InnerXml = $rootDep.InnerXml

    ####################
    ### Files ###
    ####################
    
    # create dependencies xml document
    $xmlFiles = New-Object -TypeName System.Xml.XmlDocument
    # Create root node for dependencies
    $rootFiles = $xmlFiles.CreateElement("files")
    $mute = $xmlFiles.AppendChild($rootFiles)

    # Add Icon
    $childFile = $xmlFiles.CreateElement("file")
    $childFile.SetAttribute("src","TF1000-Base.png")
    $childFile.SetAttribute("target", "icon.png")
    $mute = $rootFiles.AppendChild($childFile)

    # Add Tools
    $childFile = $xmlFiles.CreateElement("file")
    $childFile.SetAttribute("src","tools\**")
    $childFile.SetAttribute("target", "tools")
    $mute = $rootFiles.AppendChild($childFile)

    # Add Lib
    $childFile = $xmlFiles.CreateElement("file")
    $childFile.SetAttribute("src",$libraryFullName)
    $childFile.SetAttribute("target", "tools\LibraryToInstall.library")
    $mute = $rootFiles.AppendChild($childFile)

    # Modufy the files xml
    $xmlDocument.package.files.InnerXml = $rootFiles.InnerXml

    # Save the document
    $xmlSaveLocation = $WorkingLocation+"Custom.Package.nuspec"
    $xmlDocument.Save($xmlSaveLocation)

    # Copy other template files
    Copy-Item -Path $TemplateLocation"\tools" -Destination $WorkingLocation"\tools" -Recurse -Force
    Copy-Item -Path $TemplateLocation"\TF1000-Base.png" -Destination $WorkingLocation -Force

    # Copy library file
    Copy-Item $tcplclib.FullName -Destination $WorkingLocation -Force

    $customuninstallheader = '$SPT_Base_Version='
    $customuninstallheader += "`""
    $customuninstallheader += $libraryVersion
    $customuninstallheader += "`"`n"

    # Modify the uninstall
    $customuninstallbody = '
$RepToolLocations = @(Join-Path "C:\Program Files (x86)\Beckhoff\TwinCAT\3.1\Components\Plc\Build_4026.*\" "Common\RepTool.exe" -Resolve)
if ($RepToolLocations.Length -gt 0) {
    $RepToolLocation = $RepToolLocations[$RepToolLocations.Length-1]
    $index = $RepToolLocation.IndexOf("\Build_4026.")
    $plcProfile = $RepToolLocation.Substring($index + 1)
    $index = $plcProfile.IndexOf("\Common\RepTool.exe")
    $plcProfile = $plcProfile.Substring(0, $index)
    $RepToolArgs = "--profile=`"TwinCAT PLC Control_$plcProfile`"", "--uninstallLib `"SPT Base Types, $SPT_Base_Version (Beckhoff Automation LLC)`""
    Start-Process $RepToolLocation -ArgumentList $RepToolArgs -Wait -WindowStyle Hidden
}'

    $customuninstall = $customuninstallheader + $customuninstallbody
    Clear-Content $WorkingLocation"\tools\chocolateyuninstall.ps1"
    Add-Content $WorkingLocation"\tools\chocolateyuninstall.ps1" $customuninstall

    # Move on to building the package
    write-host "Building Package $libraryFullName $libraryVersion" -BackgroundColor Green -ForegroundColor Black
    tcpkg pack $WorkingLocation"Custom.Package.nuspec" -o $BuildLocaiton
    }
}


BuildLibraries
