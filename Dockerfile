# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Source Engine
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        ubuntu:18.04

LABEL       author="Toakan" maintainer="tdaykin@live.co.uk"

ENV         DEBIAN_FRONTEND noninteractive
ENV STEAMAPPID 232250
ENV INSTALLDIR /home/container

# Install Dependencies
RUN set -x \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget=1.20.1-1.1 \
		ca-certificates=20190110 \
		lib32z1=1:1.2.11.dfsg-1 \
		libncurses5:i386=6.1+20181013-2+deb10u2 \
		libbz2-1.0:i386=1.0.6-9.2~deb10u1 \
		lib32gcc1=1:8.3.0-6 \
		lib32stdc++6=8.3.0-6 \
		libtinfo5:i386=6.1+20181013-2+deb10u2 \
		libcurl3-gnutls:i386=7.64.0-4 \
	&& su steam -c \
		"${STEAMCMDDIR}/steamcmd.sh \
			+login anonymous \
			+force_install_dir ${INSTALLDIR} \
			+app_update ${STEAMAPPID} validate \
			+quit \
		&& { \
			echo '@ShutdownOnFailedCommand 1'; \
			echo '@NoPromptForPassword 1'; \
			echo 'login anonymous'; \
			echo 'force_install_dir ${INSTALLDIR}'; \
			echo 'app_update ${STEAMAPPID}'; \
			echo 'quit'; \
		} > ${INSTALLDIR}/tf2_update.txt \
		&& cd ${INSTALLDIR}/tf \
		&& wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvzf - \
		&& wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar xvzf -" \
	&& apt-get remove --purge -y \
		wget \
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
