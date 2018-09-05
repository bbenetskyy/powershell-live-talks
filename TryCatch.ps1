<#
.Synopsis
This function will gather basic computer information
.Description
This function will gather basic computer information
From multiple computers and provide error logging information
.Parameter ComputerName
This parameter supports multiple computer names to gather
Data from. This parameter is Mandatory
.Example
Getting information from the local computer
Get-CompInfo -ComputerName .
.Example
Getting information form remote computers
Get-CompInfo -ComputerName comp1, comp2
.Example
Getting information form computers in a text file
Get-Content c:\servers.txt | Get-CompInfo
#>
Function Get-CompInfo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [String[]]$ComputerName,
        [Switch]$ErrorLog,
        [String]$LogFile = '.\errorlog.txt'
    )
    Begin {
        Write-Verbose 'Begin'
    }
    Process {
        Write-Verbose 'Start Process'
        foreach ($Computer in $ComputerName) {
            Try {
                Write-Verbose "Computer Name - $Computer"
                $os = Get-Wmiobject -ComputerName $Computer -Class Win32_OperatingSystem -ErrorAction Stop -ErrorVariable CurrentError
                Write-Verbose $os
                $Disk = Get-WmiObject -ComputerName $Computer -class Win32_LogicalDisk -filter "DeviceID='c:'"
                Write-Verbose $Disk
                $Bios = Get-WmiObject -ComputerName $Computer -Class Win32_bios 
                Write-Verbose $Bios

                $Prop = [ordered]@{ #With or without [ordered]
                    'ComputerName' = $computer;
                    'OS Name'      = $os.caption;
                    'OS Build'     = $os.buildnumber;
                    'Bios Version' = $Bios.Version;
                    'FreeSpace'    = $Disk.freespace / 1gb -as [int]
                }
                $Obj = New-Object -TypeName PSObject -Property $Prop 
                Write-Output $Obj
            }
            Catch {
                Write-warning "You have a problem with computer $Computer"
                If ($ErrorLog) {
                    Get-Date | Out-File $LogFile -Force
                    $Computer | Out-File $LogFile -Append
                    $CurrentError | out-file $LogFile -Append
                }
                
            }
        } 
        Write-Verbose 'End Process'
    }
    End {
        Write-Verbose 'End'
    }
}
