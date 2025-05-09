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
/bin/bash pkg_rpm.sh
````

### Ubuntu

```bash
/bin/bash pkg_deb.sh
```

---

## 🛠 Installation

### On Fedora:

```bash
dnf install openresty
dnf install ./ec_nas_api*.rpm
/opt/omstor/EC-NAS-API/tools/mysql/init.sh
/opt/omstor/EC-NAS-API/tools/ec_nas_api.sh start
```

### On Ubuntu:

```bash
apt-get install openresty
apt-get install ./ec_nas_api*.deb
/opt/omstor/EC-NAS-API/tools/mysql/init.sh
/opt/omstor/EC-NAS-API/tools/ec_nas_api.sh start
```

---

## 🔧 Dependencies

* OpenResty >= 1.21
* Lua scripting support (provided by OpenResty)

---

## 📁 Project Structure (optional)

```
EC-NAS-Gateway-API/
├── account_manager/     # account manager
├── fsystem_manager/     # file system manager
├── storage_manager/     # storage manager
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



