local sys = require('sys')
local cjson = require("cjson")
local gosay = require('gosay')
local mysql_api = require('mysql_pool_api')
local MSG = require('MSG')
local AM_utils = require('AM_utils')
local only = require('only')

local sql_fmt = {
	user_info = "SELECT * FROM user_list WHERE username='%s'",
	user_add = "INSERT INTO user_list (username, password) VALUES ('%s', '%s')",
	disk_list = "SELECT * FROM disk_list",
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
	local username = res["username"]
	if not username then
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_REQ_ARGS"))
		return
	end
	username = AM_utils.get_sys_name(username)
	local password = res["password"]
	if not password then
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_REQ_ARGS"))
		return
	end


	local sql = string.format(sql_fmt["user_info"], username)
	local ok, res = mysql_api.cmd('omstor___omstor_db', 'SELECT', sql)
	if not ok then
		only.log('E','select mysql failed!')
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
		return
	end
	if #res ~= 0 then
		only.log('E','mysql username %s is exist!', username)
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_USER_EXIST"))
		return
	end

	local ok, res = mysql_api.cmd('omstor___omstor_db', 'SELECT', sql_fmt["disk_list"])
	if not ok then
		only.log('E','select mysql failed!')
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
		return
	end
	if #res == 0 then
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_DISK_POOL_EMPTY"))
		return
	end
	for _, one in ipairs(res) do
		local cmd = string.format([[/usr/sbin/blkid | grep -q 'UUID="%s"']], one["uuid"])
		local ok = sys.execute(cmd)
		if not ok then
			gosay.out_message(MSG.fmt_err_message("MSG_ERROR_DISK_POOL_INACTIVE"))
			return
		end
	end

	local cmd = string.format(
		[[/usr/sbin/useradd -m -d /nfs/guest_%s guest_%s 2>&1 && /usr/bin/chown -R guest_%s:guest_%s /nfs/guest_%s 2>&1]],
		username, username, username, username, username)
	local ok, errmsg = sys.execute(cmd)
	if not ok then
		only.log('E', '%s', errmsg)
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_USER_EXIST"))
	else
		local cmd = string.format([[/usr/bin/echo 'guest_%s:%s'|/usr/sbin/chpasswd 2>&1]], username, password)
		local ok, errmsg = sys.execute(cmd)
		if not ok then
			local cmd = string.format([[/usr/sbin/userdel -r guest_%s]], username)
			os.execute(cmd)
			only.log('E', 'password %s is invalid!', password)
			gosay.out_message(MSG.fmt_err_message("MSG_ERROR_REQ_ARGS"))
		else
			local cmd = string.format([[/usr/sbin/usermod -s /sbin/nologin guest_%s]], username)
			sys.execute(cmd)

			local sql = string.format(sql_fmt["user_add"], username, password)
			local ok, res = mysql_api.cmd('omstor___omstor_db', 'INSERT', sql)
			if not ok then
				only.log('E','insert mysql failed!')
				gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
				return
			end
			gosay.out_message(MSG.fmt_err_message("MSG_SUCCESS"))
			return
		end
	end
end

AM_utils.main_call(handle)
