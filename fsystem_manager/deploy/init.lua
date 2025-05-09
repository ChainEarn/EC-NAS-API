package.path = "/opt/omstor/EC-NAS-API/fsystem_manager/api/?.lua;" .. package.path
package.path = "/opt/omstor/EC-NAS-API/fsystem_manager/conf/?.lua;" .. package.path

local shared_dict = ngx.shared.storehouse
local key = "fm-secret"
local val = "omstor" .. os.time()

shared_dict:set(key, val, 0)
