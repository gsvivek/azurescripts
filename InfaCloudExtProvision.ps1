param([string]$cloudEmail, [string]$cloudPassword,[string]$connectorUUIDs)
$computerSystemProduct = Get-WmiObject -class Win32_ComputerSystemProduct -namespace root\CIMV2
$result = & "C:\Program Files\Informatica Cloud Secure Agent\jre\bin\java.exe" -jar "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar" "cloudEmail" "$cloudEmail" "cloudPassword" "$cloudPassword" "connectorUUIDs" "$connectorUUIDs" "identifier" $computerSystemProduct.UUID | ConvertFrom-Json
$status = $result.response.status
if(-Not $status.CompareTo("success")) {Stop-Computer -force}
