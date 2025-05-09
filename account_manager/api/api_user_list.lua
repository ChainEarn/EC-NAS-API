local gosay = require('gosay')
local mysql_api = require('mysql_pool_api')
local cjson = require('cjson')
local MSG = require('MSG')
local only = require('only')
local AM_utils = require('AM_utils')

local sql_fmt = {
	user_list = "SELECT username, save_time FROM user_list",
}

local function handle()
	AM_utils.token_check()

	local ok, res = mysql_api.cmd('omstor___omstor_db', 'SELECT', sql_fmt["user_list"])
	if not ok then
		only.log('E','select mysql failed!')
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
		return
	end
	if #res ~= 0 then
		for _, sub in ipairs(res) do
			sub["username"] = AM_utils.get_usr_name(sub["username"])
		end
		local msg = cjson.encode(res)
		gosay.out_message(MSG.fmt_api_message(msg))
	else
		gosay.out_message(MSG.fmt_api_message("[]"))
	end
end

AM_utils.main_call(handle)
