登入管理中心
=================================

### API编号

### 功能简介
* 登入管理中心

### 参数格式

* 所有 API 都以 **GET/POST/DELETE** 方式请求，且传送方式为 **key-value键值对**.

### 输入参数


 参数           |参数说明                 |  类型       |   示例         |是否允许为空|  限制条件
----------------|-------------------------|-------------|----------------|------------|---------------------
secret          |管理员密码               |string       |默认密码:123456 |否          |无


### 示例代码

    POST /accountManager/v1/adminLogin HTTP/1.0
    Host:127.0.0.1:8090
    Content-Length:19
    Content-Type:application/json

    {"secret":"123456"}

### 返回body示例

* 失败: `{"ERRORCODE":20002, "RESULT":"secret is wrong!"}`
* 成功: `{"ERRORCODE":0, "RESULT":{"nas_uuid":"85266380-0d6c-11f0-b017-ca0b50cd1200","token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3NDY3ODM2NjZ9.KuEyHIrUEHeA9eiqsgseseJ6pqadASYC4J7ZGHn3_fM"}}`


### 返回结果参数

参数            | 参数说明
----------------|-------------------------------
token           | 授权码
nas_uuid        | 机器码

### 错误编码

错误编码    | 错误描述                  | 解决办法
------------|---------------------------|------------------
0           | Request OK                |
10000       | 参数错误                  | 请检查输入参数
10001       | 系统内部错误              | 请与公司客服联系
20002       | 管理员密码错误            | 请检查输入参数

### 测试地址: 127.0.0.1

