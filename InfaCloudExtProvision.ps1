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
Write-Error "Error occurred while registering user on Informatica Cloud. VM has been shut down but not deallocated and you will incur charges. Please stop the VM from the Azure portal to stop incurring charges."
if($msg -eq "UserAlreadyExists") {Write-Error "Error Details: User already exists with the username " $cloudUsername}
ElseIf ($msg -eq "ConnectorActivationFailed") {Write-Error "Error Details: Connector activation failed."}
Else {Write-Error "An unexpected error has occurred. Please try again later or contact support."}
Remove-Item "C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar"
Stop-Computer -force
exit 1905
}