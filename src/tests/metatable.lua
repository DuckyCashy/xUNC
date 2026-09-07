local getrawmetatable = getrawmetatable
local setrawmetatable = setrawmetatable
local hookmetamethod = hookmetamethod
local isreadonly = isreadonly
local setreadonly = setreadonly
local getnamecallmethod = getnamecallmethod or function() return "" end
local game = game

local function registerMetatableTests(Runner)
    Runner.Register("Raw Metatable Extraction (getrawmetatable)", function()
        if not getrawmetatable then return false, "getrawmetatable missing" end
        local protectedTable = setmetatable({}, { __metatable = "Locked Metatable", __index = "xUNC_Pass" })
        local rawMeta = getrawmetatable(protectedTable)
        if type(rawMeta) ~= "table" or rawMeta.__index ~= "xUNC_Pass" then return false, "Failed to extract raw metatable" end
        return true
    end)

    Runner.Register("Raw Metatable Injection (setrawmetatable)", function()
        if not (getrawmetatable and setrawmetatable) then return false, "setrawmetatable missing" end
        local targetTable = {}
        local customMeta = { __index = { Key = "xUNC_Validated" } }
        setrawmetatable(targetTable, customMeta)
        if targetTable.Key ~= "xUNC_Validated" then return false, "Failed to apply raw metatable" end
        return true
    end)

    Runner.Register("Metamethod Hooking (hookmetamethod)", function()
        if not hookmetamethod then return false, "hookmetamethod missing" end
        local dummyInstance = Instance.new("Part")
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "GetFullName" and self == dummyInstance then return "xUNC_Hooked_Instance" end
            return oldNamecall(self, ...)
        end)
        local result = dummyInstance:GetFullName()
        dummyInstance:Destroy()
        if result ~= "xUNC_Hooked_Instance" then return false, "hookmetamethod failed to intercept call" end
        return true
    end)

    Runner.Register("Read-Only State Verification (isreadonly)", function()
        if not isreadonly then return false, "isreadonly missing" end
        local tbl = {}
        table.freeze(tbl)
        if not isreadonly(tbl) then return false, "isreadonly failed on frozen table" end
        return true
    end)

    Runner.Register("Read-Only State Modification (setreadonly)", function()
        if not setreadonly then return false, "setreadonly missing" end
        local tbl = {}
        table.freeze(tbl)
        setreadonly(tbl, false)
        if isreadonly(tbl) then return false, "setreadonly failed to unfreeze table" end
        return true
    end)

    Runner.Register("Namecall Method Extraction (getnamecallmethod)", function()
        if not getnamecallmethod then return false, "getnamecallmethod missing" end
        return true
    end)

    Runner.Register("Metatable Table Locking Check (__metatable protection bypass)", function()
        if not getrawmetatable then return false, "getrawmetatable missing" end
        local tbl = setmetatable({}, { __metatable = "Protected" })
        local meta = getrawmetatable(tbl)
        if type(meta) ~= "table" then return false, "Bypass of __metatable lock failed" end
        return true
    end)

    Runner.Register("Read-Only Table Creation Check (table.freeze / setreadonly)", function()
        if not setreadonly then return false, "setreadonly missing" end
        local tbl = { x = 10 }
        setreadonly(tbl, true)
        local success = pcall(function() tbl.x = 20 end)
        if success then return false, "Table remained writable after setreadonly true" end
        return true
    end)

    Runner.Register("Metatable Index Redirection Hook (__index hook)", function()
        if not (getrawmetatable and setrawmetatable) then return false, "Metatable functions missing" end
        local obj = setmetatable({}, { __index = function() return "Original_Index" end })
        local meta = getrawmetatable(obj)
        meta.__index = function() return "Hooked_Index" end
        if obj.SomeKey ~= "Hooked_Index" then return false, "__index metamethod mutation failed" end
        return true
    end)
end

return registerMetatableTests
