Function Get-CompInfo {
    [CmdletBinding()]
    Param(
        [Alias('Host')]
        [String[]]$ComputerName,
        [Switch]$LogExecutionTime,
        [switch]$WithPSObject
    )
    Begin {
        If ($LogExecutionTime) {
            Write-Verbose 'Execution time logging turned on'
            $stopwatch = [system.diagnostics.stopwatch]::StartNew()
        }
        Else {
            Write-Verbose 'Execution time logging turned off'
        }
        Foreach ($Computer in $ComputerName) {
            Write-Verbose "Computer: $Computer"
        }    
    }
    Process {
        foreach ($Computer in $ComputerName) {
            $os = Get-Wmiobject -ComputerName $Computer -Class Win32_OperatingSystem
            $Disk = Get-WmiObject -ComputerName $Computer -class Win32_LogicalDisk -filter "DeviceID='c:'"
            $Prop = @{ 
                'ComputerName' = $computer;
                'OS Name'      = $os.caption;
                'OS Build'     = $os.buildnumber;
                'FreeSpace'    = $Disk.freespace / 1gb -as [int]
            }
            if ($WithPSObject) {
                $Obj = New-Object -TypeName PSObject -Property $Prop 
                Write-Output $Obj
            }
            else {
                Write-Output $Prop
            } 
        } 
    }
    End {
        $stopwatch.Stop()
        Write-Verbose "Completed in $($stopwatch.Elapsed.TotalMilliseconds)"
    }

}

