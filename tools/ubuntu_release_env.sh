apt-get -y install --no-install-recommends wget gnupg ca-certificates lsb-release
wget -O - https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/openresty.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/openresty.list > /dev/null
apt-get update
apt-get -y install openresty
opm get SkyLothar/lua-resty-jwt
opm get fffonion/lua-resty-openssl
opm get ledgetech/lua-resty-http
opm get GUI/lua-resty-mail

apt-get -y install luajit2

apt-get -y install mariadb-server

apt-get -y install mergerfs

dpkg -i ~/omstor-gateway_1.0.0-1_amd64.deb
/opt/omstor/EC-NAS-API/tools/mysql/init.sh

systemctl daemon-reload
systemctl enable --now boot-setup
