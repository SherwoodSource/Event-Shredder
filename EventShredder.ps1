# --- Console Suppression (Win32 API Fix) ---
$kernel32Code = @'
[DllImport("kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
'@

$user32Code = @'
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@

$kernel32 = Add-Type -MemberDefinition $kernel32Code -Name "Kernel32" -Namespace "Win32" -PassThru
$user32 = Add-Type -MemberDefinition $user32Code -Name "User32" -Namespace "Win32" -PassThru

$consoleHandle = $kernel32::GetConsoleWindow()

# Robust check for valid System.IntPtr
if ($null -ne $consoleHandle -and $consoleHandle -ne [IntPtr]::Zero) {
    $user32::ShowWindowAsync($consoleHandle, 0) | Out-Null # 0 = SW_HIDE
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Elevation Logic ---
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "powershell.exe"
    $processInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $processInfo.Verb = "runas"
    try {
        [System.Diagnostics.Process]::Start($processInfo) | Out-Null
    } catch {
        [System.Windows.Forms.MessageBox]::Show("This application must be run as an Administrator to clear event logs.", "Elevation Required", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    exit
}

# --- GUI Setup ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Event Shredder v1.2"
$form.Size = New-Object System.Drawing.Size(500, 520)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Event Shredder"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 102, 204)
$titleLabel.Size = New-Object System.Drawing.Size(460, 40)
$titleLabel.Location = New-Object System.Drawing.Size(20, 20)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Text = "This utility will clear Windows Event Logs to maintain privacy. Select your shredding mode below."
$descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$descLabel.Size = New-Object System.Drawing.Size(440, 40)
$descLabel.Location = New-Object System.Drawing.Size(30, 70)
$descLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($descLabel)

$chkAllowAll = New-Object System.Windows.Forms.CheckBox
$chkAllowAll.Text = "Shred Critical System Logs (Advanced/Unconstrained Mode)"
$chkAllowAll.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$chkAllowAll.Size = New-Object System.Drawing.Size(440, 20)
$chkAllowAll.Location = New-Object System.Drawing.Size(35, 110)
$chkAllowAll.Checked = $false
$form.Controls.Add($chkAllowAll)

$btnShred = New-Object System.Windows.Forms.Button
$btnShred.Text = "Shred Event Logs"
$btnShred.Size = New-Object System.Drawing.Size(200, 40)
$btnShred.Location = New-Object System.Drawing.Size(150, 140)
$btnShred.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnShred.BackColor = [System.Drawing.Color]::FromArgb(0, 102, 204)
$btnShred.ForeColor = [System.Drawing.Color]::White
$btnShred.FlatStyle = "Flat"
$form.Controls.Add($btnShred)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(440, 25)
$progressBar.Location = New-Object System.Drawing.Size(30, 200)
$form.Controls.Add($progressBar)

$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Size = New-Object System.Drawing.Size(440, 220)
$logBox.Location = New-Object System.Drawing.Size(30, 240)
$logBox.ReadOnly = $true
$logBox.Font = New-Object System.Drawing.Font("Consolas", 8)
$logBox.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($logBox)

# --- Execution Layer ---
$btnShred.Add_Click({
    $allowAllLogs = $chkAllowAll.Checked
    $btnShred.Enabled = $false
    $logBox.Clear()

    $modeText = if ($allowAllLogs) { "UNCONSTRAINED MODE" } else { "SAFE MODE (PROTECTED)" }
    $logBox.AppendText("Initializing shredding in $modeText...`n")

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

    $logs = wevtutil.exe el
    $progressBar.Maximum = $logs.Count
    $progressBar.Value = 0

    $counter = 0
    foreach ($rawLogName in $logs) {
        $logName = $rawLogName.Trim()
        if ([string]::IsNullOrWhiteSpace($logName)) { continue }

        $counter++
        $progressBar.Value = $counter

        if (-not $allowAllLogs) {
            # Case-insensitive validation against protected array
            if ($criticalLogs -contains $logName) {
                $logBox.SelectionColor = [System.Drawing.Color]::DarkGoldenrod
                $logBox.AppendText("Preserving (Safety Mode): $logName`n")
                $logBox.ScrollToCaret()
                continue
            }
        }

        # Shredding logic with robust error detection
        $logBox.SelectionColor = [System.Drawing.Color]::Black
        $logBox.AppendText("Clearing: $logName... ")

        wevtutil.exe cl "$logName" 2>$null

        if ($LASTEXITCODE -eq 0) {
            $logBox.SelectionColor = [System.Drawing.Color]::Green
            $logBox.AppendText("DONE`n")
        } else {
            $logBox.SelectionColor = [System.Drawing.Color]::Red
            $logBox.AppendText("FAILED (Locked)`n")
        }

        $logBox.ScrollToCaret()
        [System.Windows.Forms.Application]::DoEvents()
    }

    $logBox.SelectionColor = [System.Drawing.Color]::Blue
    $logBox.AppendText("`nShredding session complete!")

    try {
        $logPath = Join-Path $PSScriptRoot "ShredResults.txt"
        $logBox.Text | Out-File -FilePath $logPath -Encoding utf8
        $logBox.AppendText("`nResults recorded in: ShredResults.txt")
    } catch {
        $logBox.AppendText("`nError saving record: $($_.Exception.Message)")
    }

    [System.Windows.Forms.MessageBox]::Show("The shredding session is complete. Mode: $modeText", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $btnShred.Enabled = $true
})

[System.Windows.Forms.Application]::Run($form)
