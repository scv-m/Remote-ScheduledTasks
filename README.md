# Remote Scheduled Tasks

A simple wrapper for PowerShell's [ScheduledTasks](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/?view=win10-ps) module to run against remote computers

######Supports the following [ScheduledTasks](https://docs.microsoft.com/en-us/powershell/module/scheduledtasks/?view=win10-ps) methods in a limited capacity.

✅ Get-ScheduledTask
✅ Start-ScheduledTask

## Installing

```powershell
git clone "https://github.com/scv-m/Remote-ScheduledTasks"
```

## Usage

```powershell
Import-Module Remote-ScheduledTasks

$Tasks = Get-RemoteScheduledTask -ComputerName "SERVER01" -Credential $(Get-Credential)
0. User Sync
1. Computer Sync

$Tasks[0] | Start-RemoteScheduledTask
Starting: User Sync
```
