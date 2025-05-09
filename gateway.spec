%{!?_version: %define _version 0}
%{!?_release: %define _release 0}
%{!?_reversion: %define _reversion "000000"}

Name:           ec_nas_api
Version:        %{_version}
Release:        %{_release}.%{_reversion}%{?dist}
License:        GPLv2 and GPLv2+ and LGPLv2+
Group:          ChainEarn
Summary:        gateway of omstor
Source:         ec_nas_api-%{version}.tar.gz

BuildRequires:  luajit-devel >= 2.1.0

Requires:       mariadb-server
Requires:       csdo
Requires:       openresty
Requires:       openresty-opm

# Patch0: 0001-foo.patch

%if 0%{?rhel}
ExclusiveArch: i686 x86_64 s390x ppc64le aarch64
%endif

%description
ec_nas_api is depend on openresty.

%prep
%setup -c -q -n ec_nas_api-%{version}

# %patch0 -p1 -b .0001-foo.patch

%build
CFLAGS=$RPM_OPT_FLAGS make -C open/lib/

%install
# install -Dm 0644 xxx.conf %{buildroot}/etc/xxx.conf
mkdir -p %{buildroot}/opt/data/etc/my.cnf.d/
install -Dm 0644 tools/mysql/mariadb-server.cnf %{buildroot}/opt/data/etc/my.cnf.d/mariadb-server.cnf
mkdir -p %{buildroot}/opt/data/usr/local/openresty/nginx/conf/
install -Dm 0644 gateway_nginx.conf %{buildroot}/opt/data/usr/local/openresty/nginx/conf/nginx.conf
install -Dm 0755 tools/boot-setup.sh %{buildroot}/usr/sbin/boot-setup.sh
install -Dm 0644 tools/boot-setup.service %{buildroot}/usr/lib/systemd/system/boot-setup.service

mkdir -p %{buildroot}/opt/omstor/EC-NAS-API
install -Dm 0644 gateway_cfg.lua %{buildroot}/opt/omstor/EC-NAS-API/cfg.lua
mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/account_manager/
cp -r account_manager/api %{buildroot}/opt/omstor/EC-NAS-API/account_manager/
cp -r account_manager/conf %{buildroot}/opt/omstor/EC-NAS-API/account_manager/
cp -r account_manager/deploy %{buildroot}/opt/omstor/EC-NAS-API/account_manager/
mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/storage_manager/
cp -r storage_manager/api %{buildroot}/opt/omstor/EC-NAS-API/storage_manager/
cp -r storage_manager/conf %{buildroot}/opt/omstor/EC-NAS-API/storage_manager/
cp -r storage_manager/deploy %{buildroot}/opt/omstor/EC-NAS-API/storage_manager/
mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/fsystem_manager/
cp -r fsystem_manager/api %{buildroot}/opt/omstor/EC-NAS-API/fsystem_manager/
cp -r fsystem_manager/conf %{buildroot}/opt/omstor/EC-NAS-API/fsystem_manager/
cp -r fsystem_manager/deploy %{buildroot}/opt/omstor/EC-NAS-API/fsystem_manager/

mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/open/public
install -Dm 0644 open/public/MSG.lua %{buildroot}/opt/omstor/EC-NAS-API/open/public/MSG.lua
mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/open/ngxstep
install -Dm 0644 open/ngxstep/ngx_init.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxstep/ngx_init.lua
install -Dm 0644 open/ngxstep/ngx_log.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxstep/ngx_log.lua
install -Dm 0644 open/ngxstep/ngx_rewrite.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxstep/ngx_rewrite.lua
mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/open/ngxonly
install -Dm 0644 open/ngxonly/cache.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxonly/cache.lua
install -Dm 0644 open/ngxonly/gosay.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxonly/gosay.lua
install -Dm 0644 open/ngxonly/link.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxonly/link.lua
install -Dm 0644 open/ngxonly/logs.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxonly/logs.lua
install -Dm 0644 open/ngxonly/only.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxonly/only.lua
install -Dm 0644 open/ngxonly/perf.lua %{buildroot}/opt/omstor/EC-NAS-API/open/ngxonly/perf.lua
mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/open/linkup
install -Dm 0644 open/linkup/http_short_api.lua %{buildroot}/opt/omstor/EC-NAS-API/open/linkup/http_short_api.lua
install -Dm 0644 open/linkup/lhttp_pool_api.lua %{buildroot}/opt/omstor/EC-NAS-API/open/linkup/lhttp_pool_api.lua
install -Dm 0644 open/linkup/mysql_pool_api.lua %{buildroot}/opt/omstor/EC-NAS-API/open/linkup/mysql_pool_api.lua
install -Dm 0644 open/linkup/mysql_short_api.lua %{buildroot}/opt/omstor/EC-NAS-API/open/linkup/mysql_short_api.lua
install -Dm 0644 open/linkup/redis_pool_api.lua %{buildroot}/opt/omstor/EC-NAS-API/open/linkup/redis_pool_api.lua
install -Dm 0644 open/linkup/redis_short_api.lua %{buildroot}/opt/omstor/EC-NAS-API/open/linkup/redis_short_api.lua
install -Dm 0644 open/linkup/ssdb.lua %{buildroot}/opt/omstor/EC-NAS-API/open/linkup/ssdb.lua
install -Dm 0644 open/linkup/zmq_api.lua   %{buildroot}/opt/omstor/EC-NAS-API/open/linkup/zmq_api.lua
mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/open/lib/luasql
install -Dm 0644 open/lib/luasql/mysql.so %{buildroot}/opt/omstor/EC-NAS-API/open/lib/luasql/mysql.so
install -Dm 0644 open/lib/conhash.so %{buildroot}/opt/omstor/EC-NAS-API/open/lib/conhash.so
install -Dm 0644 open/lib/cutils.so %{buildroot}/opt/omstor/EC-NAS-API/open/lib/cutils.so
install -Dm 0644 open/lib/lualog.so %{buildroot}/opt/omstor/EC-NAS-API/open/lib/lualog.so
install -Dm 0644 open/lib/lfs.so %{buildroot}/opt/omstor/EC-NAS-API/open/lib/lfs.so
install -Dm 0644 open/lib/socket.so %{buildroot}/opt/omstor/EC-NAS-API/open/lib/socket.so
install -Dm 0644 open/lib/socket.lua %{buildroot}/opt/omstor/EC-NAS-API/open/lib/socket.lua
install -Dm 0644 open/lib/queue.lua %{buildroot}/opt/omstor/EC-NAS-API/open/lib/queue.lua
install -Dm 0644 open/lib/scan.lua %{buildroot}/opt/omstor/EC-NAS-API/open/lib/scan.lua
install -Dm 0644 open/lib/redis.lua %{buildroot}/opt/omstor/EC-NAS-API/open/lib/redis.lua
install -Dm 0644 open/lib/sys.lua %{buildroot}/opt/omstor/EC-NAS-API/open/lib/sys.lua

mkdir -p %{buildroot}/opt/omstor/EC-NAS-API/tools/mysql
install -Dm 0644 tools/mysql/create_dbtb.sql %{buildroot}/opt/omstor/EC-NAS-API/tools/mysql/create_dbtb.sql
install -Dm 0644 tools/mysql/create_user.sql %{buildroot}/opt/omstor/EC-NAS-API/tools/mysql/create_user.sql
install -Dm 0644 tools/mysql/init.sh %{buildroot}/opt/omstor/EC-NAS-API/tools/mysql/init.sh
install -Dm 0644 tools/ec_nas_api.sh %{buildroot}/opt/omstor/EC-NAS-API/tools/ec_nas_api.sh

%post
# TODO: need save
cp -f /opt/data/etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
cp -f /opt/data/usr/local/openresty/nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

%preun
rm -rf /opt/omstor/EC-NAS-API

%postun
# $1为0是卸载，1为更新
if [ "$1" = "0" ] ; then
	rm -rf /opt/omstor/EC-NAS-API
fi

%files
%defattr(0755,root,root,-)
/opt/data/etc/my.cnf.d/mariadb-server.cnf
/opt/data/usr/local/openresty/nginx/conf/nginx.conf
/usr/sbin/boot-setup.sh
/usr/lib/systemd/system/boot-setup.service
/opt/omstor/EC-NAS-API/cfg.lua
/opt/omstor/EC-NAS-API/account_manager/api/AM_utils.lua
/opt/omstor/EC-NAS-API/account_manager/api/api_admin_login.lua
/opt/omstor/EC-NAS-API/account_manager/api/api_admin_modify.lua
/opt/omstor/EC-NAS-API/account_manager/api/api_user_create.lua
/opt/omstor/EC-NAS-API/account_manager/api/api_user_list.lua
/opt/omstor/EC-NAS-API/account_manager/api/api_user_remove.lua
/opt/omstor/EC-NAS-API/account_manager/conf/account_manager_cfg.lua
/opt/omstor/EC-NAS-API/account_manager/deploy/init.lua
/opt/omstor/EC-NAS-API/account_manager/deploy/link.lua
/opt/omstor/EC-NAS-API/account_manager/deploy/ngxapi.conf
/opt/omstor/EC-NAS-API/fsystem_manager/api/FM_utils.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_get_user_token.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_clear.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_create.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_delete.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_info.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_pull.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_push.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_rename.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_slice_complete.lua
/opt/omstor/EC-NAS-API/fsystem_manager/api/api_opt_slice_push.lua
/opt/omstor/EC-NAS-API/fsystem_manager/conf/fsystem_manager_cfg.lua
/opt/omstor/EC-NAS-API/fsystem_manager/deploy/init.lua
/opt/omstor/EC-NAS-API/fsystem_manager/deploy/link.lua
/opt/omstor/EC-NAS-API/fsystem_manager/deploy/ngxapi.conf
/opt/omstor/EC-NAS-API/storage_manager/api/SM_utils.lua
/opt/omstor/EC-NAS-API/storage_manager/api/api_get_usable_disk.lua
/opt/omstor/EC-NAS-API/storage_manager/api/api_pool_disk_append.lua
/opt/omstor/EC-NAS-API/storage_manager/api/api_pool_disk_list.lua
/opt/omstor/EC-NAS-API/storage_manager/api/api_pool_disk_remove.lua
/opt/omstor/EC-NAS-API/storage_manager/conf/storage_manager_cfg.lua
/opt/omstor/EC-NAS-API/storage_manager/deploy/init.lua
/opt/omstor/EC-NAS-API/storage_manager/deploy/link.lua
/opt/omstor/EC-NAS-API/storage_manager/deploy/ngxapi.conf

/opt/omstor/EC-NAS-API/open/public/MSG.lua
/opt/omstor/EC-NAS-API/open/ngxstep/ngx_init.lua
/opt/omstor/EC-NAS-API/open/ngxstep/ngx_log.lua
/opt/omstor/EC-NAS-API/open/ngxstep/ngx_rewrite.lua
/opt/omstor/EC-NAS-API/open/ngxonly/cache.lua
/opt/omstor/EC-NAS-API/open/ngxonly/gosay.lua
/opt/omstor/EC-NAS-API/open/ngxonly/link.lua
/opt/omstor/EC-NAS-API/open/ngxonly/logs.lua
/opt/omstor/EC-NAS-API/open/ngxonly/only.lua
/opt/omstor/EC-NAS-API/open/ngxonly/perf.lua
/opt/omstor/EC-NAS-API/open/linkup/http_short_api.lua
/opt/omstor/EC-NAS-API/open/linkup/lhttp_pool_api.lua
/opt/omstor/EC-NAS-API/open/linkup/mysql_pool_api.lua
/opt/omstor/EC-NAS-API/open/linkup/mysql_short_api.lua
/opt/omstor/EC-NAS-API/open/linkup/redis_pool_api.lua
/opt/omstor/EC-NAS-API/open/linkup/redis_short_api.lua
/opt/omstor/EC-NAS-API/open/linkup/ssdb.lua
/opt/omstor/EC-NAS-API/open/linkup/zmq_api.lua
/opt/omstor/EC-NAS-API/open/lib/luasql/mysql.so
/opt/omstor/EC-NAS-API/open/lib/conhash.so
/opt/omstor/EC-NAS-API/open/lib/cutils.so
/opt/omstor/EC-NAS-API/open/lib/lualog.so
/opt/omstor/EC-NAS-API/open/lib/lfs.so
/opt/omstor/EC-NAS-API/open/lib/socket.so
/opt/omstor/EC-NAS-API/open/lib/socket.lua
/opt/omstor/EC-NAS-API/open/lib/queue.lua
/opt/omstor/EC-NAS-API/open/lib/scan.lua
/opt/omstor/EC-NAS-API/open/lib/redis.lua
/opt/omstor/EC-NAS-API/open/lib/sys.lua
/opt/omstor/EC-NAS-API/tools/mysql/create_dbtb.sql
/opt/omstor/EC-NAS-API/tools/mysql/create_user.sql
/opt/omstor/EC-NAS-API/tools/mysql/init.sh
/opt/omstor/EC-NAS-API/tools/ec_nas_api.sh

%changelog

