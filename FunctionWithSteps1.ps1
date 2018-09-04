Function Show-Numbers {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
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

