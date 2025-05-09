DROP USER IF EXISTS 'omstor'@'localhost';

-- 创建新用户并设置密码  
CREATE USER 'omstor'@'localhost' IDENTIFIED BY '123456';  
 
USE omstor_db; 
-- 赋予新用户所有数据库的所有权限  
GRANT ALL PRIVILEGES ON omstor_db.sys_info TO 'omstor'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON omstor_db.disk_list TO 'omstor'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON omstor_db.user_list TO 'omstor'@'localhost' WITH GRANT OPTION;
  
-- 刷新权限，使新设置立即生效  
FLUSH PRIVILEGES;
