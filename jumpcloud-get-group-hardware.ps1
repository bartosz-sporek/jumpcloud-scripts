# Get system info from all systems
$insightid = Get-JCSystemInsights -Table SystemInfo

# Get IDs from all devices in Poland device group 
$id = (Get-JCAssociation -Type:('system_group') -Id:('61544b60b544064906a76ea7') -TargetType:('system')).targetID

# Filter out system ID from Poland 
$polandsysid = ($insightid | ? {$_.SystemId -in $id})

# Get usernames from Polish users
$polandusernames = $polandsysid | Get-JCsystemUser | Where-Object {$_.Username -ne 'it.poland' -and $_.Username -ne 'it.spain' -and $_.Username -ne 'it.turkey'} | Select username


# List out all Polish devices including hostname, vendor, model and serial number
$polandsysid | Where-Object {$_.SystemID -in (Get-JCAssociation -Type:('system') -Id:($_.SystemID) -TargetType:('user')).id} | Select-Object @{n="Username";e={($polandusernames).username}},Hostname,HardwareVendor,HardwareModel,HardwareSerial | Export-Csv polanddevices.csv