
tag = "fsTest"

function fs_info()
    if fs == nil then
        log.error(tag, "this fireware is not support fs")
        return
    end
    log.info(tag, "START")
    log.info(tag .. ".fsstat:", fs.fsstat())
    log.info(tag .. ".fsstat:/", fs.fsstat("/"))
    log.info(tag .. ".fsstat:/luadb/", fs.fsstat("/luadb/"))
    log.info(tag .. ".fsstat:/sd/", fs.fsstat("/sd/"))
    log.info(tag .. ".fsstat:/sfud/", fs.fsstat("/sfud/"))
    log.info(tag .. ".fsstat:/spiffs/", fs.fsstat("/spiffs/"))
    log.info(tag .. ".fsstat:/SPIFFS/", fs.fsstat("/SPIFFS/"))

    log.info(tag .. ".fsize:/luadb/code.png", fs.fsize("/luadb/code.png"))
    log.info(tag .. ".fsize:/luadb/main.luac", fs.fsize("/luadb/main.luac"))
    log.info(tag .. ".fsize:/luadb/main.lua", fs.fsize("/luadb/main.lua"))

    -- names = io.lsdir("/ldata/")
    -- log.info("dir",names)
    -- log.info(tag .. ".fsize", fs.fsize("/luadb/main.luac"))
    log.info(tag, "DONE")
end

function demo_file_create()
    
end

function demo_fs_mkdir()
    log.info(fs.mkdir("/youkai"))       --接口未实现，return -1
end

function fs_read_txt(file_path)
    log.info("fs_read_txt------------------{")
    -- local file_path = "/luadb/boot_time.txt"   --luadb只读
    local f_read_txt = io.open(file_path, "rb")
    log.info("f_read_txt:",type(f_read_txt))      -- userdata
    if f_read_txt then
        log.info("f_read_txt ok")
        local data = f_read_txt:read("*a")
        log.info("data type = "..type(data)) -- string
        -- if data == "" then
        --     data = "0"
        -- end
        log.info("fs","data", "["..data.."]", type(data))

        local data_temp = data:toHex()
        log.info("fs","data","["..data_temp.."]", type(data_temp))
        f_read_txt:close()
    end

    if fs then
        log.info("fsstat", fs.fsize(file_path))
    end
    log.info("fs_read_txt------------------}")
end

function fs_write_txt(file_path)
    log.info("fs_write_txt------------------{")
    -- local file_path = "/test_write.txt"   --luadb只读
    local f_write_txt = io.open(file_path, "wb+")   --读写方式打开或建立一个二进制文件，允许读和写
    log.info("fs_write_txt:",type(f_write_txt))      -- userdata
    if f_write_txt then
        log.info("f_write_txt ok")
        local data = f_write_txt:write("aaa")
        log.info("fs","data", "["..data.."]", type(data))
        f_write_txt:close()
    end

    if fs then
        log.info("fsstat", fs.fsize(file_path))
    end
    log.info("fs_write_txt------------------}")
end

function fs_test_boottime()
    -- file_path = "/boot_time"
    local f = io.open(file_path, "rb")
    local c = 0
    log.info("f:",type(f))      -- userdata
    if f then
        log.info("f ok")
        local data = f:read("*a")
        log.info("data",type(data)) -- string
        if data == "" then
            data = "0"
        end
        local data_temp = data:toHex()
        log.info("fs", "data", data, data_temp, type(data_temp))
        c = tonumber(data)
        f:close()
    end
    log.info("fs", "boot count", c)
    c = c + 1
    f_write = io.open(file_path, "wb")
    --if f ~= nil then
    log.info("fs", "write c to file", c, tostring(c))
    f_write:write(tostring(c))
    log.info("end write")
    f_write:close()
    log.info("end close")
    --end

    if fs then
        log.info("fsstat", fs.fsize(file_path))
    end
end