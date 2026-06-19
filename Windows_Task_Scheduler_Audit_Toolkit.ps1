#requires -Version 5.1
<#
.SYNOPSIS
    Windows Task Scheduler Audit Toolkit.
.DESCRIPTION
    Read-only scheduled task inventory and health reporter.
#>
[CmdletBinding()]
param([string]$OutputPath)
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
if([string]::IsNullOrWhiteSpace($OutputPath)){$OutputPath=Join-Path ([Environment]::GetFolderPath('Desktop')) 'Task_Scheduler_Reports'}
New-Item -Path $OutputPath -ItemType Directory -Force|Out-Null
$tasks=Get-ScheduledTask -ErrorAction SilentlyContinue|ForEach-Object{$info=$_|Get-ScheduledTaskInfo -ErrorAction SilentlyContinue;[PSCustomObject]@{TaskName=$_.TaskName;TaskPath=$_.TaskPath;State=$_.State;Author=$_.Author;LastRunTime=$info.LastRunTime;NextRunTime=$info.NextRunTime;LastTaskResult=$info.LastTaskResult;NumberOfMissedRuns=$info.NumberOfMissedRuns}}
$tasks|Export-Csv (Join-Path $OutputPath "scheduled_tasks_$stamp.csv") -NoTypeInformation -Encoding UTF8
$tasks|ConvertTo-Json -Depth 5|Set-Content (Join-Path $OutputPath "scheduled_tasks_$stamp.json") -Encoding UTF8
$attention=$tasks|Where-Object{$_.LastTaskResult -notin @(0,267011) -or $_.NumberOfMissedRuns -gt 0}
$attention|Export-Csv (Join-Path $OutputPath "tasks_needing_review_$stamp.csv") -NoTypeInformation -Encoding UTF8
$summary=[PSCustomObject]@{Computer=$env:COMPUTERNAME;TaskCount=@($tasks).Count;ReviewCount=@($attention).Count;Generated=Get-Date}
$html="<h1>Task Scheduler Audit - $env:COMPUTERNAME</h1><p>Generated $(Get-Date)</p><h2>Summary</h2>$(@($summary)|ConvertTo-Html -Fragment)<h2>Tasks Needing Review</h2>$($attention|ConvertTo-Html -Fragment)<h2>All Tasks</h2>$($tasks|ConvertTo-Html -Fragment)"
$html|ConvertTo-Html -Title 'Task Scheduler Audit'|Set-Content (Join-Path $OutputPath "task_scheduler_audit_$stamp.html") -Encoding UTF8
$summary|Format-List
Write-Host "Reports saved to: $OutputPath" -ForegroundColor Green
