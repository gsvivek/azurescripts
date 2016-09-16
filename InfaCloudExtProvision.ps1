param([string]$cloudEmail, [string]$cloudPassword, [string]$connectorUUIDs)
$computerSystemProduct = Get-WmiObject -class Win32_ComputerSystemProduct -namespace root\CIMV2
$result = & "C:\Program Files\Informatica Cloud Secure Agent\jre\bin\java.exe" -jar "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar" "cloudEmail" "$cloudEmail" "cloudPassword" "$cloudPassword" "connectorUUIDs" "$connectorUUIDs" "identifier" $computerSystemProduct.UUID | ConvertFrom-Json
$msg = $result.response.msg
if($msg.CompareTo("success")) {
Remove-Item "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar"
& "C:\Program Files\Informatica Cloud Secure Agent\main\agentcore\consoleAgentManager.bat" configure "$cloudEmail" "$cloudPassword"
& "C:\Program Files\Informatica Cloud Secure Agent\agent_start.bat"
}
else {
Remove-Item "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar"
Stop-Computer -force
}
