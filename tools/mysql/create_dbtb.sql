DROP DATABASE IF EXISTS omstor_db;

-- 创建一个数据库（如果它不存在的话）
CREATE DATABASE IF NOT EXISTS omstor_db;

-- 使用刚刚创建的数据库或已存在的数据库
USE omstor_db;

CREATE TABLE sys_info (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    secret VARCHAR(64) NOT NULL,
    nas_uuid VARCHAR(64) NOT NULL
);

CREATE TABLE disk_list (
    uuid VARCHAR(64) NOT NULL UNIQUE,
    model VARCHAR(128) NOT NULL,
    vendor VARCHAR(128) NOT NULL,
    serial VARCHAR(128) NOT NULL,
    wwn VARCHAR(128) NOT NULL,
    size VARCHAR(32) NOT NULL,
    fstype VARCHAR(12) NOT NULL,
    devtype VARCHAR(12) NOT NULL,
    type VARCHAR(32) NOT NULL
);

CREATE TABLE user_list (
    username VARCHAR(32) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    save_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

