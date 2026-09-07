local writefile = writefile
local readfile = readfile
local appendfile = appendfile
local delfile = delfile

local function registerFileSystemTests(Runner)
    Runner.Register("FileSystem Operations (write/read/append/del)", function()
        if not (writefile and readfile and appendfile and delfile) then
            return false, "Missing filesystem functions"
        end
        
        local fileName = "xunc_fs_" .. tostring(math.random(10000, 99999)) .. ".tmp"
        local initialData = "xUNC_FS_Test"
        local appendedData = "_Appended"
        
        writefile(fileName, initialData)
        appendfile(fileName, appendedData)
        
        local result = readfile(fileName)
        delfile(fileName)
        
        if result ~= (initialData .. appendedData) then
            return false, "Read content did not match written & appended data"
        end
        
        return true
    end)
end

return registerFileSystemTests
