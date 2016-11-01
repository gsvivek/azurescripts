param([string]$cloudUsername, [string]$cloudEmail, [string]$cloudPassword, [string]$firstName, [string]$lastName, [string]$title, [string]$orgName, [string]$phone, [string]$country, [string]$state, [string]$connectorUUIDs)
$computerSystemProduct = Get-WmiObject -class Win32_ComputerSystemProduct -namespace root\CIMV2
$result = & "C:\Program Files\Informatica Cloud Secure Agent\jre\bin\java.exe" -jar "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar" "cloudUsername" "$cloudUsername" "cloudEmail" "$cloudEmail" "cloudPassword" "$cloudPassword" "firstName" "$firstName" "lastName" "$lastName" "title" "$title" "orgName" "$orgName" "phone" "$phone" "orgCountry" "$country" "orgState" "$state" "connectorUUIDs" "$connectorUUIDs" "identifier" $computerSystemProduct.UUID "orgAddress" $computerSystemProduct.UUID | ConvertFrom-Json
$status = $result.response.status
$msg = $result.response.msg
if($status -eq "success") {
Write-Host "Registration successful on Informatica Cloud. Please login to the VM to use your Informatica Cloud subscription."
Remove-Item "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar"
Start-Process "C:\Program Files\Informatica Cloud Secure Agent\apps\agentcore\agent_start.bat"
Start-Process "C:\Program Files\Informatica Cloud Secure Agent\apps\agentcore\consoleAgentManager.bat" "configure $cloudUsername $cloudPassword"
}
else {
if($msg -eq "UserAlreadyExists") {Write-Error "Error Code: 195"}
ElseIf ($msg -eq "ConnectorActivationFailed") {Write-Error "Error Code: 196"}
Else {Write-Error "Error Code: 200"}
Remove-Item "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar"
exit 519
}