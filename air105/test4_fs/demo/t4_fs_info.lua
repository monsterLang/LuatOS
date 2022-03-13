function get_fs_info()
    log.info("fsize", fs.fsize("/luadb/main.luac"))
    log.info("fsstat", fs.fsstat(""))
    log.info("fsstat", fs.fsstat("/luadb/"))    -- 注意不能用"/luadb"，要加上斜杠
end

-- 记录开机次数
function fs_test()
    f = io.open("/boot_time", "rb")
    c = 0
    if f then
        data = f:read("*a")
        log.info("fs", "data", data, data:toHex())
        c = tonumber(data)
        f:close()
    end
    log.info("fs", "boot count", c)
    c = c + 1
    f = io.open("/boot_time", "wb")
    --if f ~= nil then
    log.info("fs", "write c to file", c, tostring(c))
    f:write(tostring(c))
    f:close()
    --end

    if fs then
        log.info("fsstat", fs.fsstat(""))
    end
end

function t4_fs_root_write()
    print("init")
    -- f = io.mkfs("youkai")
    f = io.open("/youkai", "wb")
    print(type(f))
    --if f ~= nil then
    c = "hi,langzhao"
    log.info("fs", "write c to file", c)
    f:write(tostring(c))
    f:close()

    f = io.open("/youkai", "r")
    if f then
        data = f:read("*a") -- *a表示文件，l表示行
        -- https://gitee.com/openLuat/LuatOS/blob/master/lua/src/loslib.c  g_read()
        print("file data : ",data)
        f:close()
    end

    -- air 105根目录""下可以创建文件并读写
end