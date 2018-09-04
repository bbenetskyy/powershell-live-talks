Write-Host "Loading functions"
function MyFunc
{
    Write-Host "MyFunc is running!"
}
Write-Host "Done"

Function addOne([int]$intIN) 
{ 
$intIN + 1 
} 
Function addTwo([int]$intIN) 
{ 
$intIN + 2 
}