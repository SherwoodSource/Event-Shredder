# Contributing to Event-Shredder

Thank you for taking the time to contribute! We are actively working on the `modernize-event-shredder` branch and need your hands on the deck.

## 🎯 Where We Need You Most

### 1. Feature Development
If you want to dive straight into the codebase, we are currently prioritizing:
* **Asynchronous Execution:** Moving heavy log-clearing loops off the main UI thread to prevent the application from freezing.
* **Error & Lock Diagnostics:** Improving try-catch blocks to safely handle and report locked system files or administrative access denials without crashing.

### 2. Roadmapping Future Goals
We want to expand what Event-Shredder can do, and we need thinkers to help us map out features like:
* **True Forensic Shredding:** Moving from standard file deletion to secure, sector-overwriting data destruction.
* **Granular Filtering:** Allowing users to target logs by specific date ranges, Event IDs, or keywords.
* **CLI Engine:** Separating the core logic from the UI so the tool can be run headlessly via command line or Windows Task Scheduler.

If you have ideas on how to architecture these, open a new thread in the **Discussions** tab or submit a feature proposal issue!

### 3. Turning Goals into Actionable Tasks
Good documentation keeps a project alive. If you are great at organizing projects, you can help us by:
* Creating specific GitHub Issues based on our roadmap.
* Writing clear "Acceptance Criteria" for existing open issues so other developers know exactly what a successful PR looks like.

---

## 🛠️ Getting Started Locally
1. **Fork and Clone:** Fork the repository to your own GitHub account, clone it locally, and make sure you switch to the `modernize-event-shredder-1026476692712707482` branch.
2. **Environment Setup:** Set up your local Windows development environment (add any specific build, IDE, or tool requirements here).
3. **Find a Task:** Look through our open issues tracker for tasks tagged `good first issue` or `help wanted` to grab something to work on.
4. **Submit a Pull Request (PR):** Once you’ve written and tested your changes, push them to your forked repository. Then, open a Pull Request back to our project branch so we can review your code, give feedback, and merge it into the project!
