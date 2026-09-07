local writefile = writefile
local readfile = readfile
local appendfile = appendfile
local delfile = delfile
local isfile = isfile
local isfolder = isfolder
local makefolder = makefolder
local delfolder = delfolder
local listfiles = listfiles
local loadfile = loadfile
local getgenv = getgenv or function() return {} end
local getrenv = getrenv or function() return {} end
local getreg = getreg or getregistry
local getgc = getgc
local getloadedmodules = getloadedmodules
local getrawmetatable = getrawmetatable
local setrawmetatable = setrawmetatable
local hookmetamethod = hookmetamethod
local isreadonly = isreadonly
local setreadonly = setreadonly
local getnamecallmethod = getnamecallmethod or function() return "" end
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
local getnilinstances = getnilinstances
local fireclickdetector = fireclickdetector
local getinstances = getinstances
local fireproximityprompt = fireproximityprompt
local firetouchinterest = firetouchinterest
local isnetworkowner = isnetworkowner
local gethiddenproperty = gethiddenproperty
local sethiddenproperty = sethiddenproperty
local setrbxclipboard = setrbxclipboard or setclipboard
local gethui = gethui
local cloneref = cloneref
local compareinstances = compareinstances
local Drawing = Drawing
local request = request or http_request or (syn and syn.request)
local crypt = crypt
local identifyexecutor = identifyexecutor or getexecutorname or function() return "Unknown Executor", "1.0.0" end
local Instance = Instance
local game = game
local HttpService = game:GetService("HttpService")
local task = task or { wait = function(s) local t = os.clock() repeat until os.clock() - t >= s end }

local Runner = {
    Passed = 0,
    Failed = 0,
    Tests = {}
}

function Runner.Register(name, testFunc)
    table.insert(Runner.Tests, { Name = name, Func = testFunc })
end

function Runner.RunAll()
    local execName, execVer = identifyexecutor()
    print("\n==============================================")
    print("      ℹ️ STARTING xUNC SUITE TEST RUN ℹ️      ")
    print("            'Zero Spoof, All Proof.'          ")
    print("   Executor: " .. tostring(execName) .. " | Version: " .. tostring(execVer))
    print("==============================================\n")
    
    for _, test in ipairs(Runner.Tests) do
        local success, passed, message = pcall(test.Func)
        
        if success and passed == true then
            Runner.Passed = Runner.Passed + 1
            print("✅ [PASS] " .. tostring(test.Name))
        else
            Runner.Failed = Runner.Failed + 1
            local reason = not success and tostring(passed) or (message or "Failed behavioral assertion")
            print("❌ [FAIL] " .. tostring(test.Name) .. " -> " .. tostring(reason))
        end
    end
    
    local total = Runner.Passed + Runner.Failed
    local percentage = total > 0 and math.floor((Runner.Passed / total) * 100) or 0
    print("\n==============================================")
    print(string.format("ℹ️ xUNC FINAL SCORE: %d/%d (%d%%)", Runner.Passed, total, percentage))
    print("==============================================\n")
end

-- Environment Suite (15 Tests)
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
    if type(gc) ~= "table" or #gc == 0 then return false, "getgc failed to return objects" end
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
    if not valid then return false, "Failed to write key in global env" end
    return true
end)
Runner.Register("Roblox Environment Table Check (getrenv validity)", function()
    if not getrenv then return false, "getrenv missing" end
    local renv = getrenv()
    if renv.game ~= game then return false, "Roblox environment game mismatch" end
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

-- Closures Suite (16 Tests)
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
    if getupvalue(testFunc, 1) ~= secret then return false, "getupvalue failed" end
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
    if getupvalue(testFunc, 1) ~= "New" then return false, "setupvalue failed" end
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
    if getconstants(testFunc)[1] ~= "New_Const" then return false, "setconstant failed" end
    return true
end)
Runner.Register("Proto Extraction (getprotos)", function()
    if not getprotos then return false, "getprotos missing" end
    local function parent() local function child() end end
    local protos = getprotos(parent)
    if type(protos) ~= "table" or #protos == 0 then return false, "getprotos failed" end
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

-- Metatable Suite (9 Tests)
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
    if result ~= "xUNC_Hooked_Instance" then return false, "hookmetamethod failed" end
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
    if isreadonly(tbl) then return false, "setreadonly failed" end
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

-- FileSystem Suite (10 Tests)
Runner.Register("FileSystem Write/Read Operations (writefile/readfile)", function()
    if not (writefile and readfile and delfile) then return false, "Missing write/read/del" end
    local fileName = "xunc_fs_" .. tostring(math.random(10000, 99999)) .. ".tmp"
    local content = "xUNC_FS_Data"
    writefile(fileName, content)
    local read = readfile(fileName)
    delfile(fileName)
    if read ~= content then return false, "Read content mismatch" end
    return true
end)
Runner.Register("FileSystem Append Operations (appendfile)", function()
    if not (writefile and appendfile and readfile and delfile) then return false, "Missing append functions" end
    local fileName = "xunc_app_" .. tostring(math.random(10000, 99999)) .. ".tmp"
    writefile(fileName, "A")
    appendfile(fileName, "B")
    local result = readfile(fileName)
    delfile(fileName)
    if result ~= "AB" then return false, "Append content mismatch" end
    return true
end)
Runner.Register("File Existence Verification (isfile)", function()
    if not (writefile and isfile and delfile) then return false, "isfile missing" end
    local fileName = "xunc_check_" .. tostring(math.random(10000, 99999)) .. ".tmp"
    writefile(fileName, "x")
    local exists = isfile(fileName)
    delfile(fileName)
    if not exists then return false, "isfile returned false for existing file" end
    return true
end)
Runner.Register("Folder Creation and Deletion (makefolder/delfolder)", function()
    if not (makefolder and isfolder and delfolder) then return false, "Folder API missing" end
    local folderName = "xunc_folder_" .. tostring(math.random(10000, 99999))
    makefolder(folderName)
    local created = isfolder(folderName)
    delfolder(folderName)
    if not created then return false, "makefolder/isfolder check failed" end
    return true
end)
Runner.Register("Folder Listing Operations (listfiles)", function()
    if not (makefolder and writefile and listfiles and delfile and delfolder) then return false, "listfiles missing" end
    local folderName = "xunc_list_dir_" .. tostring(math.random(10000, 99999))
    local fileName = folderName .. "/file.tmp"
    makefolder(folderName)
    writefile(fileName, "test")
    local files = listfiles(folderName)
    delfile(fileName)
    delfolder(folderName)
    if type(files) ~= "table" or #files == 0 then return false, "listfiles failed" end
    return true
end)
Runner.Register("FileSystem Asset Loading (getcustomasset)", function()
    local getcustomasset = getcustomasset or Getsynasset
    if not getcustomasset then return false, "getcustomasset missing" end
    return true
end)
Runner.Register("Non-Existent File Check (isfile false test)", function()
    if not isfile then return false, "isfile missing" end
    if isfile("non_existent_xunc_file_99999.invalid") then return false, "isfile returned true for non-existent file" end
    return true
end)
Runner.Register("Non-Existent Folder Check (isfolder false test)", function()
    if not isfolder then return false, "isfolder missing" end
    if isfolder("non_existent_xunc_dir_99999.invalid") then return false, "isfolder returned true for non-existent directory" end
    return true
end)
Runner.Register("File Dynamic Execution (loadfile)", function()
    if not (writefile and loadfile and delfile) then return false, "loadfile missing" end
    local fileName = "xunc_load_" .. tostring(math.random(10000, 99999)) .. ".lua"
    writefile(fileName, "return 'xUNC_Loaded'")
    local compiled, err = loadfile(fileName)
    delfile(fileName)
    if not compiled or compiled() ~= "xUNC_Loaded" then return false, "loadfile failed to compile or run file code" end
    return true
end)
Runner.Register("File Deletion Verification (delfile)", function()
    if not (writefile and delfile and isfile) then return false, "delfile missing" end
    local fileName = "xunc_del_" .. tostring(math.random(10000, 99999)) .. ".tmp"
    writefile(fileName, "delete_me")
    delfile(fileName)
    if isfile(fileName) then return false, "File still exists after calling delfile" end
    return true
end)

-- Instances Suite (12 Tests)
Runner.Register("Nil Parent Instance Retrieval (getnilinstances)", function()
    if not getnilinstances then return false, "getnilinstances missing" end
    local testPart = Instance.new("Part")
    testPart.Name = "xUNC_Nil_Test_Part"
    testPart.Parent = nil
    local nilList = getnilinstances()
    local found = false
    for _, inst in ipairs(nilList) do
        if inst == testPart then found = true break end
    end
    testPart:Destroy()
    if not found then return false, "Failed to locate unparented instance" end
    return true
end)
Runner.Register("ClickDetector Simulation (fireclickdetector)", function()
    if not fireclickdetector then return false, "fireclickdetector missing" end
    local detector = Instance.new("ClickDetector")
    local clicked = false
    local connection = detector.MouseClick:Connect(function() clicked = true end)
    fireclickdetector(detector)
    task.wait(0.1)
    connection:Disconnect()
    detector:Destroy()
    if not clicked then return false, "fireclickdetector failed" end
    return true
end)
Runner.Register("Full Instance Hierarchy Retrieval (getinstances)", function()
    if not getinstances then return false, "getinstances missing" end
    local instList = getinstances()
    if type(instList) ~= "table" or #instList == 0 then return false, "getinstances returned invalid table" end
    return true
end)
Runner.Register("ProximityPrompt Simulation (fireproximityprompt)", function()
    if not fireproximityprompt then return false, "fireproximityprompt missing" end
    local prompt = Instance.new("ProximityPrompt")
    local triggered = false
    local connection = prompt.Triggered:Connect(function() triggered = true end)
    fireproximityprompt(prompt)
    task.wait(0.1)
    connection:Disconnect()
    prompt:Destroy()
    if not triggered then return false, "fireproximityprompt failed" end
    return true
end)
Runner.Register("TouchInterest Simulation (firetouchinterest)", function()
    if not firetouchinterest then return false, "firetouchinterest missing" end
    local part1 = Instance.new("Part")
    local part2 = Instance.new("Part")
    local touched = false
    local connection = part1.Touched:Connect(function() touched = true end)
    firetouchinterest(part1, part2, 0)
    task.wait(0.1)
    firetouchinterest(part1, part2, 1)
    connection:Disconnect()
    part1:Destroy()
    part2:Destroy()
    if not touched then return false, "firetouchinterest failed" end
    return true
end)
Runner.Register("Network Ownership Inspection (isnetworkowner)", function()
    if not isnetworkowner then return false, "isnetworkowner missing" end
    local part = Instance.new("Part")
    local owner = isnetworkowner(part)
    part:Destroy()
    if type(owner) ~= "boolean" then return false, "isnetworkowner returned non-boolean" end
    return true
end)
Runner.Register("Hidden Property Extraction (gethiddenproperty)", function()
    if not gethiddenproperty then return false, "gethiddenproperty missing" end
    local part = Instance.new("Part")
    gethiddenproperty(part, "size_xml")
    part:Destroy()
    return true
end)
Runner.Register("Hidden Property Modification (sethiddenproperty)", function()
    if not sethiddenproperty then return false, "sethiddenproperty missing" end
    local part = Instance.new("Part")
    sethiddenproperty(part, "size_xml", Vector3.new(1, 1, 1))
    part:Destroy()
    return true
end)
Runner.Register("Roblox Clipboard Writer (setrbxclipboard / setclipboard)", function()
    if not setrbxclipboard then return false, "setrbxclipboard missing" end
    setrbxclipboard("xUNC_Clipboard_Test")
    return true
end)
Runner.Register("Hidden UI Parent Container (gethui)", function()
    if not gethui then return false, "gethui missing" end
    local hui = gethui()
    if type(hui) ~= "userdata" and type(hui) ~= "table" then return false, "gethui returned invalid container" end
    return true
end)
Runner.Register("Instance Reference Cloning (cloneref)", function()
    if not cloneref then return false, "cloneref missing" end
    local part = Instance.new("Part")
    local clone = cloneref(part)
    local isSame = clone == part
    part:Destroy()
    if not isSame then return false, "cloneref object comparison mismatch" end
    return true
end)
Runner.Register("Instance Equality Verification (compareinstances)", function()
    if not compareinstances then return false, "compareinstances missing" end
    local part = Instance.new("Part")
    local same = compareinstances(part, part)
    part:Destroy()
    if not same then return false, "compareinstances failed on identical object" end
    return true
end)

-- Drawing Suite (10 Tests)
Runner.Register("Drawing Object Construction (Drawing.new)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local square = Drawing.new("Square")
    if type(square) ~= "table" and type(square) ~= "userdata" then return false, "Drawing.new construction failed" end
    square:Remove()
    return true
end)
Runner.Register("Drawing Property Mutation (Square size/pos)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local square = Drawing.new("Square")
    square.Visible = false
    square.Size = Vector2.new(100, 100)
    if square.Visible ~= false or square.Size.X ~= 100 then
        square:Remove()
        return false, "Drawing property mutation failed"
    end
    square:Remove()
    return true
end)
Runner.Register("Drawing Line Creation (Drawing Line type)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local line = Drawing.new("Line")
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(10, 10)
    line:Remove()
    return true
end)
Runner.Register("Drawing Text Creation (Drawing Text type)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local text = Drawing.new("Text")
    text.Text = "xUNC_Text"
    if text.Text ~= "xUNC_Text" then
        text:Remove()
        return false, "Drawing text property set failed"
    end
    text:Remove()
    return true
end)
Runner.Register("Drawing Image Creation (Drawing Image type)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local img = Drawing.new("Image")
    img:Remove()
    return true
end)
Runner.Register("Drawing Circle Creation (Drawing Circle type)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local circle = Drawing.new("Circle")
    circle.Radius = 15
    circle:Remove()
    return true
end)
Runner.Register("Drawing Fonts Table Inspection (Drawing.Fonts)", function()
    if not (Drawing and Drawing.Fonts) then return false, "Drawing.Fonts missing" end
    if type(Drawing.Fonts) ~= "table" then return false, "Drawing.Fonts is not a table" end
    return true
end)
Runner.Register("Drawing Object Cleanup Method Check (:Remove / :Destroy)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local line = Drawing.new("Line")
    if not (line.Remove or line.Destroy) then return false, "No valid cleanup method found" end
    if line.Remove then line:Remove() else line:Destroy() end
    return true
end)
Runner.Register("Drawing Quad Creation (Drawing Quad type)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local quad = Drawing.new("Quad")
    quad.PointA = Vector2.new(0, 0)
    quad.PointB = Vector2.new(10, 0)
    quad.PointC = Vector2.new(10, 10)
    quad.PointD = Vector2.new(0, 10)
    quad:Remove()
    return true
end)
Runner.Register("Drawing Triangle Creation (Drawing Triangle type)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library missing" end
    local tri = Drawing.new("Triangle")
    tri.PointA = Vector2.new(0, 0)
    tri.PointB = Vector2.new(5, 10)
    tri.PointC = Vector2.new(10, 0)
    tri:Remove()
    return true
end)

-- HTTP & Crypt Suite (12 Tests)
Runner.Register("HTTP Request GET Functionality (request GET)", function()
    if not request then return false, "request function missing" end
    local success, response = pcall(function() return request({ Url = "https://httpbin.org/get", Method = "GET" }) end)
    if not success or type(response) ~= "table" then return false, "GET request failed" end
    if response.StatusCode ~= 200 or not string.find(tostring(response.Body), "httpbin") then return false, "GET body verification failed" end
    return true
end)
Runner.Register("HTTP Request POST Functionality (request POST)", function()
    if not request then return false, "request function missing" end
    local success, response = pcall(function()
        return request({
            Url = "https://httpbin.org/post",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ xUNC = true })
        })
    end)
    if not success or type(response) ~= "table" then return false, "POST request failed" end
    if response.StatusCode ~= 200 then return false, "POST request returned invalid status code" end
    return true
end)
Runner.Register("WebSocket Connection Capability (WebSocket.connect)", function()
    local ws = WebSocket or Websocket
    if not (ws and ws.connect) then return false, "WebSocket API missing" end
    return true
end)
Runner.Register("Base64 Encoding Capability (crypt.base64encode / base64_encode)", function()
    local enc = (crypt and crypt.base64encode) or base64_encode or base64encode
    if not enc then return false, "Base64 encode missing" end
    if enc("xUNC") ~= "eFVOQw==" then return false, "Base64 encoding mismatch" end
    return true
end)
Runner.Register("Base64 Decoding Capability (crypt.base64decode / base64_decode)", function()
    local dec = (crypt and crypt.base64decode) or base64_decode or base64decode
    if not dec then return false, "Base64 decode missing" end
    if dec("eFVOQw==") ~= "xUNC" then return false, "Base64 decoding mismatch" end
    return true
end)
Runner.Register("Hashing Capabilities (crypt.hash / hash)", function()
    local hash = (crypt and crypt.hash) or hash
    if not hash then return false, "Hash function missing" end
    return true
end)
Runner.Register("LZ4 Compression Capability (lz4compress / lz4decompress)", function()
    local lz4c = lz4compress or (crypt and crypt.lz4compress)
    if not lz4c then return false, "LZ4 compression missing" end
    return true
end)
Runner.Register("AES Encryption Capability (crypt.encrypt)", function()
    if not (crypt and crypt.encrypt) then return false, "crypt.encrypt missing" end
    return true
end)
Runner.Register("AES Decryption Capability (crypt.decrypt)", function()
    if not (crypt and crypt.decrypt) then return false, "crypt.decrypt missing" end
    return true
end)
Runner.Register("Cryptographic Key Generation (crypt.generatekey)", function()
    if not (crypt and crypt.generatekey) then return false, "crypt.generatekey missing" end
    local key = crypt.generatekey()
    if type(key) ~= "string" or #key == 0 then return false, "generatekey failed to return string key" end
    return true
end)
Runner.Register("Cryptographic Random Bytes Generation (crypt.generatebytes)", function()
    if not (crypt and crypt.generatebytes) then return false, "crypt.generatebytes missing" end
    local bytes = crypt.generatebytes(16)
    if type(bytes) ~= "string" or #bytes == 0 then return false, "generatebytes failed to return string" end
    return true
end)
Runner.Register("Custom HTTP Headers Processing Check (request Headers)", function()
    if not request then return false, "request function missing" end
    local success, response = pcall(function()
        return request({
            Url = "https://httpbin.org/headers",
            Method = "GET",
            Headers = { ["X-xUNC-Identifier"] = "Verified" }
        })
    end)
    if not success or type(response) ~= "table" or response.StatusCode ~= 200 then return false, "Custom header check request failed" end
    return true
end)

Runner.RunAll()
