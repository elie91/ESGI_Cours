Dockerfile:
```
FROM alpine

RUN apk add --update --no-cache openssh && ssh-keygen -A \
&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
&& echo "root:dm" | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```

Then:
```
$ docker build -t <username>/alpine-with-ssh .
$ docker run -P -d <username>/alpine-with-ssh
$ docker ps # you should see the port that was binded
$ ssh -p <port> root@localhost
root@localhost's password: dm
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <http://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

556b2121e2cf:~# 
```
