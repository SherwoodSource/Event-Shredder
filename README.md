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

# Contribution
🚀 We Need Help!

Current Focus & Roadmap:

Event-Shredder is actively modernizing, and we are looking for contributors to help shape the future of this tool. Whether you are a seasoned developer or great at project planning, we have a place for you.

We are currently looking for help with three main areas:

1. **Feature Development:** Writing code to improve log-clearing mechanics, optimizing performance, and making the dual-mode execution (Standard vs. Advanced) rock-solid.
2. **Roadmapping Future Goals:** Helping us brainstorm, structure, and plan what Event-Shredder should look like in the next 6 to 12 months.
3. **Project Management & Goal Setup:** Breaking down our big-picture goals into bite-sized, actionable GitHub Issues that other developers can easily pick up.

### How to Get Started
Check out our [CONTRIBUTING.md](./CONTRIBUTING.md) file for a deep dive into our current development goals and how you can claim a task!
