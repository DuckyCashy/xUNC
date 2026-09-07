local writefile = writefile
local readfile = readfile
local appendfile = appendfile
local delfile = delfile
local isfile = isfile
local isfolder = isfolder
local makefolder = makefolder
local delfolder = delfolder
local listfiles = listfiles
local loadfile = loadfile

local function registerFileSystemTests(Runner)
    Runner.Register("FileSystem Write/Read Operations (writefile/readfile)", function()
        if not (writefile and readfile and delfile) then return false, "Missing write/read/del functions" end
        local fileName = "xunc_fs_" .. tostring(math.random(10000, 99999)) .. ".tmp"
        local content = "xUNC_FS_Data"
        writefile(fileName, content)
        local read = readfile(fileName)
        delfile(fileName)
        if read ~= content then return false, "Read content mismatch" end
        return true
    end)

    Runner.Register("FileSystem Append Operations (appendfile)", function()
        if not (writefile and appendfile and readfile and delfile) then return false, "Missing append functions" end
        local fileName = "xunc_app_" .. tostring(math.random(10000, 99999)) .. ".tmp"
        writefile(fileName, "A")
        appendfile(fileName, "B")
        local result = readfile(fileName)
        delfile(fileName)
        if result ~= "AB" then return false, "Append content mismatch" end
        return true
    end)

    Runner.Register("File Existence Verification (isfile)", function()
        if not (writefile and isfile and delfile) then return false, "isfile missing" end
        local fileName = "xunc_check_" .. tostring(math.random(10000, 99999)) .. ".tmp"
        writefile(fileName, "x")
        local exists = isfile(fileName)
        delfile(fileName)
        if not exists then return false, "isfile returned false for existing file" end
        return true
    end)

    Runner.Register("Folder Creation and Deletion (makefolder/delfolder)", function()
        if not (makefolder and isfolder and delfolder) then return false, "Folder API missing" end
        local folderName = "xunc_folder_" .. tostring(math.random(10000, 99999))
        makefolder(folderName)
        local created = isfolder(folderName)
        delfolder(folderName)
        if not created then return false, "makefolder/isfolder check failed" end
        return true
    end)

    Runner.Register("Folder Listing Operations (listfiles)", function()
        if not (makefolder and writefile and listfiles and delfile and delfolder) then return false, "listfiles missing" end
        local folderName = "xunc_list_dir_" .. tostring(math.random(10000, 99999))
        local fileName = folderName .. "/file.tmp"
        makefolder(folderName)
        writefile(fileName, "test")
        local files = listfiles(folderName)
        delfile(fileName)
        delfolder(folderName)
        if type(files) ~= "table" or #files == 0 then return false, "listfiles failed to return contents" end
        return true
    end)

    Runner.Register("FileSystem Asset Loading (getcustomasset)", function()
        local getcustomasset = getcustomasset or Getsynasset
        if not getcustomasset then return false, "getcustomasset missing" end
        return true
    end)

    Runner.Register("Non-Existent File Check (isfile false test)", function()
        if not isfile then return false, "isfile missing" end
        if isfile("non_existent_xunc_file_99999.invalid") then return false, "isfile returned true for non-existent file" end
        return true
    end)

    Runner.Register("Non-Existent Folder Check (isfolder false test)", function()
        if not isfolder then return false, "isfolder missing" end
        if isfolder("non_existent_xunc_dir_99999.invalid") then return false, "isfolder returned true for non-existent directory" end
        return true
    end)

    Runner.Register("File Dynamic Execution (loadfile)", function()
        if not (writefile and loadfile and delfile) then return false, "loadfile missing" end
        local fileName = "xunc_load_" .. tostring(math.random(10000, 99999)) .. ".lua"
        writefile(fileName, "return 'xUNC_Loaded'")
        local compiled, err = loadfile(fileName)
        delfile(fileName)
        if not compiled or compiled() ~= "xUNC_Loaded" then return false, "loadfile failed to compile or run file code" end
        return true
    end)

    Runner.Register("File Deletion Verification (delfile)", function()
        if not (writefile and delfile and isfile) then return false, "delfile missing" end
        local fileName = "xunc_del_" .. tostring(math.random(10000, 99999)) .. ".tmp"
        writefile(fileName, "delete_me")
        delfile(fileName)
        if isfile(fileName) then return false, "File still exists after calling delfile" end
        return true
    end)
end

return registerFileSystemTests
