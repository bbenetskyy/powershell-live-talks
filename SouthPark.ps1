Function Show-Names {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $true
        )]
        [ValidateCount(1,2)]
        [ValidateSet('Stan', 'Kyle', 'Eric', 'Kenny')]
        [String[]]$Name
    )
    
    Process {
        foreach ($n in $Name) {            
            Write-Output $n
            if($n -eq 'Kenny'){
                Write-Warning 'Oh, my God! They killed Kenny! - You Busters!'
            }
        }
    }
}