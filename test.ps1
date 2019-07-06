Param (
	[Parameter(Mandatory=$false)]
   [string] $Timeout = 120
   
   [Parameter(Mandatory=$false)]
   [string] $Timeout = 120
)

$start = [datetime]::UtcNow
$successfull = $false

$ip = docker inspect --format='{{.NetworkSettings.Networks.nat.IPAddress}}' elasticsearch
$ip = $ip.Trim()

if([string]::IsNullOrEmpty($ip))
{
    $ip = 'localhost'
}

while(!$successfull -and (New-TimeSpan -Start $start -End ([datetime]::UtcNow)).TotalSeconds -le $Timeout)
{
    try
    {
        Write-Host "Getting cluster health..."
        $health = Invoke-RestMethod 'http://$ip:9200/_cluster/health' -TimeoutSec 5
        Write-Host "Cluster status is $($health.status)"
        $successfull = $health.status -eq 'green'
    }
    catch
    {
        Write-Host $_.Exception.Message
        Start-Sleep 5
    }
}

docker logs elasticsearch
exit(!$successfull)
