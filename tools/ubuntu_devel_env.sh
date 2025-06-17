apt-get -y install --no-install-recommends wget gnupg ca-certificates lsb-release
wget -O - https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/openresty.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/openresty.list > /dev/null
apt-get update
apt-get -y install openresty
opm get SkyLothar/lua-resty-jwt
opm get fffonion/lua-resty-openssl
opm get ledgetech/lua-resty-http
opm get GUI/lua-resty-mail

apt-get -y install dmidecode make gcc autoconf automake libtool pacman lua-basexx luajit2 libluajit2-5.1-dev uuid-dev
apt-get -y install build-essential devscripts dh-make fakeroot lintian

apt-get -y install mariadb-server
apt-get -y install libmariadb-dev

apt-get -y install mergerfs

echo "deb http://archive.ubuntu.com/ubuntu/ focal main universe" >> /etc/apt/sources.list
echo "deb-src http://archive.ubuntu.com/ubuntu/ focal main universe" >> /etc/apt/sources.list
apt-get update
apt-get install dh-systemd

apt-get install net-tools


