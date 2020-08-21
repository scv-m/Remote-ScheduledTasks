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
