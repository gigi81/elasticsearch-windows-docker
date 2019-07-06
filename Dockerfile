# escape=`

ARG ARG_FROM

FROM $ARG_FROM

ARG ARG_VERSION

ENV ES_HOME=C:\elasticsearch `
    ES_VERSION=$ARG_VERSION

# install elasticsearch
RUN Invoke-WebRequest -Uri "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$($env:ES_VERSION)-windows-x86_64.zip" -OutFile 'es.zip'; `
    New-Item -ItemType Directory -Path estemp; `
    Expand-Archive 'es.zip' -DestinationPath estemp; `
    New-Item -ItemType Directory -Path $env:ES_HOME; `
    $espath = (Get-ChildItem -Path estemp -Directory)[0].FullName; `
    Move-Item -Path "$espath\*" -Destination $env:ES_HOME; `
    if(Test-Path "$env:ES_HOME\jdk") { Remove-Item "$env:ES_HOME\jdk" -Recurse -Force }; `
    Remove-Item 'es.zip' -Force; `
    Remove-Item estemp -Recurse -Force;

# configure elasticsearch
RUN $config = @('cluster.name: docker-cluster', 'network.host: 0.0.0.0', 'node.name: node01', 'cluster.initial_master_nodes: node01'); `
    [string]::Join([Environment]::NewLine, $config) | Add-Content -Path "$env:ES_HOME\config\elasticsearch.yml";

EXPOSE 9200 9300

ENTRYPOINT ["C:\\elasticsearch\\bin\\elasticsearch.bat"]
