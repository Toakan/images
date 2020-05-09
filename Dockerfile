# ----------------------------------
# Team Fortress 2 | Sourcemod Addon Files
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        cm2network/steamcmd:root
LABEL       author="Toakan" maintainer="tdaykin@live.co.uk"
ENV         DEBIAN_FRONTEND noninteractive
ENV STEAMAPPID 232250
ENV STEAMAPPDIR /home/steam/tf2-dedicated

# Install Dependencies
RUN set -x \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget tar curl gcc g++ lib32gcc1 libgcc1 libcurl4-gnutls-dev:i386 libssl1.0.0:i386 libcurl4:i386 lib32tinfo5 libtinfo5:i386 lib32z1 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 iproute2 gdb libsdl1.2debian libfontconfig telnet net-tools netcat \
    && su steam -c \
		"steamcmd \
			+login anonymous \
			+force_install_dir ${STEAMAPPDIR} \
			+app_update ${STEAMAPPID} validate \
			+quit \
	&& cd ${STEAMAPPDIR}/tf \
	&& wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvzf - \
	&& wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar xvzf - "\
	&& apt-get remove --purge -y \
		wget tar curl\
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

USER        steam
ENV         HOME $STEAMAPPDIR
WORKDIR     $STEAMAPPDIR

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
