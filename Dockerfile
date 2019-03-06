FROM alpine:3.9
USER root

ADD patch.automake patch.automake

RUN \
	echo 'http://dl-cdn.alpinelinux.org/alpine/v3.3/main/' >> /etc/apk/repositories && \
	apk update && \
	apk add --no-cache build-base zlib-dev 'openssl-dev<1.1.1' autoconf linux-headers libsigc++-dev curl-dev xmlrpc-c-dev ncurses-dev &&\
	wget https://ftp.gnu.org/gnu/automake/automake-1.14.1.tar.gz && \
	tar zxf automake-1.14.1.tar.gz && \
	cd automake-1.14.1/ && \
	./configure --prefix=/usr && \
	cd bin && patch < ../../patch.automake && cat automake.in && cd .. && \
	make -j6 &&\
	make install && \
	cd .. && \
	wget http://rtorrent.net/downloads/libtorrent-0.13.7.tar.gz && \
	tar zxf libtorrent-0.13.7.tar.gz && \
	cd libtorrent-0.13.7/ && \
	./configure --prefix=/usr --disable-debug --disable-instrumentation && \
	make -j6 && \
	make install && \
	cd .. && \
	wget http://rtorrent.net/downloads/rtorrent-0.9.7.tar.gz && \
	tar zxf rtorrent-0.9.7.tar.gz && \
	cd rtorrent-0.9.7 && \
	./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --enable-ipv6 --disable-debug --with-xmlrpc-c && \
	make -j6 && \
	make install && \
	cd .. && \
	rm -rf rtorrent-0.9.7 && \
	rm -rf libtorrent-0.13.7 && \
	rm -rf automake-1.14.1 && \
	rm rtorrent-0.9.7.tar.gz && \
	rm libtorrent-0.13.7.tar.gz && \
	rm automake-1.14.1.tar.gz && \
	apk del git build-base autoconf linux-headers  libsigc++-dev curl-dev
	# apk del git build-base zlib-dev openssl-dev autoconf linux-headers libsigc++-dev curl-dev


