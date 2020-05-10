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
		wget tar curl \
		wget=1.20.1-1.1 \
		ca-certificates \
		lib32z1 \
		libncurses5:i386 \
		libbz2-1.0:i386 \
		lib32gcc1 \
		lib32stdc++6 \
		libtinfo5:i386 \
		libcurl3-gnutls:i386 \
		libfontconfig telnet net-tools netcat \
    && su steam -c \
		"${STEAMCMDDIR}/steamcmd.sh \
			+login anonymous \
			+force_install_dir ${STEAMAPPDIR} \
			+app_update ${STEAMAPPID} validate \
			+quit \
	&& cd ${STEAMAPPDIR}/tf \
	&& wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvzf - \
	&& wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar xvzf - "


USER        steam
ENV         HOME $STEAMAPPDIR
WORKDIR     $STEAMAPPDIR

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
