param([string]$cloudUsername, [string]$cloudEmail, [string]$cloudPassword, [string]$firstName, [string]$lastName, [string]$title, [string]$orgName, [string]$phone, [string]$connectorUUIDs)
$computerSystemProduct = Get-WmiObject -class Win32_ComputerSystemProduct -namespace root\CIMV2
$result = & "C:\Program Files\Informatica Cloud Secure Agent\jre\bin\java.exe" -jar "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar" "cloudUsername" "$cloudUsername" "cloudEmail" "$cloudEmail" "cloudPassword" "$cloudPassword" "firstName" "$firstName" "lastName" "$lastName" "title" "$title" "orgName" "$orgName" "phone" "$phone" "connectorUUIDs" "$connectorUUIDs" "identifier" $computerSystemProduct.UUID "orgAddress" $computerSystemProduct.UUID | ConvertFrom-Json
$status = $result.response.status
if($status.CompareTo("success")) {
Remove-Item "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar"
& "C:\Program Files\Informatica Cloud Secure Agent\main\agentcore\consoleAgentManager.bat" configure "$cloudUsername" "$cloudPassword"
& "C:\Program Files\Informatica Cloud Secure Agent\agent_start.bat"
}
else {
Remove-Item "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar"
Stop-Computer -force
}
