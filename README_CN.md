# EC-NAS Gateway API

本仓库是 **EC-NAS 的 Gateway API 服务**，基于 [OpenResty](https://openresty.org/) 构建，主要用于为 EC-NAS-GUI 提供 API 接口调用能力，并对接底层存储服务，起到网关和服务中转的作用。

---

## 📌 项目功能简介

- 为 EC-NAS-GUI 提供统一的 API 接口服务
- 对接后端存储系统，实现控制与数据请求分离
- 基于 OpenResty 提供高性能 HTTP 接口和 Lua 扩展能力

---

## 📦 打包方式

请根据所使用的 Linux 发行版选择相应打包脚本：

### Fedora 系统

```bash
/bin/bash tools/rockylinux_devel_env.sh
/bin/bash pkg_rpm.sh
````

### Ubuntu 系统

```bash
/bin/bash tools/ubuntu_devel_env.sh
/bin/bash pkg_deb.sh
```

---

## 🛠 安装方式

### Fedora 安装步骤：

```bash
/bin/bash tools/rockylinux_release_env.sh
dnf install -y ./csdo*.rpm
dnf install -y ./mergerfs*.rpm
dnf install -y ./ec_nas_api*.rpm
/opt/omstor/EC-NAS-API/tools/mysql/init.sh
/opt/omstor/EC-NAS-API/tools/ec_nas_api.sh start

dnf install -y ./boot-setup*.rpm
systemctl daemon-reload
systemctl enable --now boot-setup
```

### Ubuntu 安装步骤：

```bash
/bin/bash tools/ubuntu_release_env.sh
apt-get install -y ./csdo*.deb
apt-get install -y ./ec_nas_api*.deb
/opt/omstor/EC-NAS-API/tools/mysql/init.sh
/opt/omstor/EC-NAS-API/tools/ec_nas_api.sh start

apt-get install -y ./boot-setup*.deb
systemctl daemon-reload
systemctl enable --now boot-setup
```

---

## 🔧 依赖环境

* OpenResty >= 1.21
* Lua 脚本解释支持（由 OpenResty 提供）

* csdo
* 源码在 https://github.com/vgfree/csdo.git
---

## 📁 目录结构示例（可选）

```
EC-NAS-Gateway-API/
├── account_manager/     # 账号管理
├── fsystem_manager/     # 文件管理
├── storage_manager/     # 存储管理
├── pkg_deb.sh           # Ubuntu 打包脚本
├── pkg_rpm.sh           # Fedora 打包脚本
├── README.md            # 项目英文说明文档
├── README_cn.md         # 项目中文说明文档
└── ...
```

---

## 📄 许可证

本项目采用 MIT License 开源协议。

---

## 🙋‍♂️ 联系我们

如有问题或建议，欢迎提交 [Issue](https://github.com/ChainEarn/EC-NAS-API/issues) 或发起 Pull Request！



