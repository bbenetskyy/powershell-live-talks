Function Show-Names {
    [CmdletBinding(SupportsShouldProcess)]
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
                if($PSCmdlet.ShouldProcess($Name,'We are going to kill Kenny!')) {
                Write-Warning 'Oh, my God! They killed Kenny! - You Busters!'
                }
            }
        }
    }
}