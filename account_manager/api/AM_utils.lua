local string = require("string")
local only = require('only')
local jwt = require("resty.jwt")
local os = require("os")
local gosay = require('gosay')
local MSG = require('MSG')

------> only use for handle
local function main_call(F, ...)
	ngx.header["Content-Type"] = "application/json"
	local info = { pcall(F, ...) }
	if not info[1] then
		only.log("E", info[2])
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
	end
end

local function admin_sign()
	local shared_dict = ngx.shared.storehouse
	local secret = shared_dict:get("am-secret")
	local expiration_time = os.time() + 3600	--秒

	local jwt_obj = {
		header = {
			typ = "JWT",
			alg = "HS256"
		},
		payload = {
			exp = expiration_time
		}
	}

	local jwt_token = jwt:sign(secret, jwt_obj)
	return jwt_token
end

local function admin_verify(jwt_token)
	local shared_dict = ngx.shared.storehouse
	local secret = shared_dict:get("am-secret")

	local jwt_obj = jwt:verify(secret, jwt_token)
	if not jwt_obj["verified"] then
		only.log('E','token:%s!', jwt_obj["reason"])
		return false
	end
	return true
end

local function token_check()
	local headers = ngx.req.get_headers()
	local authorization_header = headers["Authorization"]
	if not authorization_header then
		gosay.out_status(401)
	end
	local token = string.match(authorization_header, "Bearer (.+)$")
	if not admin_verify(token) then
		gosay.out_status(401)
	end
end

local function reverse_string(str)
	local reversed = {}
	for i = #str, 1, -1 do
		table.insert(reversed, str:sub(i, i))
	end
	return table.concat(reversed)
end

local function reverse_find(str, pattern)
	local str_reversed = reverse_string(str)
	local pattern_reversed = reverse_string(pattern)

	-- 使用 string.find 在逆序字符串中查找逆序模式
	local start_reversed, end_reversed = string.find(str_reversed, pattern_reversed, nil, true)

	if start_reversed then
		-- 计算原始字符串中的起始和结束位置
		local start_original = #str - end_reversed + 1
		local end_original = #str - start_reversed + 1
		return start_original, end_original
	else
		return nil -- 未找到匹配项
	end
end

local function get_usr_name(sys_name)
	-- 从字符串末尾开始搜索 ..
	local pos = reverse_find(sys_name, "..", nil, true)
	if pos then
		sys_name = string.sub(sys_name, 1, pos - 1) .. "@" .. string.sub(sys_name, pos + 2)
	end
	return sys_name
end

local function get_sys_name(usr_name)
	usr_name = string.gsub(usr_name, "@", "..")
	return usr_name
end


return {
	main_call = main_call,
	admin_sign = admin_sign,
	token_check = token_check,
	get_usr_name = get_usr_name,
	get_sys_name = get_sys_name,
}
