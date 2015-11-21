$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = "C:\Program Files\Informatica Cloud Secure Agent\jre\bin\java.exe"
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = '-jar C:\Program Files\Informatica Cloud Secure Agent\CloudExtProvisionClient.jar "cloudUsername" "testuser004@yopmail.com" "cloudPassword" "Infa1234" "connectorUUIDs" "0b0ad503-1c2c-4514-95ac-85a5adb71b3b|7791b183-222c-4cc8-b5dc-cd1992bd8ede|b631f215-1589-4fe7-bbac-eaee2080f29b" "identifier" "abcd-1234-defg-4567"'
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$p.WaitForExit()
$output = $p.StandardOutput.ReadToEnd()
Write-Host "Response: $output"
