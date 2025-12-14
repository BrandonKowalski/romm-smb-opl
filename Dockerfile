FROM alpine:3.10

ARG USER='user'
ARG PASS='password'
ARG VERSION='4.11'

RUN apk add --no-cache --update \
    sudo \
    ethtool \
    'samba-common-tools<'${VERSION}'' \
    'samba-client<'${VERSION}'' \
    'samba-server<'${VERSION}''

RUN adduser -D -s /bin/ash -u 1000 ${USER} && addgroup ${USER} root
RUN echo ''${USER}' ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo -ne ""${PASS}"\n"${PASS}"\n" | sudo smbpasswd -a -s ${USER}
RUN echo -ne ""${PASS}"\n"${PASS}"\n" | sudo passwd ${USER}
RUN mkdir -p /mnt/ps2smb


USER ${USER}

COPY smb.conf /etc/samba/smb.conf

EXPOSE 445/tcp
EXPOSE 445/udp

CMD ["sudo", "smbd", "--foreground", "--log-stdout", "--no-process-group"]
