dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm
dnf install -y https://mirrors.aliyun.com/rpmfusion/free/el/rpmfusion-free-release-9.noarch.rpm
dnf install -y wget
wget https://openresty.org/package/centos/openresty2.repo -O /etc/yum.repos.d/openresty.repo
dnf repolist --all
dnf config-manager --set-enabled crb
dnf install -y vim
cat > ~/.vimrc << EOF
set termencoding=utf-8
set fileformats=unix
EOF
dnf install -y dmidecode
dnf install -y xfsprogs

dnf install -y openresty openresty-opm
opm get SkyLothar/lua-resty-jwt
opm get fffonion/lua-resty-openssl
opm get ledgetech/lua-resty-http
opm get GUI/lua-resty-mail

dnf install -y mariadb-server
dnf install -y mariadb-devel
#mysql_secure_installation
systemctl start mariadb


dnf install -y systemd-udev
