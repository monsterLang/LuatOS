
tag = "fsTest"

img_file_name = "test3.bmp"

function fsTest()
    if fs == nil then
        log.error(tag, "this fireware is not support fs")
        return
    end
    log.info(tag, "START")
    log.info(tag .. ".fsstat:", fs.fsstat())
    log.info(tag .. ".fsstat:/", fs.fsstat("/"))
    log.info(tag .. ".fsstat:/luadb/", fs.fsstat("/luadb/"))

    dir_name = "/ldata/"
    log.info(tag .. ".fsstat:"..dir_name, fs.fsstat(dir_name))
    
    log.info(tag .. ".fsize:/luadb/"..img_file_name, fs.fsize("/luadb/"..img_file_name))
    log.info(tag .. ".fsstat:/luadb/main.luac", fs.fsstat("/luadb/main.luac"))
    log.info(tag .. ".fsstat:/luadb/main.lua", fs.fsstat("/luadb/main.lua"))

    -- names = io.lsdir("/ldata/")
    -- log.info("dir",names)
    -- log.info(tag .. ".fsize", fs.fsize("/luadb/main.luac"))
    log.info(tag, "DONE")
end