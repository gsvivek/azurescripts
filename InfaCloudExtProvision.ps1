param([string]$cloudUsername, [string]$cloudPassword,[string]$connectorUUIDs,[string]$identifier)
$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = "C:\Program Files\Informatica Cloud Secure Agent\jre\bin\java.exe"
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = '-jar C:\Program Files\Informatica Cloud Secure Agent\CloudExtProvisionClient.jar "cloudUsername" "$cloudUsername" "cloudPassword" "$cloudPassword" "connectorUUIDs" "$connectorUUIDs" "identifier" "$identifier"'
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$p.WaitForExit()
$output = $p.StandardOutput.ReadToEnd()
Write-Host "Response: $output"
