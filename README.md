# elasticsearch-windows-docker
Elasticsearch Windows docker images

As there are no officially supported Elasticsearch Windows docker images, I created my own docker reposiotory for Elasticsearch Windows docker images.

All 3 currently avialable Windows docker images are supported (lts2016, 1803 and 1809).
[Windows 1903 is still not supported by azure devops](https://github.com/microsoft/azure-pipelines-image-generation/pull/1079) so I'm not able to provide an image for that version.

There are images for all major Elasticsearch versions including  2.x, 5.x, 6.x and 7.x

You can find all available tags and images in the docker hub repository:

https://hub.docker.com/r/gigi81/elasticsearch-windows/tags

To start Elasticsearch on the default port(s) just run:

```
docker run -d -p 9200:9200 -p 9300:9300 gigi81/elasticsearch-windows:7.5.0
```

For more details about host => image os version compatibility, check:
https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility?tabs=windows-server-1909%2Cwindows-10-1909
