# Windows Task Scheduler Audit Toolkit

A read-only PowerShell toolkit for scheduled task inventory and health reporting.

## Features

- Scheduled task inventory
- Task state and last-run context
- Result-code summary
- CSV, JSON, and HTML reports

## How to run

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Windows_Task_Scheduler_Audit_Toolkit.ps1
```

## Safety

Diagnostic-only. It reports scheduled task information for support review.
