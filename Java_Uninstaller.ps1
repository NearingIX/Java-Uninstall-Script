#Silent Java Uninstaller

    #Get the Registry Uninstall Path for Java
    $javaPath = Get-ChildItem -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall, 
    Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall  |
    Get-ItemProperty | Where-Object {$_.DisplayName-Match "Java"} | Select-Object -Property DisplayName, UninstallString

    ForEach ($version in $javaPath) {
       If ($version.UninstallString) {
        
        $uninstallJava = $version.UninstallString
        $uninstallJava = $uninstallJava.Trim("MsiExec.exe")
        #Quiet switches for no UI and no restart
        $argumentList = '/quiet', '/norestart'
        #Display Uninstall Path in PS
        Write-Host "MsiExec.exe$argumentList$uninstallJava"
        #Start Uninstall Process
        Invoke-Command -ScriptBlock {Start-Process MsiExec.exe $argumentList$uninstallJava -Wait}
       }
    }
exit