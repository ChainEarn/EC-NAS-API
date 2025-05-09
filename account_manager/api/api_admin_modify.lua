local mysql_api = require('mysql_pool_api')
local cjson = require("cjson")
local gosay = require('gosay')
local MSG = require('MSG')
local only = require('only')
local AM_utils = require('AM_utils')

local sql_fmt = {
	one_info = "SELECT * FROM sys_info WHERE id=1",
	one_update = "UPDATE sys_info SET secret='%s' WHERE id=1",
}

local function check_args(args)
end

local function handle()
	AM_utils.token_check()

	local args = ngx.req.get_uri_args()

	-->> 1)检查参数
	check_args(args)

	local body = ngx.req.get_body_data()
	local res = cjson.decode(body)
	if not res then
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_REQ_ARGS"))
		return
	end
	local secret = res["secret"]
	if not secret then
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_REQ_ARGS"))
		return
	end

	local ok, res = mysql_api.cmd('omstor___omstor_db', 'SELECT', sql_fmt["one_info"])
	if not ok then
		only.log('E','select mysql failed!')
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
		return
	end
	if #res == 0 then
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
		return
	end

	if res[1]["secret"] == secret then
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SECRET_SAME"))
		return
	end

	local sql = string.format(sql_fmt["one_update"], secret)
	local ok, res = mysql_api.cmd('omstor___omstor_db', 'UPDATE', sql)
	if not ok then
		only.log('E','select mysql failed!')
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
		return
	end
	if res == 1 then
		gosay.out_message(MSG.fmt_err_message("MSG_SUCCESS"))
	else
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
	end
end

AM_utils.main_call(handle)
