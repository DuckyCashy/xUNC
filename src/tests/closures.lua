local hookfunction = hookfunction
local newcclosure = newcclosure
local iscclosure = iscclosure
local checkcaller = checkcaller

local function registerClosureTests(Runner)
    Runner.Register("Function Redirection (hookfunction)", function()
        if not hookfunction then 
            return false, "hookfunction missing" 
        end
        
        local function targetFunction()
            return "Original"
        end
        
        hookfunction(targetFunction, function()
            return "Hooked"
        end)
        
        local result = targetFunction()
        if result ~= "Hooked" then
            return false, "hookfunction failed to replace function logic"
        end
        
        return true
    end)

    Runner.Register("C-Closure Wrapping (newcclosure)", function()
        if not (newcclosure and iscclosure) then 
            return false, "newcclosure or iscclosure missing" 
        end
        
        local luaFunc = function() return "xUNC" end
        local cFunc = newcclosure(luaFunc)
        
        if not iscclosure(cFunc) then
            return false, "newcclosure did not successfully output a valid C closure"
        end
        
        return true
    end)

    Runner.Register("Security Caller Check (checkcaller)", function()
        if not checkcaller then 
            return false, "checkcaller function missing" 
        end
        
        local callerState = checkcaller()
        if type(callerState) ~= "boolean" then
            return false, "checkcaller returned non-boolean value"
        end
        
        return true
    end)
end

return registerClosureTests
