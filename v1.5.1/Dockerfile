FROM fedora:latest
MAINTAINER Gian-Luca Casella <gcasella@casellanetworks.ca>
ENV container docker
ENV HOSTNAME gns3-docker

#Create Service File to start GNS3 server on-boot
COPY    vpcs /usr/local/bin/vpcs
COPY    gns3_server.conf /opt/gns3/.config/gns3_server.conf
COPY    iourc /opt/gns3/.license/.iourc
COPY    hostid.sh /tmp/hostid.sh
COPY    gns3.sh /etc/init.d/gns3

#Create GNS3 Users for Service;
RUN 	mkdir -p /opt/gns3/.log/ && \
	mkdir /opt/gns3/images/ && \
	mkdir /opt/gns3/symbols/ && \
	mkdir /opt/gns3/configs/ && \
	mkdir /opt/gns3/projects/ && \
	mkdir /opt/gns3/.pid/ && \
	'root:gns3' | chpasswd && \
	chmod +x /usr/local/bin/vpcs && \
        chmod +x /tmp/hostid.sh && \
	/tmp/hostid.sh 030a035b && \
	chmod +x /etc/init.d/gns3

#Install Docker v1.10.3 binaries.

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.10.3
ENV DOCKER_SHA256 d0df512afa109006a450f41873634951e19ddabf8c7bd419caeb5a526032d86d

RUN curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION" -o /usr/local/bin/docker \
	&& echo "${DOCKER_SHA256}  /usr/local/bin/docker" | sha256sum -c - \
	&& chmod +x /usr/local/bin/docker

#Perform system update and install necessary packages for GNS3 Server 1.5+
RUN dnf --setopt=deltarpm=false update -y && dnf --best --allowerasing --setopt=deltarpm=false install redhat-rpm-config \
	openssl-libs.i686 \
#	openssl-devel.i686 \
#	openssl-devel \
	cmake \
	iniparser \
	iniparser-devel \
	python3-devel \
	git \
	uuid \
	uuid-devel \
	procps-ng \
	elfutils-libelf-devel \
	net-tools \
	iputils \
	wget \
	x11vnc \
	tar \
	qemu-kvm \
	qemu-img \
	bison \
	flex \
	libpcap libpcap-devel -y && \
	dnf --setopt=deltarpm=false --best --allowerasing group install "Development Tools" -y && \ 
	
	dnf mark install redhat-rpm-config \
        openssl-libs.i686 \
#        openssl-devel.i686 \
#        openssl-devel \
#        cmake \
#        iniparser \
#        iniparser-devel \
        python3-devel \
#        git \
        uuid \
	x11vnc \
        uuid-devel \
        procps-ng \
        elfutils-libelf-devel \
        net-tools \
        iputils \
        wget \
#        tar \
        qemu-kvm \
        qemu-img \
#        bison \
#        flex \
        libpcap libpcap-devel && \

	# Download and install source code from github fror dynamips, ubridge, iouyap
	mkdir /usr/src/gns3/ && \
	cd /usr/src/gns3/ && \
	git clone https://github.com/gns3/dynamips && \
	git clone https://github.com/gns3/ubridge && \
	git clone https://github.com/gns3/iouyap && \
	cd /usr/src/gns3/dynamips && \
	mkdir build/ && \
	cd build/ && \
	cmake .. && \
	make && \
	make install && \
	cd /usr/src/gns3/iouyap && \
	make && \
	make install && \
	cd /usr/src/gns3/ubridge && \
	make && \
	make install && \
	whereis ubridge && \
	cd ~/ && \
	rm -rf /usr/src/gns3/* && \

	pip3 install pip --upgrade && \
	pip3 install setuptools --upgrade && \

	pip3 install gns3-server --upgrade && \

# CLEAN UP
	dnf group remove "Development Tools" -y && \
	dnf autoremove -y && \
	dnf clean all && \

        localedef --list-archive | grep -v -i ^en_US | xargs localedef --delete-from-archive && \
        mv -f /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.tmpl && \
        build-locale-archive && \
	rm -rf /var/cache/dnf/* && \
	rm -rf /usr/share/doc && \
	rm -rf /usr/share/locale/* && \
	rm -rf /usr/share/man/* && \
	rm -rf /usr/local/share/man/* && \
	rm -rf /var/tmp/* && \
	setcap cap_net_raw,cap_net_admin+p /usr/bin/ping

EXPOSE 3080
WORKDIR /opt/gns3/
# Load script to start GNS3 and Docker Daemon at the same time
ENTRYPOINT ["/etc/init.d/gns3"]
