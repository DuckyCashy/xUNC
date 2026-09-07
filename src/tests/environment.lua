local getgenv = getgenv or function() return {} end
local getrenv = getrenv or function() return {} end
local getreg = getreg or getregistry
local getgc = getgc
local getloadedmodules = getloadedmodules
local getrenv = getrenv
local getgenv = getgenv

local function registerEnvironmentTests(Runner)
    Runner.Register("Environment Isolation (getgenv vs getrenv)", function()
        if not (getgenv and getrenv) then return false, "getgenv or getrenv function is missing" end
        if getgenv() == getrenv() then return false, "Global environment matches Roblox environment" end
        return true
    end)

    Runner.Register("Registry Access (getreg / getregistry)", function()
        if not getreg then return false, "getreg / getregistry missing" end
        local reg = getreg()
        if type(reg) ~= "table" then return false, "Returned registry is not a valid table" end
        return true
    end)

    Runner.Register("Garbage Collection Inspection (getgc)", function()
        if not getgc then return false, "getgc missing" end
        local gc = getgc(true)
        if type(gc) ~= "table" or #gc == 0 then return false, "getgc failed to return environment objects" end
        return true
    end)

    Runner.Register("Loaded Modules Inspection (getloadedmodules)", function()
        if not getloadedmodules then return false, "getloadedmodules missing" end
        local modules = getloadedmodules()
        if type(modules) ~= "table" then return false, "getloadedmodules did not return a table" end
        return true
    end)
end

return registerEnvironmentTests

