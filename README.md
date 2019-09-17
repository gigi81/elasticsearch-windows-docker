# elasticsearch-windows-docker
Elasticsearch Windows docker images

As there are no officially supported Elasticsearch Windows docker images, I created my own docker reposiotory for Elasticsearch Windows docker images.

All 3 currently avialable Windows docker images are supported (lts2016, 1803 and 1809).

There are images for all major Elasticsearch versions including  2.x, 5.x, 6.x and 7.x

You can find all available tags and images in the docker hub repository:

https://hub.docker.com/r/gigi81/elasticsearch-windows/tags

To start Elasticsearch on the default port just run one of these 3 commands, depending on the version of Windows you are using:

```
docker run -d -p 9200:9200 -p 9300:9300 gigi81/elasticsearch-windows:7.3.2-windowsservercore-1809
docker run -d -p 9200:9200 -p 9300:9300 gigi81/elasticsearch-windows:7.3.2-windowsservercore-1803
docker run -d -p 9200:9200 -p 9300:9300 gigi81/elasticsearch-windows:7.3.2-windowsservercore-ltsc2016
```