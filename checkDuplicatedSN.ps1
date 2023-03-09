$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    if(-not (Get-Module JumpCloud -ListAvailable)){
Install-Module JumpCloud -Scope CurrentUser -Force
}
    
    $duplicatedsn = Get-JCSystem | Group-Object serialNumber | Where-Object Count -gt 1 | foreach {$_.Group}

    # !!! change Id to specific Device Group (check: Get-JCGroup -Type System -Name 'Here type name of the group' | Select id) !!!
    $groupid = (Get-JCAssociation -Type:('system_group') -Id:('Enter Group ID') -TargetType:('system')).targetID

    $duplicatedsn | ? {$_._id -in $groupid} | Group-Object serialNumber | foreach {$_.Group | Sort-Object lastContact -Descending | Select-Object hostname,lastContact, active, serialNumber | Format-Table }

    Read-Host
}
else {
    Start-Process -FilePath "powershell" -ArgumentList "$('-File ""')$(Get-Location)$('\')$($MyInvocation.MyCommand.Name)$('""')" -Verb runAs
}