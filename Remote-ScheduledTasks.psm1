<#
 .Synopsis
  Starts one or more instances of a scheduled task on a remote computer.

 .Description
  The Start-ScheduledTask cmdlet starts a registered background task asynchronously on a remote computer.

 .Parameter ScheduledTask
  ScheduleTask Object retrieved from Get-RemoteScheduledTask

 .Example
  $Tasks = Get-RemoteScheduledTask -ComputerName "SERVER01" -Credential $(Get-Credential)
  $Tasks[0] | Start-RemoteScheduledTask
#>
Function Start-RemoteScheduledTask {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance]$ScheduledTask
    )

    begin {
    }

    process {
        Invoke-Command -ComputerName $ScheduledTask.PSComputerName -ScriptBlock {
            param($ScheduledTask)
            Write-Host "Starting: $($ScheduledTask.TaskName)" -ForegroundColor "Green"
            $ScheduledTask | Start-ScheduledTask
        } -ArgumentList $ScheduledTask
    }
}

<#
 .Synopsis
  Gets the task definition object of a scheduled task that is registered on a remote computer.

 .Description
  The Get-RemoteScheduledTask cmdlet gets the task definition object of a scheduled task that is registered on a remote computer.

 .Parameter ComputerName
  Name of the remote computer

 .Example 
  Get-RemoteScheduledTask -ComputerName "SERVER01" -Credential $(Get-Credential)
#>
Function Get-RemoteScheduledTask {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ComputerName,
        [Parameter(Mandatory = $false)]
        [pscredential]$Credential
    )

    begin {}

    process {
        $Tasks = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            Get-ScheduledTask | Where-Object { ($_.TaskPath -eq "\") -and ($_.State -Ne "Disabled") }
        }
    }

    end {
        Format-RemoteScheduledTasks $Tasks
        return $Tasks
    }
}

Function Format-RemoteScheduledTasks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Tasks
    )
    begin {}

    process {
        ForEach ($Index in $Tasks) {
            Write-Host "$($Tasks.IndexOf($Index)). $($Index.TaskName)"
        }
    }

    end {}
}
