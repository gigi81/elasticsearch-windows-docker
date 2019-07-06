[CmdletBinding()]
Param (
   [Parameter(Mandatory=$true)]
   [string] $Version,

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

$baseUrl = "http://$($ip):9200"
Write-Host "Conneting to $baseUrl"

while(!$successfull -and (New-TimeSpan -Start $start -End ([datetime]::UtcNow)).TotalSeconds -le $Timeout)
{
    try
    {
        Write-Host "Getting cluster health..."
        $health = Invoke-RestMethod "$baseUrl/_cluster/health" -TimeoutSec 5
        Write-Host "Cluster status is $($health.status)"
        $successfull = $health.status -eq 'green'

        if($successfull)
        {
            $cluster = Invoke-RestMethod $baseUrl -TimeoutSec 5
            Write-Host "Cluster version is $($cluster.version.number)"
            if($cluster.version.number -ne $Version)
            {
                Write-Host "Version does not match, was expecting $Version"
                $successfull = $false
                break #exit while loop
            }
        }
    }
    catch
    {
        Write-Host $_.Exception.Message
        Start-Sleep 5
    }
}

docker logs elasticsearch
exit(!$successfull)
