local mysql_api = require('mysql_pool_api')
local gosay = require('gosay')
local MSG = require('MSG')
local cjson = require("cjson")
local sys = require("sys")
local only = require('only')
local AM_utils = require('AM_utils')

local sql_fmt = {
	one_info = "SELECT * FROM sys_info WHERE id=1",
	one_init = "INSERT INTO sys_info (secret, nas_uuid) VALUES ('123456', '%s')",
}

local function handle()
	local args = ngx.req.get_uri_args()
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

	local token = AM_utils.admin_sign()

	local ok, res = mysql_api.cmd('omstor___omstor_db', 'SELECT', sql_fmt["one_info"])
	if not ok then
		only.log('E','select mysql failed!')
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
		return
	end
	if #res == 0 then
		--only.log('D','secret %s!', secret)
		if secret == "123456" then
			local cmd = "/usr/sbin/dmidecode -s system-uuid 2>&1"
			local ok, nas_uuid = sys.execute(cmd)
			if not ok then
				nas_uuid = "00000000-0000-0000-0000-000000000000"
			else
				nas_uuid = string.gsub(nas_uuid, "\n", "")
			end
			if #nas_uuid == 0 then
				cmd = 'cd / && /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "(Get-CimInstance -ClassName Win32_ComputerSystemProduct).UUID" 2>&1'
				ok, nas_uuid = sys.execute(cmd)
				if not ok then
					nas_uuid = "00000000-0000-0000-0000-000000000000"
				else
					nas_uuid = string.gsub(nas_uuid, "\r\n", "")
				end
			end
			nas_uuid = string.lower(nas_uuid)

			local sql = string.format(sql_fmt["one_init"], nas_uuid)
			local ok, res = mysql_api.cmd('omstor___omstor_db', 'INSERT', sql)
			if not ok then
				only.log('E','select mysql failed!')
				gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
				return
			end

			local info = {}
			info["nas_uuid"] = nas_uuid
			info["token"] = token
			local msg = cjson.encode(info)
			gosay.out_message(MSG.fmt_api_message(msg))
		else
			gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SECRET"))
		end
	else
		if res[1]["secret"] == secret then
			local info = {}
			info["nas_uuid"] = res[1]["nas_uuid"]
			info["token"] = token
			local msg = cjson.encode(info)
			gosay.out_message(MSG.fmt_api_message(msg))
		else
			gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SECRET"))
		end
	end
end

AM_utils.main_call(handle)
