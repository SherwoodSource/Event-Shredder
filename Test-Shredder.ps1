# Unit Tests for Event Shredder Filtering Logic

$criticalLogs = @(
    "System", "Security", "Application", "Setup", "ForwardedEvents",
    "Microsoft-Windows-PowerShell/Operational", "Microsoft-Windows-PowerShell/Admin",
    "Microsoft-Windows-AppLocker/EXE and DLL", "Microsoft-Windows-AppLocker/MSI and Script",
    "Microsoft-Windows-CodeIntegrity/Operational", "Microsoft-Windows-DeviceGuard/Operational",
    "Microsoft-Windows-NTLM/Operational", "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational",
    "Microsoft-Windows-TerminalServices-LocalSessionManager/Admin", "Microsoft-Windows-TaskScheduler/Operational",
    "Microsoft-Windows-WMI-Activity/Operational", "Microsoft-Windows-CAPI2/Operational",
    "Microsoft-Windows-Crypto-DPAPI/Operational", "Microsoft-Windows-Dhcp-Client/Operational",
    "Microsoft-Windows-DNS-Client/Operational"
)

function Test-LogShredding($logList, $allowAllLogs) {
    $results = @{
        Cleared = @()
        Skipped = @()
    }

    foreach ($rawLogName in $logList) {
        $logName = $rawLogName.Trim()
        if ([string]::IsNullOrWhiteSpace($logName)) { continue }

        if (-not $allowAllLogs) {
            if ($criticalLogs -contains $logName) {
                $results.Skipped += $logName
                continue
            }
        }
        $results.Cleared += $logName
    }
    return $results
}

# --- Test Execution ---
$mockLogs = @("System", "Security", "MyCustomLog", "Application", "OtherLog", "  Setup  ")

Write-Host "Running Test 1: Safe Mode (Constrained)..." -ForegroundColor Cyan
$safeResults = Test-LogShredding $mockLogs $false
$expectedSkipped = 4 # System, Security, Application, Setup
if ($safeResults.Skipped.Count -eq $expectedSkipped) {
    Write-Host "PASSED: Correctly skipped $expectedSkipped critical logs." -ForegroundColor Green
} else {
    Write-Host "FAILED: Skipped $($safeResults.Skipped.Count) logs, expected $expectedSkipped." -ForegroundColor Red
}

Write-Host "`nRunning Test 2: Unconstrained Mode..." -ForegroundColor Cyan
$unconstrainedResults = Test-LogShredding $mockLogs $true
if ($unconstrainedResults.Cleared.Count -eq $mockLogs.Count) {
    Write-Host "PASSED: Correctly cleared all $($mockLogs.Count) logs." -ForegroundColor Green
} else {
    Write-Host "FAILED: Cleared $($unconstrainedResults.Cleared.Count) logs, expected $($mockLogs.Count)." -ForegroundColor Red
}
