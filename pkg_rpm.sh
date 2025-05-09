TGT_VERSION=1.0.0
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update
PACKAGE_RELEASE=`git rev-list --count HEAD`
PACKAGE_REVERSION=`git rev-parse --short HEAD`

ORG=`pwd`
TGT=ec_nas_api
DIR=$ORG/rpmbuild/$TGT
SRC=/tmp/$TGT-${TGT_VERSION}
TAR=/tmp/$TGT-${TGT_VERSION}.tar.gz


#1# 清理环境
rm -rf $DIR
rm -rf $SRC
rm -rf $TAR

#2# 获取代码
mkdir -p $SRC
cp -r `pwd`/* "$SRC"

cd $SRC
echo ${TGT_VERSION} > /tmp/$TGT-${TGT_VERSION}/VERSION
cd $ORG


#4# 代码打包
tar -czvf $TAR --exclude='./.*' -C /tmp/$TGT-${TGT_VERSION} .


#5# 准备资源
mkdir -p $DIR/{RPMS,SRPMS,BUILD,SOURCES,SPECS}
mv $TAR $DIR/SOURCES/
cp gateway.spec $DIR/SPECS/

#5# 开始打包
home="_topdir $DIR"

eval QA_RPATHS=$[ 0x0002|0x0010 ] rpmbuild --nodebuginfo --define \"$home\" --define \"_version ${TGT_VERSION}\" --define \"_release ${PACKAGE_RELEASE}\" --define \"_reversion ${PACKAGE_REVERSION}\" -vv -ba $DIR/SPECS/gateway.spec
