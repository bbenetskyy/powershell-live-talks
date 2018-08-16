
function Get-ServiceStatus {
    Get-Service | group -Property Status | select -Property count, name
}