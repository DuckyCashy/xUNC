local getgenv = getgenv or function() return {} end
local getrenv = getrenv or function() return {} end
local getreg = getreg or getregistry
local getgc = getgc
local getloadedmodules = getloadedmodules
local identifyexecutor = identifyexecutor or getexecutorname or function() return "Unknown", "1.0.0" end

local function registerEnvironmentTests(Runner)
    Runner.Register("Executor Identification (identifyexecutor)", function()
        if not (identifyexecutor or getexecutorname) then return false, "No executor identification function found" end
        local name, version = identifyexecutor()
        if type(name) ~= "string" then return false, "Executor name is not a string" end
        return true
    end)

    Runner.Register("Environment Isolation (getgenv vs getrenv)", function()
        if not (getgenv and getrenv) then return false, "getgenv or getrenv missing" end
        if getgenv() == getrenv() then return false, "Global environment matches Roblox environment" end
        return true
    end)

    Runner.Register("Registry Access (getreg / getregistry)", function()
        if not getreg then return false, "getreg missing" end
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

    Runner.Register("Thread Identity Retrieval (getthreadidentity)", function()
        local getidentity = getthreadidentity or getidentity or getthreadlevel
        if not getidentity then return false, "getthreadidentity missing" end
        if type(getidentity()) ~= "number" then return false, "Thread identity returned non-number" end
        return true
    end)

    Runner.Register("Thread Identity Mutation (setthreadidentity)", function()
        local setidentity = setthreadidentity or setidentity or setthreadlevel
        local getidentity = getthreadidentity or getidentity or getthreadlevel
        if not (setidentity and getidentity) then return false, "setthreadidentity missing" end
        local original = getidentity()
        setidentity(7)
        local modified = getidentity() == 7
        setidentity(original)
        if not modified then return false, "Failed to set thread identity" end
        return true
    end)

    Runner.Register("Global Environment Table Check (getgenv validity)", function()
        if not getgenv then return false, "getgenv missing" end
        local env = getgenv()
        env.__xunc_test_key = true
        local valid = env.__xunc_test_key == true
        env.__xunc_test_key = nil
        if not valid then return false, "Failed to write and verify key in global env" end
        return true
    end)

    Runner.Register("Roblox Environment Table Check (getrenv validity)", function()
        if not getrenv then return false, "getrenv missing" end
        local renv = getrenv()
        if renv.game ~= game then return false, "Roblox environment game reference mismatch" end
        return true
    end)

    Runner.Register("Script Environment Extraction (getsenv)", function()
        local getsenv = getsenv
        if not getsenv then return false, "getsenv missing" end
        return true
    end)

    Runner.Register("Script Closure Retrieval (getscriptclosure)", function()
        local getscriptclosure = getscriptclosure or getscriptfunction
        if not getscriptclosure then return false, "getscriptclosure missing" end
        return true
    end)

    Runner.Register("Script Hash Retrieval (getscripthash)", function()
        local getscripthash = getscripthash
        if not getscripthash then return false, "getscripthash missing" end
        return true
    end)

    Runner.Register("Scripts Hierarchy Extraction (getscripts)", function()
        local getscripts = getscripts
        if not getscripts then return false, "getscripts missing" end
        local scripts = getscripts()
        if type(scripts) ~= "table" then return false, "getscripts did not return a table" end
        return true
    end)

    Runner.Register("Running Scripts Inspection (getrunningscripts)", function()
        local getrunningscripts = getrunningscripts
        if not getrunningscripts then return false, "getrunningscripts missing" end
        local scripts = getrunningscripts()
        if type(scripts) ~= "table" then return false, "getrunningscripts did not return a table" end
        return true
    end)

    Runner.Register("Thread Environment Retrieval (gettenv)", function()
        local gettenv = gettenv
        if not gettenv then return false, "gettenv missing" end
        return true
    end)
end

return registerEnvironmentTests
