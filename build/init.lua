local writefile = writefile
local readfile = readfile
local appendfile = appendfile
local delfile = delfile
local getgenv = getgenv or function() return {} end
local getrenv = getrenv or function() return {} end
local getreg = getreg or getregistry
local getgc = getgc
local getrawmetatable = getrawmetatable
local setrawmetatable = setrawmetatable
local hookmetamethod = hookmetamethod
local getnamecallmethod = getnamecallmethod or function() return "" end
local hookfunction = hookfunction
local newcclosure = newcclosure
local iscclosure = iscclosure
local checkcaller = checkcaller
local getnilinstances = getnilinstances
local fireclickdetector = fireclickdetector
local Instance = Instance
local game = game
local task = task or { wait = function(s) local t = os.clock() repeat until os.clock() - t >= s end }

local Runner = {
    Passed = 0,
    Failed = 0,
    Tests = {}
}

function Runner.Register(name, testFunc)
    table.insert(Runner.Tests, { Name = name, Func = testFunc })
end

function Runner.RunAll()
    print("\n==============================================")
    print("      ℹ️ STARTING xUNC SUITE TEST RUN ℹ️      ")
    print("            'Zero Spoof, All Proof.'          ")
    print("==============================================\n")
    
    for _, test in ipairs(Runner.Tests) do
        local success, passed, message = pcall(test.Func)
        
        if success and passed == true then
            Runner.Passed = Runner.Passed + 1
            print("✅ [PASS] " .. tostring(test.Name))
        else
            Runner.Failed = Runner.Failed + 1
            local reason = not success and tostring(passed) or (message or "Failed behavioral assertion")
            print("❌ [FAIL] " .. tostring(test.Name) .. " -> " .. tostring(reason))
        end
    end
    
    local total = Runner.Passed + Runner.Failed
    local percentage = total > 0 and math.floor((Runner.Passed / total) * 100) or 0
    print("\n==============================================")
    print(string.format("ℹ️ xUNC FINAL SCORE: %d/%d (%d%%)", Runner.Passed, total, percentage))
    print("==============================================\n")
end

Runner.Register("Environment Isolation (getgenv vs getrenv)", function()
    if not (getgenv and getrenv) then return false, "Environment functions missing" end
    if getgenv() == getrenv() then return false, "Global environment matches Roblox environment" end
    return true
end)

Runner.Register("Registry Access (getreg / getregistry)", function()
    if not getreg then return false, "getreg missing" end
    local reg = getreg()
    if type(reg) ~= "table" then return false, "Returned registry is not a valid table" end
    return true
end)

Runner.Register("FileSystem Operations (write/read/append/del)", function()
    if not (writefile and readfile and appendfile and delfile) then
        return false, "Missing filesystem functions"
    end
    
    local fileName = "xunc_test_" .. tostring(math.random(10000, 99999)) .. ".tmp"
    local initialData = "xUNC_Test_Data"
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

Runner.Register("Raw Metatable Extraction (getrawmetatable)", function()
    if not getrawmetatable then return false, "getrawmetatable function missing" end
    local protectedTable = setmetatable({}, { __metatable = "Locked Metatable", __index = "xUNC_Pass" })
    local rawMeta = getrawmetatable(protectedTable)
    if type(rawMeta) ~= "table" or rawMeta.__index ~= "xUNC_Pass" then
        return false, "Failed to extract raw metatable from protected object"
    end
    return true
end)

Runner.RunAll()
