# Task Scheduler validation

```powershell
.\Validate-TaskScheduler.ps1
```

Created by **Dewald Pretorius**. The validator is read-only and reports Task Scheduler service state, disabled tasks and unresolved principals. Exit codes: `0` healthy, `1` review required, `5` collection failure.
