Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Elevation Logic (Step 2) ---
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
$form.Text = "Event Shredder v1.1"
$form.Size = New-Object System.Drawing.Size(500, 450)
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
$descLabel.Text = "This utility will clear all Windows Event Logs to free up space and maintain privacy. Click the button below to start the process."
$descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$descLabel.Size = New-Object System.Drawing.Size(440, 40)
$descLabel.Location = New-Object System.Drawing.Size(30, 70)
$descLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($descLabel)

$btnShred = New-Object System.Windows.Forms.Button
$btnShred.Text = "Shred All Event Logs"
$btnShred.Size = New-Object System.Drawing.Size(200, 40)
$btnShred.Location = New-Object System.Drawing.Size(150, 130)
$btnShred.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnShred.BackColor = [System.Drawing.Color]::FromArgb(0, 102, 204)
$btnShred.ForeColor = [System.Drawing.Color]::White
$btnShred.FlatStyle = "Flat"
$form.Controls.Add($btnShred)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(440, 25)
$progressBar.Location = New-Object System.Drawing.Size(30, 190)
$form.Controls.Add($progressBar)

$logBox = New-Object System.Windows.Forms.RichTextBox
$logBox.Size = New-Object System.Drawing.Size(440, 160)
$logBox.Location = New-Object System.Drawing.Size(30, 230)
$logBox.ReadOnly = $true
$logBox.Font = New-Object System.Drawing.Font("Consolas", 8)
$logBox.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($logBox)

# --- Logic (Step 3) ---
$btnShred.Add_Click({
    $btnShred.Enabled = $false
    $logBox.Clear()
    $logBox.AppendText("Starting shredding process...`n")

    $logs = wevtutil.exe el
    $progressBar.Maximum = $logs.Count
    $progressBar.Value = 0

    $counter = 0
    foreach ($logName in $logs) {
        $counter++
        $logBox.AppendText("[$counter/$($logs.Count)] Clearing: $logName`n")
        $logBox.ScrollToCaret()

        # Using wevtutil cl directly as it's efficient
        wevtutil.exe cl "$logName" 2>$null

        $progressBar.Value = $counter
        [System.Windows.Forms.Application]::DoEvents()
    }

    $logBox.AppendText("`nSuccessfully shredded all event logs!")
    [System.Windows.Forms.MessageBox]::Show("Event logs have been successfully shredded.", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $btnShred.Enabled = $true
})

[System.Windows.Forms.Application]::Run($form)
