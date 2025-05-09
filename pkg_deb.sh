#!/bin/bash

# 设置项目名称和版本
PROJECT_NAME="ec_nas_api"
VERSION="1.0.0"
ARCHITECTURE="amd64"  # 根据您的系统架构设置，如 amd64 或 i386

# 安装必要的工具
#apt-get install -y build-essential devscripts dh-make fakeroot lintian dh-systemd

# 创建构建目录
BUILD_DIR="/tmp/${PROJECT_NAME}-${VERSION}"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# 复制源代码到构建目录
cp -r `pwd`/* "$BUILD_DIR"

# 进入构建目录
cd "$BUILD_DIR"
cp ./gateway_cfg.lua ./cfg.lua

# 初始化 Debian 打包结构，使用 'expat'（MIT许可证）
DEBFULLNAME="vgfree" DEBEMAIL="vgfree@omstor.com" dh_make --createorig -s -c expat -y

# 修改 debian/control 文件
sed -i "s/^Package: .*/Package: $PROJECT_NAME/" debian/control
sed -i "s/^Version: .*/Version: $VERSION/" debian/control
sed -i "s/^Section: .*/Section: admin/" debian/control
sed -i "s/^Maintainer: .*/Maintainer: vgfree <qhqvgfree@gmail.com>/" debian/control
sed -i "s/^Architecture: .*/Architecture: $ARCHITECTURE/" debian/control
sed -i "s/^Homepage: .*/Homepage: www.omstor.com/" debian/control
sed -i "s/^Description: .*/Description: Omstor gateway /" debian/control

cat > debian/postinst << EOF
#!/bin/bash
cp -f /opt/data/etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/
cp -f /opt/data/usr/local/openresty/nginx/conf/gateway_nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
EOF
chmod +x debian/postinst

# 创建安装文件列表
echo "./tools/mysql/mariadb-server.cnf /opt/data/etc/my.cnf.d/" >> debian/install
echo "./gateway_nginx.conf /opt/data/usr/local/openresty/nginx/conf/" >> debian/install
echo "./tools/boot-setup.sh /usr/sbin/" >> debian/install
echo "./tools/boot-setup.service /usr/lib/systemd/system/" >> debian/install

echo "./cfg.lua /opt/omstor/EC-NAS-API/" >> debian/install
echo "./account_manager/api/* /opt/omstor/EC-NAS-API/account_manager/api/" >> debian/install
echo "./account_manager/conf/* /opt/omstor/EC-NAS-API/account_manager/conf/" >> debian/install
echo "./account_manager/deploy/* /opt/omstor/EC-NAS-API/account_manager/deploy/" >> debian/install
echo "./storage_manager/api/* /opt/omstor/EC-NAS-API/storage_manager/api/" >> debian/install
echo "./storage_manager/conf/* /opt/omstor/EC-NAS-API/storage_manager/conf/" >> debian/install
echo "./storage_manager/deploy/* /opt/omstor/EC-NAS-API/storage_manager/deploy/" >> debian/install
echo "./fsystem_manager/api/* /opt/omstor/EC-NAS-API/fsystem_manager/api/" >> debian/install
echo "./fsystem_manager/conf/* /opt/omstor/EC-NAS-API/fsystem_manager/conf/" >> debian/install
echo "./fsystem_manager/deploy/* /opt/omstor/EC-NAS-API/fsystem_manager/deploy/" >> debian/install

echo "./open/public/MSG.lua /opt/omstor/EC-NAS-API/open/public/" >> debian/install
echo "./open/ngxstep/ngx_init.lua /opt/omstor/EC-NAS-API/open/ngxstep/" >> debian/install
echo "./open/ngxstep/ngx_log.lua /opt/omstor/EC-NAS-API/open/ngxstep/" >> debian/install
echo "./open/ngxstep/ngx_rewrite.lua /opt/omstor/EC-NAS-API/open/ngxstep/" >> debian/install
echo "./open/ngxonly/cache.lua /opt/omstor/EC-NAS-API/open/ngxonly/" >> debian/install
echo "./open/ngxonly/gosay.lua /opt/omstor/EC-NAS-API/open/ngxonly/" >> debian/install
echo "./open/ngxonly/link.lua /opt/omstor/EC-NAS-API/open/ngxonly/" >> debian/install
echo "./open/ngxonly/logs.lua /opt/omstor/EC-NAS-API/open/ngxonly/" >> debian/install
echo "./open/ngxonly/only.lua /opt/omstor/EC-NAS-API/open/ngxonly/" >> debian/install
echo "./open/ngxonly/perf.lua /opt/omstor/EC-NAS-API/open/ngxonly/" >> debian/install
echo "./open/linkup/http_short_api.lua /opt/omstor/EC-NAS-API/open/linkup/" >> debian/install
echo "./open/linkup/lhttp_pool_api.lua /opt/omstor/EC-NAS-API/open/linkup/" >> debian/install
echo "./open/linkup/mysql_pool_api.lua /opt/omstor/EC-NAS-API/open/linkup/" >> debian/install
echo "./open/linkup/mysql_short_api.lua /opt/omstor/EC-NAS-API/open/linkup/" >> debian/install
echo "./open/linkup/redis_pool_api.lua /opt/omstor/EC-NAS-API/open/linkup/" >> debian/install
echo "./open/linkup/redis_short_api.lua /opt/omstor/EC-NAS-API/open/linkup/" >> debian/install
echo "./open/linkup/ssdb.lua /opt/omstor/EC-NAS-API/open/linkup/" >> debian/install
echo "./open/linkup/zmq_api.lua /opt/omstor/EC-NAS-API/open/linkup/" >> debian/install
echo "./open/lib/luasql/mysql.so /opt/omstor/EC-NAS-API/open/lib/luasql/" >> debian/install
echo "./open/lib/conhash.so /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/cutils.so /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/lualog.so /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/lfs.so /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/socket.so /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/socket.lua /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/queue.lua /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/scan.lua /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/redis.lua /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./open/lib/sys.lua /opt/omstor/EC-NAS-API/open/lib/" >> debian/install
echo "./tools/mysql/create_dbtb.sql /opt/omstor/EC-NAS-API/tools/mysql/" >> debian/install
echo "./tools/mysql/create_user.sql /opt/omstor/EC-NAS-API/tools/mysql/" >> debian/install
echo "./tools/mysql/init.sh /opt/omstor/EC-NAS-API/tools/mysql/" >> debian/install
echo "./tools/ec_nas_api.sh /opt/omstor/EC-NAS-API/tools/" >> debian/install

# 修改 debian/rules 文件
sed -i '/dh \$@/d' debian/rules
sed -i '/^%:/a\override_dh_auto_clean:\n\tmake -C open/lib/ clean' debian/rules
sed -i '/^%:/a\override_dh_auto_build:\n\tmake -C open/lib/' debian/rules
sed -i '/^%:/a\\tdh \$@' debian/rules

# 构建 .deb 包
debuild clean
debuild -us -uc
#dpkg-buildpackage -us -uc -ui

# 检查包的质量
#lintian ../${PROJECT_NAME}_${VERSION}-1_${ARCHITECTURE}.deb

# 安装生成的 .deb 包
echo dpkg -i /tmp/${PROJECT_NAME}_${VERSION}-1_${ARCHITECTURE}.deb

# 清理构建目录
cd ..
#rm -rf "$BUILD_DIR"

echo /tmp/${PROJECT_NAME}_${VERSION}-1_${ARCHITECTURE}.deb
echo "构建完成，.deb 包已安装。"

