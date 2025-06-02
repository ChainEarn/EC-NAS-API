local sys = require("sys")
local cjson = require('cjson')
local only = require('only')
local jwt = require("resty.jwt")
local os = require("os")
local gosay = require('gosay')
local MSG = require('MSG')
local lfs = require("lfs")

------> only use for handle
local function main_call(F, ...)
	ngx.header["Content-Type"] = "application/json"
	local info = { pcall(F, ...) }
	if not info[1] then
		only.log("E", info[2])
		gosay.out_message(MSG.fmt_err_message("MSG_ERROR_SYSTEM"))
	end
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

-- 辅助函数处理可能的NULL值
local function json_sanitize(value)
	if value == nil or (type(value) == "userdata" and value == cjson.null) then
		return ""
	else
		return tostring(value)
	end
end

local function parse_size(size_str)
	local num = tonumber(size_str:match("%d+"))
	local unit = size_str:match("[GMKB]") or "B"
	local multiplier = {
		G = 1024 * 1024 * 1024,
		M = 1024 * 1024,
		K = 1024,
		B = 1
	}
	return num * multiplier[unit]
end

local function format_size(bytes)
	if bytes <= 0 then return "0B" end
	local units = {"B", "K", "M", "G"}
	local unit_index = 1
	while bytes >= 1024 and unit_index < #units do
		bytes = bytes / 1024
		unit_index = unit_index + 1
	end
	return string.format("%.2f%s", bytes, units[unit_index])
end

local function adjust_size(raw, cut)
	local raw_bytes = parse_size(raw)
	local cut_bytes = parse_size(cut)
	local result = raw_bytes - cut_bytes
	return result >= 0 and format_size(result) or "0B"
end

local function is_mount_point(path)
	local cmd = string.format("/usr/bin/csdo /usr/bin/findmnt -T %q >/dev/null 2>&1", path)
	local ok = os.execute(cmd)
	return ok or false
end

local function get_mount_device(path)
	local f = io.popen("/usr/bin/csdo /usr/bin/findmnt -n -o SOURCE " .. path, "r")
	local device = f:read("*a")
	f:close()
	return device and device:gsub("\n", "") or nil
end

local function umount_path(mount_point)
	local ok = is_mount_point(mount_point)
	if ok then
		local device = get_mount_device(mount_point)
		only.log('I', "Unmounting loop device %s from %s", device, mount_point)
		os.execute("/usr/bin/csdo /usr/bin/umount " .. mount_point)
		if device and device:match("^/dev/loop") then
			os.execute("/usr/bin/csdo /usr/sbin/losetup -d " .. device)
		end
	end
end

local function get_one_disk(name)
	local ok, info = sys.execute("/usr/bin/lsblk -d -o NAME,MODEL,VENDOR,UUID,SERIAL,WWN,SIZE,FSTYPE,FSSIZE,FSUSED,FSAVAIL,FSUSE% -J /dev/" .. name)
	if not ok then
		only.log('E', 'lsblk failed:%s!', info)
		return nil
	end
	local top = cjson.decode(info)
	local out = top["blockdevices"][1]
	for k, v in pairs(out) do
		out[k] = json_sanitize(v)
	end
	return out
end

local function get_all_disk()
	local ok, info = sys.execute("/usr/bin/lsblk -J")
	if not ok then
		only.log('E', 'lsblk failed:%s!', info)
		return {}
	end
	local list = {}
	local top = cjson.decode(info)
	for _, sub in ipairs(top["blockdevices"]) do
		local name = sub["name"]
		local is_sys_block = false
		for _, one in ipairs(sub["children"] or {}) do
			for _, mnt in ipairs(one["mountpoints"] or {}) do
				if mnt == "/boot" then
					is_sys_block = true
				end
			end
		end
		if not is_sys_block then
			table.insert(list, name)
		end
	end

	local all = {}
	for _, dev in ipairs(list) do
		local one = get_one_disk(dev)
		if one then
			table.insert(all, one)
		end
	end
	return all
end

--遍历所有匹配的key="value"键值对
local function parse_k_v_(str)
    local list = {}
    local fmt = '(%w+)="([^"]*)"'
    for key, val in str:gmatch(fmt) do
	list[key] = val
    end
    return list
end

local function parse_blkid(str)
	local pos = string.find(str, ":")
	if pos then
		local sub_str = string.sub(str, pos + 1)
		return parse_k_v_(sub_str)
	end
	return {}
end

local function get_disk_uuid(dev)
	local ok, info = sys.execute("/usr/sbin/blkid /dev/" .. dev)
	if not ok then
		only.log('E', 'blkid failed:%s!', info)
		return nil
	end
	local list = parse_blkid(info)
	return list["UUID"]
end

local function get_disk_fstype(dev)
	local ok, info = sys.execute("/usr/sbin/blkid /dev/" .. dev)
	if not ok then
		only.log('E', 'blkid failed:%s!', info)
		return nil
	end
	local list = parse_blkid(info)
	return list["TYPE"]
end

local function data_pool_apply(list)
	for _, one in ipairs(list) do
		local cmd = string.format([[/usr/sbin/blkid | grep -q 'UUID="%s"']], one["uuid"])
		local ok = sys.execute(cmd)
		if not ok then
			only.log('E', 'disk %s is inactive!', one["uuid"])
			return
		end
	end

	local mounts = {}
	os.execute("/usr/bin/csdo /usr/bin/umount /nfs")
	if #list == 0 then return end
	for _, one in ipairs(list) do
		repeat
			if string.upper(one["devtype"]) == "IMG" then
				umount_path("/mnt/" .. one["uuid"] .. "_IMG")
				os.execute("/usr/bin/csdo /usr/bin/umount /mnt/" .. one["uuid"])
				os.execute("/usr/bin/csdo /usr/bin/mkdir -p /mnt/" .. one["uuid"] .. "_IMG")
				os.execute("/usr/bin/csdo /usr/bin/mkdir -p /mnt/" .. one["uuid"])
				local cmd = string.format("/usr/bin/csdo /usr/bin/mount /dev/disk/by-uuid/%s /mnt/%s", one["uuid"], one["uuid"])
				local ok, info = sys.execute(cmd)
				if not ok then
					only.log('E', 'mount failed:%s!', info)
				else
					local src_path = string.format("/mnt/%s/EC_NAS.img", one["uuid"])
					local attr = lfs.attributes(src_path)
					if not attr then
						local cmd = string.format("/usr/bin/df -h /mnt/%s | /usr/bin/awk 'NR==2 {printf $4}'", one["uuid"])
						local ok, size = sys.execute(cmd)
						if not ok then
							only.log('E', 'get disk %s Avail failed:%s!', src_path, size)
							break
						end

						size = adjust_size(size, "64M")
						local cmd = string.format("/usr/bin/csdo /usr/bin/fallocate -l %s %s", size, src_path)
						local ok, err = sys.execute(cmd)
						if not ok then
							only.log('E', 'fallocate %s failed:%s!', src_path, err)
							break
						end

						os.execute("/usr/bin/csdo /usr/sbin/mkfs.xfs -f -s size=4096 " .. src_path)
					end

					local attr = lfs.attributes(src_path)
					if not attr then
						only.log('E', 'path:%s not exist!', src_path)
						break
					end
					if attr.mode ~= "file" then
						only.log('E', 'path:%s not file!', src_path)
						break
					end

					os.execute("/usr/bin/csdo /bin/bash /opt/omstor/EC-NAS-API/tools/prepare_loop_device.sh")
					local dst_path = "/mnt/" .. one["uuid"] .. "_IMG"
					local cmd = string.format("usr/bin/csdo /usr/bin/mount -o loop %s %s", src_path, dst_path)
					local ok, info = sys.execute(cmd)
					if not ok then
						only.log('E', 'mount failed:%s!', info)
						break
					end
					table.insert(mounts, dst_path)
				end
			end
			if string.upper(one["devtype"]) == "VHD" then
			end
			if string.upper(one["devtype"]) == "BLK" then
				os.execute("/usr/bin/csdo /usr/bin/umount /dev/disk/by-uuid/" .. one["uuid"])
				os.execute("/usr/bin/csdo /usr/bin/mkdir -p /mnt/" .. one["uuid"])
				local cmd = string.format("/usr/bin/csdo /usr/bin/mount /dev/disk/by-uuid/%s /mnt/%s", one["uuid"], one["uuid"])
				local ok, info = sys.execute(cmd)
				if not ok then
					only.log('E', 'mount failed:%s!', info)
				else
					table.insert(mounts, "/mnt/" .. one["uuid"])
				end
			end
		until true
	end
	if #mounts == 0 then return end
	local disks = table.concat(mounts, ":")
	os.execute("/usr/bin/csdo /usr/bin/mkdir -p /nfs")
	local cmd = string.format("/usr/bin/csdo /usr/bin/mergerfs -o defaults,allow_other,use_ino,cache.files=off,dropcacheonclose=true,category.create=mfs,minfreespace=64M %s /nfs", disks)
	local ok, info = sys.execute(cmd)
	if not ok then
		only.log('E', 'mergerfs failed:%s!', info)
	end
end

return {
	main_call = main_call,
	token_check = token_check,
	get_all_disk = get_all_disk,
	get_one_disk = get_one_disk,
	get_disk_uuid = get_disk_uuid,
	get_disk_fstype = get_disk_fstype,
	data_pool_apply = data_pool_apply,
}
