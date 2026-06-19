Event-Shredder
==============

Event Shredder is an open-source utility designed to clear Windows event logs, helping to maintain privacy and free up system resources.

### Updates
- **v1.2**:
    - **Dual-Mode Execution Architecture**: Introduced a new execution layer allowing users to choose between 'Safe Mode' (default) and 'Unconstrained Mode'.
    - **Critical Log Protection**: Safe Mode automatically preserves 20 critical system channels (e.g., Security, PowerShell, AppLocker) to maintain system integrity and auditing.
    - **Advanced/Unconstrained Mode**: Provides a short-circuit pathway for power users to shred all logs without exception.
- **v1.1**:
    - **Modern GUI**: Updated from a legacy batch terminal to a professional Graphical User Interface (GUI) built with PowerShell and Windows Forms.
    - **Full Compatibility**: Now fully optimized for Windows 10 and Windows 11.
    - **Improved Stability**: Added robust administrative privilege checks and better handling for system-locked logs.
    - **Session Logging**: Each shredding session is now automatically recorded in a `ShredResults.txt` file for your records.

### Usage
Run `Event Shredder.bat` to launch the application. It will automatically request Administrator privileges if they are not already granted.

### Contribution
If you know of logs that are not currently covered by this app, please contribute to the repository!
"Project moved to SourceForge"
https://sourceforge.net/projects/eventshredder/
