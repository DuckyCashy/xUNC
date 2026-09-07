local hookfunction = hookfunction
local newcclosure = newcclosure
local iscclosure = iscclosure
local checkcaller = checkcaller
local clonefunction = clonefunction
local islclosure = islclosure

local function registerClosureTests(Runner)
    Runner.Register("Function Redirection (hookfunction)", function()
        if not hookfunction then return false, "hookfunction missing" end
        local function targetFunction() return "Original" end
        hookfunction(targetFunction, function() return "Hooked" end)
        if targetFunction() ~= "Hooked" then return false, "hookfunction failed to replace function logic" end
        return true
    end)

    Runner.Register("C-Closure Wrapping (newcclosure)", function()
        if not (newcclosure and iscclosure) then return false, "newcclosure or iscclosure missing" end
        local luaFunc = function() return "xUNC" end
        local cFunc = newcclosure(luaFunc)
        if not iscclosure(cFunc) then return false, "newcclosure did not output a valid C closure" end
        return true
    end)

    Runner.Register("Security Caller Check (checkcaller)", function()
        if not checkcaller then return false, "checkcaller missing" end
        if type(checkcaller()) ~= "boolean" then return false, "checkcaller returned non-boolean" end
        return true
    end)

    Runner.Register("Function Cloning (clonefunction)", function()
        if not clonefunction then return false, "clonefunction missing" end
        local function original() return "xUNC_Clone" end
        local cloned = clonefunction(original)
        if cloned == original or cloned() ~= "xUNC_Clone" then
            return false, "clonefunction failed to duplicate logic into new reference"
        end
        return true
    end)

    Runner.Register("Lua Closure Verification (islclosure)", function()
        if not islclosure then return false, "islclosure missing" end
        local luaFunc = function() end
        if not islclosure(luaFunc) then return false, "islclosure failed on standard Lua function" end
        return true
    end)
end

return registerClosureTests
