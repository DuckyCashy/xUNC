local getrawmetatable = getrawmetatable
local setrawmetatable = setrawmetatable
local hookmetamethod = hookmetamethod
local getnamecallmethod = getnamecallmethod or function() return "" end
local game = game

local function registerMetatableTests(Runner)
    Runner.Register("Raw Metatable Extraction (getrawmetatable)", function()
        if not getrawmetatable then 
            return false, "getrawmetatable function missing" 
        end
        
        local protectedTable = setmetatable({}, { 
            __metatable = "Locked Metatable",
            __index = "xUNC_Pass" 
        })
        
        local rawMeta = getrawmetatable(protectedTable)
        if type(rawMeta) ~= "table" or rawMeta.__index ~= "xUNC_Pass" then
            return false, "Failed to extract raw metatable from protected object"
        end
        
        return true
    end)

    Runner.Register("Raw Metatable Injection (setrawmetatable)", function()
        if not (getrawmetatable and setrawmetatable) then 
            return false, "setrawmetatable function missing" 
        end
        
        local targetTable = {}
        local customMeta = { __index = { Key = "xUNC_Validated" } }
        
        setrawmetatable(targetTable, customMeta)
        
        if targetTable.Key ~= "xUNC_Validated" then
            return false, "Failed to apply raw metatable via setrawmetatable"
        end
        
        return true
    end)

    Runner.Register("Metamethod Hooking (hookmetamethod)", function()
        if not hookmetamethod then 
            return false, "hookmetamethod missing" 
        end
        
        local dummyInstance = Instance.new("Part")
        
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "GetFullName" and self == dummyInstance then
                return "xUNC_Hooked_Instance"
            end
            return oldNamecall(self, ...)
        end)
        
        local result = dummyInstance:GetFullName()
        dummyInstance:Destroy()
        
        if result ~= "xUNC_Hooked_Instance" then
            return false, "hookmetamethod failed to intercept call"
        end
        
        return true
    end)
end

return registerMetatableTests
