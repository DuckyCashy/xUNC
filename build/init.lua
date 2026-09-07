local passes = 0
local fails = 0
local undefined = 0
local total = 0

local results = {}

local function test(name, aliases, callback)
    total = total + 1
    task.wait(0.005)

    local success, result, errReason = pcall(function()
        return callback()
    end)

    if success then
        if result == true then
            passes = passes + 1
            table.insert(results, "🟢 " .. name)
        elseif result == "FAIL" or result == false then
            fails = fails + 1
            table.insert(results, "🔴 " .. name .. (errReason and (" (" .. tostring(errReason) .. ")") or ""))
        else
            undefined = undefined + 1
            table.insert(results, "🟡 " .. name .. " (Returned non-boolean value)")
        end
    else
        fails = fails + 1
        table.insert(results, "🔴 " .. name .. " (Error: " .. tostring(result):gsub("\n", " ") .. ")")
    end
end

print("⚡ [xUNC] Executing full UNC functional benchmark suite...")

test("cache.invalidate", {}, function()
    local container = Instance.new("Folder")
    local part = Instance.new("Part", container)
    cache.invalidate(container:FindFirstChild("Part"))
    return container:FindFirstChild("Part") ~= part
end)

test("cache.iscached", {}, function()
    local part = Instance.new("Part")
    return cache.iscached(part)
end)

test("cache.replace", {}, function()
    local part1 = Instance.new("Part")
    local part2 = Instance.new("Part")
    cache.replace(part1, part2)
    return true
end)

test("cloneref", {}, function()
    local part = Instance.new("Part")
    local clone = cloneref(part)
    return part ~= clone and part == clone
end)

test("compareinstances", {}, function()
    local part = Instance.new("Part")
    local clone = cloneref(part)
    return compareinstances(part, clone)
end)

test("checkcaller", {}, function()
    return checkcaller() == true
end)

test("clonefunction", {}, function()
    local function dummy() return "xUNC" end
    local cloned = clonefunction(dummy)
    return dummy ~= cloned and cloned() == "xUNC"
end)

test("getcallingscript", {}, function()
    return getcallingscript() == nil or type(getcallingscript()) == "userdata"
end)

test("hookfunction", {}, function()
    local function target() return false end
    local ref
    ref = hookfunction(target, function() return true end)
    local state = target()
    hookfunction(target, ref)
    return state == true
end)

test("iscclosure", {}, function()
    return iscclosure(print) == true and iscclosure(function() end) == false
end)

test("islclosure", {}, function()
    return islclosure(print) == false and islclosure(function() end) == true
end)

test("isexecutorclosure", {"checkclosure", "isourclosure"}, function()
    local fn = isexecutorclosure or checkclosure or isourclosure
    return fn(fn) == true and fn(print) == false
end)

test("loadstring", {}, function()
    local fn, err = loadstring("return 1337")
    return type(fn) == "function" and fn() == 1337
end)

test("newcclosure", {}, function()
    local fn = newcclosure(function() return true end)
    return iscclosure(fn) and fn() == true
end)

test("crypt.b64encode", {}, function()
    return crypt.b64encode("xUNC") == "eFVOQw=="
end)

test("crypt.b64decode", {}, function()
    return crypt.b64decode("eFVOQw==") == "xUNC"
end)

test("crypt.encrypt", {}, function()
    local key = crypt.generatekey()
    local encrypted, iv = crypt.encrypt("xUNC", key)
    local decrypted = crypt.decrypt(encrypted, key, iv)
    return decrypted == "xUNC"
end)

test("crypt.generatebytes", {}, function()
    local bytes = crypt.generatebytes(16)
    return #crypt.b64decode(bytes) == 16
end)

test("crypt.generatekey", {}, function()
    local key = crypt.generatekey()
    return #crypt.b64decode(key) == 32
end)

test("crypt.hash", {}, function()
    local algorithms = { "sha1", "sha256", "sha512", "md5" }
    for _, algo in ipairs(algorithms) do
        local hash = crypt.hash("xUNC", algo)
        if type(hash) ~= "string" or #hash == 0 then return false end
    end
    return true
end)

test("debug.getconstant", {}, function()
    local function target() print("xUNC_Const") end
    return debug.getconstant(target, 1) == "print" or debug.getconstant(target, 2) == "xUNC_Const"
end)

test("debug.getconstants", {}, function()
    local function target() print("xUNC_Const") end
    local consts = debug.getconstants(target)
    return table.find(consts, "print") ~= nil or table.find(consts, "xUNC_Const") ~= nil
end)

test("debug.getinfo", {}, function()
    local info = debug.getinfo(print)
    return type(info) == "table" and info.what == "C"
end)

test("debug.getproto", {}, function()
    local function parent()
        local function child() return "nested" end
    end
    local proto = debug.getproto(parent, 1)
    return type(proto) == "function"
end)

test("debug.getprotos", {}, function()
    local function parent()
        local function child1() end
        local function child2() end
    end
    local protos = debug.getprotos(parent)
    return #protos == 2
end)

test("debug.getstack", {}, function()
    local stack
    local function target()
        local localVal = "active"
        stack = debug.getstack(1)
    end
    target()
    return type(stack) == "table"
end)

test("debug.getupvalue", {}, function()
    local upval = "upvalue_val"
    local function target() return upval end
    return debug.getupvalue(target, 1) == "upvalue_val"
end)

test("debug.getupvalues", {}, function()
    local upval = "upvalue_val"
    local function target() return upval end
    local upvals = debug.getupvalues(target)
    return upvals[1] == "upvalue_val"
end)

test("debug.setconstant", {}, function()
    local function target() return "old" end
    debug.setconstant(target, 1, "new")
    return target() == "new"
end)

test("debug.setstack", {}, function()
    local function target()
        local val = "orig"
        debug.setstack(1, 1, "modified")
        return val
    end
    return target() == "modified"
end)

test("debug.setupvalue", {}, function()
    local upval = "orig"
    local function target() return upval end
    debug.setupvalue(target, 1, "modified")
    return target() == "modified"
end)

test("Drawing.new", {}, function()
    local obj = Drawing.new("Line")
    local isValid = obj and type(obj.Remove) == "function"
    if isValid then obj:Remove() end
    return isValid
end)

test("Drawing.Fonts", {}, function()
    return type(Drawing.Fonts) == "table" and Drawing.Fonts.UI ~= nil
end)

test("isrenderobj", {}, function()
    local obj = Drawing.new("Text")
    local renderState = isrenderobj(obj)
    obj:Remove()
    return renderState == true
end)

test("getrenderproperty", {}, function()
    local obj = Drawing.new("Text")
    obj.Text = "xUNC"
    local text = getrenderproperty(obj, "Text")
    obj:Remove()
    return text == "xUNC"
end)

test("setrenderproperty", {}, function()
    local obj = Drawing.new("Text")
    setrenderproperty(obj, "Text", "Updated")
    local text = obj.Text
    obj:Remove()
    return text == "Updated"
end)

test("cleardrawcache", {}, function()
    cleardrawcache()
    return true
end)

test("writefile", {}, function()
    writefile("xunc_test.txt", "testing")
    return isfile("xunc_test.txt")
end)

test("readfile", {}, function()
    return readfile("xunc_test.txt") == "testing"
end)

test("appendfile", {}, function()
    appendfile("xunc_test.txt", "_append")
    return readfile("xunc_test.txt") == "testing_append"
end)

test("loadfile", {}, function()
    writefile("xunc_load.lua", "return 'loaded'")
    local fn = loadfile("xunc_load.lua")
    local res = fn()
    delfile("xunc_load.lua")
    return res == "loaded"
end)

test("listfiles", {}, function()
    local files = listfiles("")
    return type(files) == "table" and #files > 0
end)

test("isfile", {}, function()
    return isfile("xunc_test.txt") == true and isfile("non_existent_file.txt") == false
end)

test("makefolder", {}, function()
    makefolder("xunc_folder")
    return isfolder("xunc_folder")
end)

test("isfolder", {}, function()
    return isfolder("xunc_folder") == true and isfolder("non_existent_folder") == false
end)

test("delfolder", {}, function()
    delfolder("xunc_folder")
    return not isfolder("xunc_folder")
end)

test("delfile", {}, function()
    delfile("xunc_test.txt")
    return not isfile("xunc_test.txt")
end)

test("fireclickdetector", {}, function()
    local detector = Instance.new("ClickDetector")
    fireclickdetector(detector, 0)
    return true
end)

test("fireproximityprompt", {}, function()
    local prompt = Instance.new("ProximityPrompt")
    fireproximityprompt(prompt)
    return true
end)

test("firetouchinterest", {}, function()
    local p1 = Instance.new("Part")
    local p2 = Instance.new("Part")
    firetouchinterest(p1, p2, 0)
    firetouchinterest(p1, p2, 1)
    return true
end)

test("getcallbackvalue", {}, function()
    local bindable = Instance.new("BindableFunction")
    local fn = function() end
    bindable.OnInvoke = fn
    return getcallbackvalue(bindable, "OnInvoke") == fn
end)

test("getconnections", {}, function()
    local bindable = Instance.new("BindableEvent")
    local conn = bindable.Event:Connect(function() end)
    local conns = getconnections(bindable.Event)
    conn:Disconnect()
    return type(conns) == "table" and #conns > 0
end)

test("getcustomasset", {}, function()
    writefile("xunc_asset.png", "fake_data")
    local assetId = getcustomasset("xunc_asset.png")
    delfile("xunc_asset.png")
    return type(assetId) == "string" and #assetId > 0
end)

test("gethiddenproperty", {}, function()
    local fire = Instance.new("Fire")
    local val, isHidden = gethiddenproperty(fire, "size_xml")
    return val ~= nil
end)

test("sethiddenproperty", {}, function()
    local fire = Instance.new("Fire")
    local success = sethiddenproperty(fire, "size_xml", 10)
    return success == true or gethiddenproperty(fire, "size_xml") == 10
end)

test("getinstances", {}, function()
    local insts = getinstances()
    return type(insts) == "table" and #insts > 0
end)

test("getnilinstances", {}, function()
    local insts = getnilinstances()
    return type(insts) == "table" and #insts > 0
end)

test("getscriptbytecode", {"getscriptcode"}, function()
    local fn = getscriptbytecode or getscriptcode
    local script = Instance.new("LocalScript")
    local bc = fn(script)
    return type(bc) == "string"
end)

test("getscripthash", {}, function()
    local script = Instance.new("LocalScript")
    return type(getscripthash(script)) == "string"
end)

test("getsenv", {}, function()
    local script = Instance.new("LocalScript")
    return type(getsenv(script)) == "table" or getsenv(script) == nil
end)

test("getrawmetatable", {}, function()
    local tbl = setmetatable({}, { __index = function() end })
    return getrawmetatable(tbl) ~= nil
end)

test("hookmetamethod", {}, function()
    local obj = setmetatable({}, { __namecall = function() return "orig" end })
    local ref
    ref = hookmetamethod(obj, "__namecall", function(...) return "hooked" end)
    return obj:test() == "hooked"
end)

test("getnamecallmethod", {}, function()
    local method
    local obj = setmetatable({}, {
        __namecall = function(self)
            method = getnamecallmethod()
            return true
        end
    })
    obj:TestMethod()
    return method == "TestMethod"
end)

test("setnamecallmethod", {}, function()
    local obj = setmetatable({}, {
        __namecall = function(self)
            setnamecallmethod("NewMethod")
            return getnamecallmethod()
        end
    })
    return obj:TestMethod() == "NewMethod"
end)

test("setrawmetatable", {}, function()
    local tbl = {}
    local meta = { __index = "valid" }
    setrawmetatable(tbl, meta)
    return getrawmetatable(tbl) == meta
end)

test("setreadonly", {}, function()
    local tbl = {}
    setreadonly(tbl, true)
    local isRO = isreadonly(tbl)
    setreadonly(tbl, false)
    return isRO and not isreadonly(tbl)
end)

test("isreadonly", {}, function()
    local tbl = {}
    return isreadonly(tbl) == false
end)

test("identifyexecutor", {"getexecutorname"}, function()
    local fn = identifyexecutor or getexecutorname
    local name, ver = fn()
    return type(name) == "string"
end)

test("gethwid", {}, function()
    return type(gethwid()) == "string"
end)

test("getthreadidentity", {"getidentity", "getthreadcontext"}, function()
    local fn = getthreadidentity or getidentity or getthreadcontext
    return type(fn()) == "number"
end)

test("setthreadidentity", {"setidentity", "setthreadcontext"}, function()
    local setFn = setthreadidentity or setidentity or setthreadcontext
    local getFn = getthreadidentity or getidentity or getthreadcontext
    local orig = getFn()
    setFn(3)
    local updated = getFn()
    setFn(orig)
    return updated == 3
end)

test("getgenv", {}, function()
    return type(getgenv()) == "table" and getgenv().getgenv ~= nil
end)

test("getrenv", {}, function()
    return type(getrenv()) == "table" and getrenv().print ~= nil
end)

test("getreg", {"getregistry"}, function()
    local fn = getreg or (debug and debug.getregistry)
    return type(fn()) == "table"
end)

test("getgc", {}, function()
    return type(getgc()) == "table" and #getgc() > 0
end)

test("getloadedscripts", {}, function()
    return type(getloadedscripts()) == "table"
end)

test("getscripts", {}, function()
    return type(getscripts()) == "table"
end)

test("isrbxactive", {"iswindowactive"}, function()
    local fn = isrbxactive or iswindowactive
    return type(fn()) == "boolean"
end)

test("request", {"http_request"}, function()
    local req = request or http_request or (syn and syn.request)
    local response = req({ Url = "https://httpbin.org/get", Method = "GET" })
    return type(response) == "table" and response.StatusCode == 200
end)

test("setclipboard", {"toclipboard"}, function()
    local fn = setclipboard or toclipboard
    fn("xUNC_Test")
    return true
end)

test("setfpscap", {}, function()
    setfpscap(60)
    return true
end)

test("WebSocket.connect", {}, function()
    return type(WebSocket) == "table" and type(WebSocket.connect) == "function"
end)

print("\n=================== [ xUNC TEST BENCHMARK ] ===================")
for _, res in ipairs(results) do
    print(res)
end

local percentage = math.floor((passes / total) * 100)

print("---------------------------------------------------------------")
print(string.format("📊 Final Score: %d%% (%d/%d Tests Passed)", percentage, passes, total))
print(string.format("Passed: %d | Failed/Missing: %d | Warnings: %d", passes, fails, undefined))
print("===============================================================\n")
