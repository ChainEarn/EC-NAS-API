# EC-NAS Gateway API

This repository contains the **Gateway API service for EC-NAS**, built on top of [OpenResty](https://openresty.org/).  
It is designed to provide API endpoints for EC-NAS-GUI and acts as a gateway to the underlying storage service.

---

## 📌 Overview

- Provides RESTful API services for EC-NAS-GUI
- Bridges the frontend GUI and backend storage logic
- Built with OpenResty for high-performance HTTP services and Lua-based extensibility

---

## 📦 Packaging

Use the corresponding script depending on your Linux distribution:

### Fedora

```bash
/bin/bash tools/rockylinux_devel_env.sh
/bin/bash pkg_rpm.sh
````

### Ubuntu

```bash
/bin/bash tools/ubuntu_devel_env.sh
/bin/bash pkg_deb.sh
```

---

## 🛠 Installation

### On Fedora:

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

### On Ubuntu:

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

## 🔧 Dependencies

* OpenResty >= 1.21
* Lua scripting support (provided by OpenResty)

* csdo
* get from https://github.com/vgfree/csdo.git
---

## 📁 Project Structure (optional)

```
EC-NAS-Gateway-API/
├── account_manager/     # Account manager
├── fsystem_manager/     # File system manager
├── storage_manager/     # Storage manager
├── pkg_deb.sh           # Packaging script for Ubuntu
├── pkg_rpm.sh           # Packaging script for Fedora
├── README.md            # Project english documentation
├── README_cn.md         # Project chinese documentation
└── ...
```

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙋‍♂️ Contact

Feel free to open an [issue](https://github.com/ChainEarn/EC-NAS-API/issues) or submit a pull request if you have any questions or suggestions.



