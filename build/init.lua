local passes = 0
local fails = 0
local undefined = 0
local total = 0

local results = {}

local function test(name, callback)
    total = total + 1
    task.wait(0.03)

    local success, result = pcall(function()
        return callback()
    end)

    if success then
        if result == true then
            passes = passes + 1
            table.insert(results, "🟢 " .. name)
        elseif result == false then
            fails = fails + 1
            table.insert(results, "🔴 " .. name)
        else
            undefined = undefined + 1
            table.insert(results, "🟡 " .. name)
        end
    else
        fails = fails + 1
        table.insert(results, "🔴 " .. name)
    end
end

print("⚡ [xUNC] Executing UNC benchmark suite...")

test("cache.invalidate", function()
    if typeof(cache) ~= "table" or typeof(cache.invalidate) ~= "function" then return false end
    local container = Instance.new("Folder")
    local part = Instance.new("Part", container)
    cache.invalidate(container:FindFirstChild("Part"))
    return container:FindFirstChild("Part") ~= part
end)

test("cache.iscached", function()
    if typeof(cache) ~= "table" or typeof(cache.iscached) ~= "function" then return false end
    local part = Instance.new("Part")
    return cache.iscached(part)
end)

test("cache.replace", function()
    if typeof(cache) ~= "table" or typeof(cache.replace) ~= "function" then return false end
    local part1 = Instance.new("Part")
    local part2 = Instance.new("Part")
    cache.replace(part1, part2)
    return true
end)

test("cloneref", function()
    if typeof(cloneref) ~= "function" then return false end
    local part = Instance.new("Part")
    local clone = cloneref(part)
    return part ~= clone and part == clone
end)

test("compareinstances", function()
    if typeof(compareinstances) ~= "function" then return false end
    local part = Instance.new("Part")
    local clone = cloneref(part)
    return compareinstances(part, clone)
end)

test("checkcaller", function()
    if typeof(checkcaller) ~= "function" then return false end
    return checkcaller() == true
end)

test("clonefunction", function()
    if typeof(clonefunction) ~= "function" then return false end
    local function dummy() return "xUNC" end
    local cloned = clonefunction(dummy)
    return dummy ~= cloned and cloned() == "xUNC"
end)

test("getcallingscript", function()
    if typeof(getcallingscript) ~= "function" then return false end
    return getcallingscript() == nil or typeof(getcallingscript()) == "Instance"
end)

test("hookfunction", function()
    if typeof(hookfunction) ~= "function" then return false end
    local function target() return false end
    local ref
    ref = hookfunction(target, function() return true end)
    local state = target()
    hookfunction(target, ref)
    return state == true
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
    return table.find(consts, "print") ~= nil or table.find(consts, "xUNC_Const") ~= nil
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
    return typeof(protos) == "table" and #protos == 2
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
    if typeof(debug) ~= "table" or typeof(debug.setconstant) ~= "function" then return false end
    local function target() return "old" end
    debug.setconstant(target, 1, "new")
    return target() == "new"
end)

test("debug.setstack", function()
    if typeof(debug) ~= "table" or typeof(debug.setstack) ~= "function" then return false end
    local function target()
        local val = "orig"
        debug.setstack(1, 1, "modified")
        return val
    end
    return target() == "modified"
end)

test("debug.setupvalue", function()
    if typeof(debug) ~= "table" or typeof(debug.setupvalue) ~= "function" then return false end
    local upval = "orig"
    local function target() return upval end
    debug.setupvalue(target, 1, "modified")
    return target() == "modified"
end)

test("Drawing.new", function()
    if typeof(Drawing) ~= "table" or typeof(Drawing.new) ~= "function" then return false end
    local obj = Drawing.new("Line")
    local isValid = obj and typeof(obj.Remove) == "function"
    if isValid then obj:Remove() end
    return isValid
end)

test("Drawing.Fonts", function()
    if typeof(Drawing) ~= "table" then return false end
    return typeof(Drawing.Fonts) == "table" and Drawing.Fonts.UI ~= nil
end)

test("isrenderobj", function()
    if typeof(isrenderobj) ~= "function" or typeof(Drawing) ~= "table" or typeof(Drawing.new) ~= "function" then return false end
    local obj = Drawing.new("Text")
    local renderState = isrenderobj(obj)
    if obj and typeof(obj.Remove) == "function" then obj:Remove() end
    return renderState == true
end)

test("getrenderproperty", function()
    if typeof(getrenderproperty) ~= "function" or typeof(Drawing) ~= "table" or typeof(Drawing.new) ~= "function" then return false end
    local obj = Drawing.new("Text")
    obj.Text = "xUNC"
    local text = getrenderproperty(obj, "Text")
    if obj and typeof(obj.Remove) == "function" then obj:Remove() end
    return text == "xUNC"
end)

test("setrenderproperty", function()
    if typeof(setrenderproperty) ~= "function" or typeof(Drawing) ~= "table" or typeof(Drawing.new) ~= "function" then return false end
    local obj = Drawing.new("Text")
    setrenderproperty(obj, "Text", "Updated")
    local text = obj.Text
    if obj and typeof(obj.Remove) == "function" then obj:Remove() end
    return text == "Updated"
end)

test("cleardrawcache", function()
    if typeof(cleardrawcache) ~= "function" then return false end
    cleardrawcache()
    return true
end)

test("writefile", function()
    if typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then return false end
    writefile("xunc_test.txt", "testing")
    return isfile("xunc_test.txt")
end)

test("readfile", function()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" or not isfile("xunc_test.txt") then return false end
    return readfile("xunc_test.txt") == "testing"
end)

test("appendfile", function()
    if typeof(appendfile) ~= "function" or typeof(readfile) ~= "function" or typeof(isfile) ~= "function" or not isfile("xunc_test.txt") then return false end
    appendfile("xunc_test.txt", "_append")
    return readfile("xunc_test.txt") == "testing_append"
end)

test("loadfile", function()
    if typeof(loadfile) ~= "function" or typeof(writefile) ~= "function" or typeof(delfile) ~= "function" then return false end
    writefile("xunc_load.lua", "return 'loaded'")
    local fn = loadfile("xunc_load.lua")
    local res = typeof(fn) == "function" and fn() or nil
    delfile("xunc_load.lua")
    return res == "loaded"
end)

test("listfiles", function()
    if typeof(listfiles) ~= "function" then return false end
    local files = listfiles("")
    return typeof(files) == "table"
end)

test("isfile", function()
    if typeof(isfile) ~= "function" then return false end
    return isfile("xunc_test.txt") == true and isfile("non_existent_file.txt") == false
end)

test("makefolder", function()
    if typeof(makefolder) ~= "function" or typeof(isfolder) ~= "function" then return false end
    makefolder("xunc_folder")
    return isfolder("xunc_folder")
end)

test("isfolder", function()
    if typeof(isfolder) ~= "function" then return false end
    return isfolder("xunc_folder") == true and isfolder("non_existent_folder") == false
end)

test("delfolder", function()
    if typeof(delfolder) ~= "function" or typeof(isfolder) ~= "function" then return false end
    if isfolder("xunc_folder") then delfolder("xunc_folder") end
    return not isfolder("xunc_folder")
end)

test("delfile", function()
    if typeof(delfile) ~= "function" or typeof(isfile) ~= "function" then return false end
    if isfile("xunc_test.txt") then delfile("xunc_test.txt") end
    return not isfile("xunc_test.txt")
end)

test("fireclickdetector", function()
    if typeof(fireclickdetector) ~= "function" then return false end
    local detector = Instance.new("ClickDetector")
    fireclickdetector(detector, 0)
    return true
end)

test("fireproximityprompt", function()
    if typeof(fireproximityprompt) ~= "function" then return false end
    local prompt = Instance.new("ProximityPrompt")
    fireproximityprompt(prompt)
    return true
end)

test("firetouchinterest", function()
    if typeof(firetouchinterest) ~= "function" then return false end
    local p1 = Instance.new("Part")
    local p2 = Instance.new("Part")
    firetouchinterest(p1, p2, 0)
    firetouchinterest(p1, p2, 1)
    return true
end)

test("getcallbackvalue", function()
    if typeof(getcallbackvalue) ~= "function" then return false end
    local bindable = Instance.new("BindableFunction")
    local fn = function() end
    bindable.OnInvoke = fn
    return getcallbackvalue(bindable, "OnInvoke") == fn
end)

test("getconnections", function()
    if typeof(getconnections) ~= "function" then return false end
    local bindable = Instance.new("BindableEvent")
    local conn = bindable.Event:Connect(function() end)
    local conns = getconnections(bindable.Event)
    conn:Disconnect()
    return typeof(conns) == "table" and #conns > 0
end)

test("getcustomasset", function()
    if typeof(getcustomasset) ~= "function" or typeof(writefile) ~= "function" or typeof(delfile) ~= "function" then return false end
    writefile("xunc_asset.png", "fake_data")
    local assetId = getcustomasset("xunc_asset.png")
    delfile("xunc_asset.png")
    return typeof(assetId) == "string" and #assetId > 0
end)

test("gethiddenproperty", function()
    if typeof(gethiddenproperty) ~= "function" then return false end
    local fire = Instance.new("Fire")
    local val = gethiddenproperty(fire, "size_xml")
    return val ~= nil
end)

test("sethiddenproperty", function()
    if typeof(sethiddenproperty) ~= "function" then return false end
    local fire = Instance.new("Fire")
    local success = sethiddenproperty(fire, "size_xml", 10)
    return success == true
end)

test("getinstances", function()
    if typeof(getinstances) ~= "function" then return false end
    local insts = getinstances()
    return typeof(insts) == "table" and #insts > 0
end)

test("getnilinstances", function()
    if typeof(getnilinstances) ~= "function" then return false end
    local insts = getnilinstances()
    return typeof(insts) == "table" and #insts > 0
end)

test("getscriptbytecode", function()
    local fn = getscriptbytecode or getscriptcode
    if typeof(fn) ~= "function" then return false end
    local script = Instance.new("LocalScript")
    local bc = fn(script)
    return typeof(bc) == "string"
end)

test("getscripthash", function()
    if typeof(getscripthash) ~= "function" then return false end
    local script = Instance.new("LocalScript")
    return typeof(getscripthash(script)) == "string"
end)

test("getsenv", function()
    if typeof(getsenv) ~= "function" then return false end
    local script = Instance.new("LocalScript")
    return typeof(getsenv(script)) == "table" or getsenv(script) == nil
end)

test("getrawmetatable", function()
    if typeof(getrawmetatable) ~= "function" then return false end
    local tbl = setmetatable({}, { __index = function() end })
    return getrawmetatable(tbl) ~= nil
end)

test("hookmetamethod", function()
    if typeof(hookmetamethod) ~= "function" then return false end
    local obj = setmetatable({}, { __namecall = function() return "orig" end })
    local ref
    ref = hookmetamethod(obj, "__namecall", function(...) return "hooked" end)
    return obj:test() == "hooked"
end)

test("getnamecallmethod", function()
    if typeof(getnamecallmethod) ~= "function" then return false end
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

test("setnamecallmethod", function()
    if typeof(setnamecallmethod) ~= "function" or typeof(getnamecallmethod) ~= "function" then return false end
    local obj = setmetatable({}, {
        __namecall = function(self)
            setnamecallmethod("NewMethod")
            return getnamecallmethod()
        end
    })
    return obj:TestMethod() == "NewMethod"
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
    if typeof(gethwid) ~= "function" then return false end
    return typeof(gethwid()) == "string"
end)

test("getthreadidentity", function()
    local fn = getthreadidentity or getidentity or getthreadcontext
    if typeof(fn) ~= "function" then return false end
    return typeof(fn()) == "number"
end)

test("setthreadidentity", function()
    local setFn = setthreadidentity or setidentity or setthreadcontext
    local getFn = getthreadidentity or getidentity or getthreadcontext
    if typeof(setFn) ~= "function" or typeof(getFn) ~= "function" then return false end
    local orig = getFn()
    setFn(3)
    local updated = getFn()
    setFn(orig)
    return updated == 3
end)

test("getgenv", function()
    if typeof(getgenv) ~= "function" then return false end
    return typeof(getgenv()) == "table" and getgenv().getgenv ~= nil
end)

test("getrenv", function()
    if typeof(getrenv) ~= "function" then return false end
    return typeof(getrenv()) == "table" and getrenv().print ~= nil
end)

test("getreg", function()
    local fn = getreg or (debug and debug.getregistry)
    if typeof(fn) ~= "function" then return false end
    return typeof(fn()) == "table"
end)

test("getgc", function()
    if typeof(getgc) ~= "function" then return false end
    return typeof(getgc()) == "table" and #getgc() > 0
end)

test("getloadedscripts", function()
    if typeof(getloadedscripts) ~= "function" then return false end
    return typeof(getloadedscripts()) == "table"
end)

test("getscripts", function()
    if typeof(getscripts) ~= "function" then return false end
    return typeof(getscripts()) == "table"
end)

test("isrbxactive", function()
    local fn = isrbxactive or iswindowactive
    if typeof(fn) ~= "function" then return false end
    return typeof(fn()) == "boolean"
end)

test("request", function()
    local req = request or http_request or (syn and syn.request)
    if typeof(req) ~= "function" then return false end
    local response = req({ Url = "https://httpbin.org/get", Method = "GET" })
    return typeof(response) == "table" and response.StatusCode == 200
end)

test("setclipboard", function()
    local fn = setclipboard or toclipboard
    if typeof(fn) ~= "function" then return false end
    fn("xUNC_Test")
    return true
end)

test("setfpscap", function()
    if typeof(setfpscap) ~= "function" then return false end
    setfpscap(60)
    return true
end)

test("WebSocket.connect", function()
    return typeof(WebSocket) == "table" and typeof(WebSocket.connect) == "function"
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
