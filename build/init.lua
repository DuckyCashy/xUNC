local passes = 0
local fails = 0
local undefined = 0
local total = 0

local results = {}

local function test(name, callback)
    total = total + 1
    task.wait(0.02)

    local success, result = pcall(callback)

    if success then
        if result == true then
            passes = passes + 1
            table.insert(results, "✅ " .. name)
        elseif result == false then
            fails = fails + 1
            table.insert(results, "❌ " .. name)
        else
            undefined = undefined + 1
            table.insert(results, "❓ " .. name)
        end
    else
        fails = fails + 1
        table.insert(results, "❌ " .. name)
    end
end

local function getExecutor()
    local fn = identifyexecutor or getexecutorname
    if typeof(fn) == "function" then
        local name, ver = fn()
        if name then
            return ver and (name .. " " .. ver) or name
        end
    end
    return "Unknown Executor"
end

print("⚡ [xUNC] Executing soft benchmark suite...")

test("cache.invalidate", function()
    return typeof(cache) == "table" and typeof(cache.invalidate) == "function"
end)

test("cache.iscached", function()
    return typeof(cache) == "table" and typeof(cache.iscached) == "function"
end)

test("cache.replace", function()
    return typeof(cache) == "table" and typeof(cache.replace) == "function"
end)

test("cloneref", function()
    if typeof(cloneref) ~= "function" then return false end
    local part = Instance.new("Part")
    local clone = cloneref(part)
    local valid = (part ~= clone and part == clone)
    part:Destroy()
    return valid
end)

test("compareinstances", function()
    if typeof(compareinstances) ~= "function" or typeof(cloneref) ~= "function" then return false end
    local part = Instance.new("Part")
    local clone = cloneref(part)
    local valid = compareinstances(part, clone)
    part:Destroy()
    return valid == true
end)

test("checkcaller", function()
    if typeof(checkcaller) ~= "function" then return false end
    return checkcaller() == true
end)

test("clonefunction", function()
    if typeof(clonefunction) ~= "function" then return false end
    local function dummy() return "xUNC" end
    local cloned = clonefunction(dummy)
    return dummy ~= cloned and typeof(cloned) == "function" and cloned() == "xUNC"
end)

test("getcallingscript", function()
    if typeof(getcallingscript) ~= "function" then return false end
    local res = getcallingscript()
    return res == nil or typeof(res) == "Instance"
end)

test("hookfunction", function()
    return typeof(hookfunction) == "function"
end)

test("iscclosure", function()
    if typeof(iscclosure) ~= "function" then return false end
    return iscclosure(print) == true and iscclosure(function() end) == false
end)

test("islclosure", function()
    if typeof(islclosure) ~= "function" then return false end
    return islclosure(print) == false and islclosure(function() end) == true
end)

test("isexecutorclosure", function()
    local fn = isexecutorclosure or checkclosure or isourclosure
    if typeof(fn) ~= "function" then return false end
    return fn(fn) == true and fn(print) == false
end)

test("loadstring", function()
    if typeof(loadstring) ~= "function" then return false end
    local fn = loadstring("return 1337")
    return typeof(fn) == "function" and fn() == 1337
end)

test("newcclosure", function()
    if typeof(newcclosure) ~= "function" then return false end
    local fn = newcclosure(function() return true end)
    return typeof(fn) == "function" and fn() == true
end)

test("crypt.b64encode", function()
    if typeof(crypt) ~= "table" or typeof(crypt.b64encode) ~= "function" then return false end
    return crypt.b64encode("xUNC") == "eFVOQw=="
end)

test("crypt.b64decode", function()
    if typeof(crypt) ~= "table" or typeof(crypt.b64decode) ~= "function" then return false end
    return crypt.b64decode("eFVOQw==") == "xUNC"
end)

test("crypt.encrypt", function()
    if typeof(crypt) ~= "table" or typeof(crypt.encrypt) ~= "function" or typeof(crypt.generatekey) ~= "function" or typeof(crypt.decrypt) ~= "function" then return false end
    local key = crypt.generatekey()
    local encrypted, iv = crypt.encrypt("xUNC", key)
    local decrypted = crypt.decrypt(encrypted, key, iv)
    return decrypted == "xUNC"
end)

test("crypt.generatebytes", function()
    if typeof(crypt) ~= "table" or typeof(crypt.generatebytes) ~= "function" or typeof(crypt.b64decode) ~= "function" then return false end
    local bytes = crypt.generatebytes(16)
    return #crypt.b64decode(bytes) == 16
end)

test("crypt.generatekey", function()
    if typeof(crypt) ~= "table" or typeof(crypt.generatekey) ~= "function" or typeof(crypt.b64decode) ~= "function" then return false end
    local key = crypt.generatekey()
    return #crypt.b64decode(key) == 32
end)

test("crypt.hash", function()
    if typeof(crypt) ~= "table" or typeof(crypt.hash) ~= "function" then return false end
    local hash = crypt.hash("xUNC", "sha256")
    return typeof(hash) == "string" and #hash > 0
end)

test("debug.getconstant", function()
    if typeof(debug) ~= "table" or typeof(debug.getconstant) ~= "function" then return false end
    local function target() print("xUNC_Const") end
    return debug.getconstant(target, 1) == "print" or debug.getconstant(target, 2) == "xUNC_Const"
end)

test("debug.getconstants", function()
    if typeof(debug) ~= "table" or typeof(debug.getconstants) ~= "function" then return false end
    local function target() print("xUNC_Const") end
    local consts = debug.getconstants(target)
    return typeof(consts) == "table"
end)

test("debug.getinfo", function()
    if typeof(debug) ~= "table" or typeof(debug.getinfo) ~= "function" then return false end
    local info = debug.getinfo(print)
    return typeof(info) == "table" and info.what == "C"
end)

test("debug.getproto", function()
    if typeof(debug) ~= "table" or typeof(debug.getproto) ~= "function" then return false end
    local function parent()
        local function child() return "nested" end
    end
    local proto = debug.getproto(parent, 1)
    return typeof(proto) == "function"
end)

test("debug.getprotos", function()
    if typeof(debug) ~= "table" or typeof(debug.getprotos) ~= "function" then return false end
    local function parent()
        local function child1() end
        local function child2() end
    end
    local protos = debug.getprotos(parent)
    return typeof(protos) == "table"
end)

test("debug.getstack", function()
    if typeof(debug) ~= "table" or typeof(debug.getstack) ~= "function" then return false end
    local stack
    local function target()
        stack = debug.getstack(1)
    end
    target()
    return typeof(stack) == "table"
end)

test("debug.getupvalue", function()
    if typeof(debug) ~= "table" or typeof(debug.getupvalue) ~= "function" then return false end
    local upval = "upvalue_val"
    local function target() return upval end
    return debug.getupvalue(target, 1) == "upvalue_val"
end)

test("debug.getupvalues", function()
    if typeof(debug) ~= "table" or typeof(debug.getupvalues) ~= "function" then return false end
    local upval = "upvalue_val"
    local function target() return upval end
    local upvals = debug.getupvalues(target)
    return typeof(upvals) == "table" and upvals[1] == "upvalue_val"
end)

test("debug.setconstant", function()
    return typeof(debug) == "table" and typeof(debug.setconstant) == "function"
end)

test("debug.setstack", function()
    return typeof(debug) == "table" and typeof(debug.setstack) == "function"
end)

test("debug.setupvalue", function()
    return typeof(debug) == "table" and typeof(debug.setupvalue) == "function"
end)

test("Drawing.new", function()
    return typeof(Drawing) == "table" and typeof(Drawing.new) == "function"
end)

test("Drawing.Fonts", function()
    return typeof(Drawing) == "table" and typeof(Drawing.Fonts) == "table"
end)

test("isrenderobj", function()
    return typeof(isrenderobj) == "function"
end)

test("getrenderproperty", function()
    return typeof(getrenderproperty) == "function"
end)

test("setrenderproperty", function()
    return typeof(setrenderproperty) == "function"
end)

test("cleardrawcache", function()
    return typeof(cleardrawcache) == "function"
end)

test("writefile", function()
    if typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then return false end
    writefile("xunc_soft_test.txt", "testing")
    return isfile("xunc_soft_test.txt")
end)

test("readfile", function()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" or not isfile("xunc_soft_test.txt") then return false end
    return readfile("xunc_soft_test.txt") == "testing"
end)

test("appendfile", function()
    if typeof(appendfile) ~= "function" or typeof(readfile) ~= "function" or typeof(isfile) ~= "function" or not isfile("xunc_soft_test.txt") then return false end
    appendfile("xunc_soft_test.txt", "_append")
    return readfile("xunc_soft_test.txt") == "testing_append"
end)

test("loadfile", function()
    return typeof(loadfile) == "function"
end)

test("listfiles", function()
    if typeof(listfiles) ~= "function" then return false end
    local files = listfiles("")
    return typeof(files) == "table"
end)

test("isfile", function()
    if typeof(isfile) ~= "function" then return false end
    return isfile("xunc_soft_test.txt") == true and isfile("non_existent_file_xunc.txt") == false
end)

test("makefolder", function()
    if typeof(makefolder) ~= "function" or typeof(isfolder) ~= "function" then return false end
    makefolder("xunc_soft_folder")
    return isfolder("xunc_soft_folder")
end)

test("isfolder", function()
    if typeof(isfolder) ~= "function" then return false end
    return isfolder("xunc_soft_folder") == true and isfolder("non_existent_folder_xunc") == false
end)

test("delfolder", function()
    if typeof(delfolder) ~= "function" or typeof(isfolder) ~= "function" then return false end
    if isfolder("xunc_soft_folder") then delfolder("xunc_soft_folder") end
    return not isfolder("xunc_soft_folder")
end)

test("delfile", function()
    if typeof(delfile) ~= "function" or typeof(isfile) ~= "function" then return false end
    if isfile("xunc_soft_test.txt") then delfile("xunc_soft_test.txt") end
    return not isfile("xunc_soft_test.txt")
end)

test("fireclickdetector", function()
    return typeof(fireclickdetector) == "function"
end)

test("fireproximityprompt", function()
    return typeof(fireproximityprompt) == "function"
end)

test("firetouchinterest", function()
    return typeof(firetouchinterest) == "function"
end)

test("getcallbackvalue", function()
    return typeof(getcallbackvalue) == "function"
end)

test("getconnections", function()
    return typeof(getconnections) == "function"
end)

test("getcustomasset", function()
    return typeof(getcustomasset) == "function"
end)

test("gethiddenproperty", function()
    return typeof(gethiddenproperty) == "function"
end)

test("sethiddenproperty", function()
    return typeof(sethiddenproperty) == "function"
end)

test("getinstances", function()
    return typeof(getinstances) == "function"
end)

test("getnilinstances", function()
    return typeof(getnilinstances) == "function"
end)

test("getscriptbytecode", function()
    return typeof(getscriptbytecode) == "function" or typeof(getscriptcode) == "function"
end)

test("getscripthash", function()
    return typeof(getscripthash) == "function"
end)

test("getsenv", function()
    return typeof(getsenv) == "function"
end)

test("getrawmetatable", function()
    if typeof(getrawmetatable) ~= "function" then return false end
    local tbl = setmetatable({}, { __index = function() end })
    return getrawmetatable(tbl) ~= nil
end)

test("hookmetamethod", function()
    return typeof(hookmetamethod) == "function"
end)

test("getnamecallmethod", function()
    return typeof(getnamecallmethod) == "function"
end)

test("setnamecallmethod", function()
    return typeof(setnamecallmethod) == "function"
end)

test("setrawmetatable", function()
    if typeof(setrawmetatable) ~= "function" or typeof(getrawmetatable) ~= "function" then return false end
    local tbl = {}
    local meta = { __index = "valid" }
    setrawmetatable(tbl, meta)
    return getrawmetatable(tbl) == meta
end)

test("setreadonly", function()
    if typeof(setreadonly) ~= "function" or typeof(isreadonly) ~= "function" then return false end
    local tbl = {}
    setreadonly(tbl, true)
    local isRO = isreadonly(tbl)
    setreadonly(tbl, false)
    return isRO and not isreadonly(tbl)
end)

test("isreadonly", function()
    if typeof(isreadonly) ~= "function" then return false end
    local tbl = {}
    return isreadonly(tbl) == false
end)

test("identifyexecutor", function()
    local fn = identifyexecutor or getexecutorname
    if typeof(fn) ~= "function" then return false end
    local name = fn()
    return typeof(name) == "string"
end)

test("gethwid", function()
    return typeof(gethwid) == "function"
end)

test("getthreadidentity", function()
    local fn = getthreadidentity or getidentity or getthreadcontext
    if typeof(fn) ~= "function" then return false end
    return typeof(fn()) == "number"
end)

test("setthreadidentity", function()
    return typeof(setthreadidentity) == "function" or typeof(setidentity) == "function" or typeof(setthreadcontext) == "function"
end)

test("getgenv", function()
    if typeof(getgenv) ~= "function" then return false end
    return typeof(getgenv()) == "table"
end)

test("getrenv", function()
    if typeof(getrenv) ~= "function" then return false end
    return typeof(getrenv()) == "table"
end)

test("getreg", function()
    local fn = getreg or (debug and debug.getregistry)
    return typeof(fn) == "function"
end)

test("getgc", function()
    return typeof(getgc) == "function"
end)

test("getloadedscripts", function()
    return typeof(getloadedscripts) == "function"
end)

test("getscripts", function()
    return typeof(getscripts) == "function"
end)

test("isrbxactive", function()
    local fn = isrbxactive or iswindowactive
    return typeof(fn) == "function"
end)

test("request", function()
    local req = request or http_request or (syn and syn.request)
    return typeof(req) == "function"
end)

test("setclipboard", function()
    local fn = setclipboard or toclipboard
    return typeof(fn) == "function"
end)

test("setfpscap", function()
    return typeof(setfpscap) == "function"
end)

test("WebSocket.connect", function()
    return typeof(WebSocket) == "table" and typeof(WebSocket.connect) == "function"
end)

print("\n=================== [ xUNC SOFT BENCHMARK ] ===================")
for _, res in ipairs(results) do
    print(res)
end

local percentage = math.floor((passes / total) * 100)

print("---------------------------------------------------------------")
print(string.format("📊 Final Score: %d%% (%d/%d Functions Verified)", percentage, passes, total))
print(string.format("Passed: %d | Failed: %d | Unknown: %d", passes, fails, undefined))
print(string.format("💻 Executor: %s", getExecutor()))
print("===============================================================\n")
