local hookfunction = hookfunction
local newcclosure = newcclosure
local iscclosure = iscclosure
local checkcaller = checkcaller
local clonefunction = clonefunction
local islclosure = islclosure
local setupvalue = setupvalue
local getupvalue = getupvalue
local getupvalues = getupvalues
local getconstants = getconstants
local setconstant = setconstant
local getprotos = getprotos
local getstack = getstack
local setstack = setstack
local getinfo = getinfo
local isexecutorclosure = isexecutorclosure or checkclosure or isourclosure

local function registerClosureTests(Runner)
    Runner.Register("Function Redirection (hookfunction)", function()
        if not hookfunction then return false, "hookfunction missing" end
        local function targetFunction() return "Original" end
        hookfunction(targetFunction, function() return "Hooked" end)
        if targetFunction() ~= "Hooked" then return false, "hookfunction failed to replace logic" end
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
        if cloned == original or cloned() ~= "xUNC_Clone" then return false, "clonefunction failed to duplicate logic" end
        return true
    end)

    Runner.Register("Lua Closure Verification (islclosure)", function()
        if not islclosure then return false, "islclosure missing" end
        local luaFunc = function() end
        if not islclosure(luaFunc) then return false, "islclosure failed on standard Lua function" end
        return true
    end)

    Runner.Register("Upvalue Retrieval (getupvalue)", function()
        if not getupvalue then return false, "getupvalue missing" end
        local secret = "xUNC_Upvalue"
        local function testFunc() return secret end
        local val = getupvalue(testFunc, 1)
        if val ~= secret then return false, "getupvalue failed to fetch value" end
        return true
    end)

    Runner.Register("Upvalue List Extraction (getupvalues)", function()
        if not getupvalues then return false, "getupvalues missing" end
        local secret = "xUNC_List"
        local function testFunc() return secret end
        local upvals = getupvalues(testFunc)
        if type(upvals) ~= "table" or upvals[1] ~= secret then return false, "getupvalues returned invalid structure" end
        return true
    end)

    Runner.Register("Upvalue Modification (setupvalue)", function()
        if not setupvalue then return false, "setupvalue missing" end
        local secret = "Old"
        local function testFunc() return secret end
        setupvalue(testFunc, 1, "New")
        if getupvalue(testFunc, 1) ~= "New" then return false, "setupvalue failed to modify value" end
        return true
    end)

    Runner.Register("Constant Extraction (getconstants)", function()
        if not getconstants then return false, "getconstants missing" end
        local function testFunc() return "Constant_String", 12345 end
        local consts = getconstants(testFunc)
        if type(consts) ~= "table" or #consts == 0 then return false, "getconstants failed to return constants" end
        return true
    end)

    Runner.Register("Constant Modification (setconstant)", function()
        if not setconstant then return false, "setconstant missing" end
        local function testFunc() return "Old_Const" end
        setconstant(testFunc, 1, "New_Const")
        if getconstants(testFunc)[1] ~= "New_Const" then return false, "setconstant failed to set value" end
        return true
    end)

    Runner.Register("Proto Extraction (getprotos)", function()
        if not getprotos then return false, "getprotos missing" end
        local function parent() local function child() end end
        local protos = getprotos(parent)
        if type(protos) ~= "table" or #protos == 0 then return false, "getprotos failed to extract inner function" end
        return true
    end)

    Runner.Register("Stack Inspection (getstack)", function()
        if not getstack then return false, "getstack missing" end
        return true
    end)

    Runner.Register("Stack Modification (setstack)", function()
        if not setstack then return false, "setstack missing" end
        return true
    end)

    Runner.Register("Function Debug Information (getinfo)", function()
        if not getinfo then return false, "getinfo missing" end
        local info = getinfo(function() end)
        if type(info) ~= "table" or info.source == nil then return false, "getinfo failed to return valid debug table" end
        return true
    end)

    Runner.Register("Executor Closure Identification (isexecutorclosure)", function()
        if not isexecutorclosure then return false, "isexecutorclosure missing" end
        local execFunc = function() end
        if type(isexecutorclosure(execFunc)) ~= "boolean" then return false, "isexecutorclosure returned non-boolean" end
        return true
    end)

    Runner.Register("C-Closure Identification (iscclosure validity)", function()
        if not iscclosure then return false, "iscclosure missing" end
        if not iscclosure(print) then return false, "iscclosure returned false for native C function" end
        return true
    end)
end

return registerClosureTests
