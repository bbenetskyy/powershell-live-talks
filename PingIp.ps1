Function Ping-Ip {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $true
        )]
        [ValidatePattern("\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b")]
        [String[]]$IPAddress
    )
    
    Process {
        foreach ($ip in $IPAddress) {            
            ping $ip
        }
    }
}