$openfireVersion = Get-Content openfire_version.txt

docker stop openfire
docker rm openfire -v
docker volume rm openfire-data
docker volume create openfire-data

docker run `
 -d `
 -p 5222:5222 `
 -p 5223:5223 `
 -p 5262:5262 `
 -p 5269:5269 `
 -p 5270:5270 `
 -p 5275:5275 `
 -p 5276:5276 `
 -p 7070:7070 `
 -p 7443:7443 `
 -p 7777:7777 `
 -p 9090:9090 `
 -p 9001:9001 `
 --name openfire `
 -v 'openfire-data:/usr/share/openfire' `
 armyguy255a/openfire:$openfireVersion