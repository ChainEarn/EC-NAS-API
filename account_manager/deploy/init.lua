package.path = "/opt/omstor/EC-NAS-API/account_manager/api/?.lua;" .. package.path
package.path = "/opt/omstor/EC-NAS-API/account_manager/conf/?.lua;" .. package.path

local shared_dict = ngx.shared.storehouse
local key = "am-secret"
local val = "omstor" .. os.time()

shared_dict:set(key, val, 0)
