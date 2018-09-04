<#
.PARAMETER  Number
 Going for each of input numbers
 and print them out.
#>
Function Show-Numbers {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            HelpMessage="Please enter a set of number"
        )]
        [int] $Number
    )
    Begin {
       Write-Output 'Begin'
    }
    Process {
        foreach ($n in $Number) {
            Write-Output $n
        } 
    }
    End {
        Write-Output 'End'
    }
}

