FROM thmhoag/steamcmd:latest

USER root

RUN apt-get update && \
    apt-get install -y curl cron bzip2 perl-modules lsof libc6-i386 lib32gcc1 sudo

RUN curl -sL "https://raw.githubusercontent.com/FezVrasta/ark-server-tools/v1.6.48/netinstall.sh" | bash -s steam && \
    systemctl disable arkmanager.service
    #    ln -s /usr/local/bin/arkmanager /usr/bin/arkmanager

COPY arkmanager/arkmanager.cfg /etc/arkmanager/arkmanager.cfg
COPY arkmanager/instance.cfg /etc/arkmanager/instances/main.cfg
COPY run.sh /home/steam/run.sh
COPY log.sh /home/steam/log.sh

RUN mkdir /ark && \
    chown -R steam:steam /home/steam/ /ark

RUN echo "%sudo   ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers && \
    usermod -a -G sudo steam && \
    touch /home/steam/.sudo_as_admin_successful

WORKDIR /home/steam
USER steam

ENV am_ark_SessionName="Test Ark Server" \
    am_serverMap="TheIsland" \
    am_ark_ServerAdminPassword="admin" \
    am_ark_MaxPlayers=10 \
    am_ark_QueryPort=27016 \
    am_ark_Port=7779 \
    am_ark_RCONPort=32330 \
    am_arkwarnminutes=16

VOLUME /ark

CMD [ "./run.sh" ]
