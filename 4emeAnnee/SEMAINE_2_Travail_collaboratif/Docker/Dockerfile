FROM alpine

RUN apk add --update --no-cache openssh && ssh-keygen -A \
&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
&& echo "root:dm" | chpasswd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]


#docker build -t <username>/alpine-with-ssh .
#docker run -P -d <username>/alpine-with-ssh
#docker ps # you should see the port that was binded
#ssh -p <port> root@localhost
#root@localhost's password: dm
