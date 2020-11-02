Terminal 1:
```
$ docker pull alpine
$ docker images
$ docker image ls
$ docker run -it alpine
# ps
```

Terminal 2:
```
$ docker ps
$ docker exec <container-id> ping www.google.com
```

Terminal 1:
```
# ps
# touch /var/me
```

Terminal 2:
```
$ docker commit <container-id> <username>/alpine-dm
$ docker login
$ docker push <username>/alpine-dm
```

Terminal 1:
```
# exit
$ docker rm <container-id>
$ docker rmi <username>/alpine-dm alpine
$ docker pull <username>/alpine-dm alpine
$ docker run -it <username>/alpine-dm alpine
# ls /var
```
`/var/me` should be listed.