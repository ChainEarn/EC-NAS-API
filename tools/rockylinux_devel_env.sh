dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf install https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm
dnf install https://mirrors.aliyun.com/rpmfusion/free/el/rpmfusion-free-release-9.noarch.rpm
dnf install wget
wget https://openresty.org/package/centos/openresty2.repo -O /etc/yum.repos.d/openresty.repo
dnf repolist --all
dnf config-manager --set-enabled crb
dnf install vim
cat > ~/.vimrc << EOF
set termencoding=utf-8
set fileformats=unix
EOF
dnf install -y dmidecode rpm-build make gcc autoconf automake libtool pacman fakeroot lua-basexx luajit-devel shadow util-linux openssl pcp-system-tools net-tools libuuid-devel libdb-utils
dnf install xfsprogs

dnf install openresty openresty-opm
opm get SkyLothar/lua-resty-jwt
opm get fffonion/lua-resty-openssl
opm get agentzh/lua-resty-http
opm get GUI/lua-resty-mail

dnf install mariadb-server
dnf install mariadb-devel
#mysql_secure_installation
systemctl start mariadb


dnf install git
git config --global --add safe.directory `pwd`

dnf install systemd-udev

dnf localinstall ~/mergerfs-1.0.0-1.el9.x86_64.rpm
dnf localinstall ~/csdo-1.0.0-4.7951c09.el9.x86_64.rpm
