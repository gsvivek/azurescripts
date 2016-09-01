param([string]$cloudUsername, [string]$cloudPassword,[string]$connectorUUIDs,[string]$identifier)
$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = "C:\Program Files\Informatica Cloud Secure Agent\jre\bin\java.exe"
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$computerSystemProduct = Get-WmiObject -class Win32_ComputerSystemProduct -namespace root\CIMV2
$pinfo.Arguments = '-jar C:\Program Files\Informatica Cloud Secure Agent\InfaCloudExtProvision.jar "cloudUsername" "$cloudUsername" "cloudPassword" "$cloudPassword" "connectorUUIDs" "$connectorUUIDs" "identifier" "$computerSystemProduct.UUID"'
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$p.WaitForExit()
$output = $p.StandardOutput.ReadToEnd()
Write-Host "Response: $output"
