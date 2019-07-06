# escape=`

FROM openjdk:11-jdk-windowsservercore-1809

ARG ARG_VERSION

ENV ES_HOME=C:\elasticsearch `
    ES_VERSION=$ARG_VERSION

# install elasticsearch
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Set-Variable -Name 'url' -Value "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($env:ES_VERSION)-windows-x86_64.zip"; `
    Write-Host "Downloading $url"; `
    Invoke-WebRequest -Uri $url -OutFile 'es.zip'; `
    Write-Host "Extracting and installing to $($env:ES_HOME)"; `
    New-Item -ItemType Directory -Path estemp; `
    Expand-Archive 'es.zip' -DestinationPath estemp; `
    New-Item -ItemType Directory -Path $env:ES_HOME; `
    Set-Variable -Name espath -Value (Get-ChildItem -Path estemp -Directory)[0].FullName; `
    Move-Item -Path "$espath\*" -Destination $env:ES_HOME; `
    if(Test-Path "$env:ES_HOME\jdk") { Remove-Item "$env:ES_HOME\jdk" -Recurse -Force }; `
    Remove-Item 'es.zip' -Force; `
    Remove-Item estemp -Recurse -Force;

# configure elasticsearch
RUN $config = @('cluster.name: docker-cluster', 'network.host: 0.0.0.0', 'node.name: node01', 'cluster.initial_master_nodes: node01'); `
    [string]::Join([Environment]::NewLine, $config) | Add-Content -Path "$env:ES_HOME\config\elasticsearch.yml";

EXPOSE 9200 9300

ENTRYPOINT ["C:\\elasticsearch\\bin\\elasticsearch.bat"]
