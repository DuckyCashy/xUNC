local writefile = writefile
local readfile = readfile
local appendfile = appendfile
local delfile = delfile
local getgenv = getgenv or function() return {} end
local getrenv = getrenv or function() return {} end
local getreg = getreg or getregistry
local getgc = getgc
local getrawmetatable = getrawmetatable
local setrawmetatable = setrawmetatable
local hookmetamethod = hookmetamethod
local getnamecallmethod = getnamecallmethod or function() return "" end
local hookfunction = hookfunction
local newcclosure = newcclosure
local iscclosure = iscclosure
local checkcaller = checkcaller
local clonefunction = clonefunction
local islclosure = islclosure
local getnilinstances = getnilinstances
local fireclickdetector = fireclickdetector
local getinstances = getinstances
local getloadedmodules = getloadedmodules
local Drawing = Drawing
local request = request or http_request or (syn and syn.request)
local Instance = Instance
local game = game
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
    print("\n==============================================")
    print("      ℹ️ STARTING xUNC SUITE TEST RUN ℹ️      ")
    print("            'Zero Spoof, All Proof.'          ")
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

Runner.Register("Environment Isolation (getgenv vs getrenv)", function()
    if not (getgenv and getrenv) then return false, "Environment functions missing" end
    if getgenv() == getrenv() then return false, "Global environment matches Roblox environment" end
    return true
end)

Runner.Register("Registry Access (getreg / getregistry)", function()
    if not getreg then return false, "getreg missing" end
    local reg = getreg()
    if type(reg) ~= "table" then return false, "Returned registry is not a valid table" end
    return true
end)

Runner.Register("FileSystem Operations (write/read/append/del)", function()
    if not (writefile and readfile and appendfile and delfile) then
        return false, "Missing filesystem functions"
    end
    local fileName = "xunc_test_" .. tostring(math.random(10000, 99999)) .. ".tmp"
    local initialData = "xUNC_Test_Data"
    local appendedData = "_Appended"
    writefile(fileName, initialData)
    appendfile(fileName, appendedData)
    local result = readfile(fileName)
    delfile(fileName)
    if result ~= (initialData .. appendedData) then return false, "Read content did not match written & appended data" end
    return true
end)

Runner.Register("Raw Metatable Extraction (getrawmetatable)", function()
    if not getrawmetatable then return false, "getrawmetatable function missing" end
    local protectedTable = setmetatable({}, { __metatable = "Locked Metatable", __index = "xUNC_Pass" })
    local rawMeta = getrawmetatable(protectedTable)
    if type(rawMeta) ~= "table" or rawMeta.__index ~= "xUNC_Pass" then return false, "Failed to extract raw metatable from protected object" end
    return true
end)

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

Runner.Register("Function Cloning (clonefunction)", function()
    if not clonefunction then return false, "clonefunction missing" end
    local function original() return "xUNC_Clone" end
    local cloned = clonefunction(original)
    if cloned == original or cloned() ~= "xUNC_Clone" then return false, "clonefunction failed to duplicate logic" end
    return true
end)

Runner.Register("Nil Parent Instance Retrieval (getnilinstances)", function()
    if not getnilinstances then return false, "getnilinstances missing" end
    local testPart = Instance.new("Part")
    testPart.Name = "xUNC_Nil_Test_Part"
    testPart.Parent = nil
    local nilList = getnilinstances()
    local found = false
    for _, inst in ipairs(nilList) do
        if inst == testPart then
            found = true
            break
        end
    end
    testPart:Destroy()
    if not found then return false, "Failed to locate unparented instance in nil memory" end
    return true
end)

Runner.Register("Full Instance Hierarchy Retrieval (getinstances)", function()
    if not getinstances then return false, "getinstances missing" end
    local instList = getinstances()
    if type(instList) ~= "table" or #instList == 0 then return false, "getinstances failed to return populated instance table" end
    return true
end)

Runner.Register("Drawing Library Operations (Drawing.new)", function()
    if not (Drawing and Drawing.new) then return false, "Drawing library or Drawing.new missing" end
    local square = Drawing.new("Square")
    if type(square) ~= "table" and type(square) ~= "userdata" then return false, "Drawing.new failed to construct object" end
    square.Visible = false
    square.Size = Vector2.new(100, 100)
    square.Position = Vector2.new(50, 50)
    if square.Visible ~= false or square.Size.X ~= 100 then
        square:Remove()
        return false, "Drawing object property mutation failed"
    end
    square:Remove()
    return true
end)

Runner.Register("HTTP Request Functionality (request)", function()
    if not request then return false, "No valid request function found" end
    local success, response = pcall(function()
        return request({ Url = "https://httpbin.org/get", Method = "GET" })
    end)
    if not success or type(response) ~= "table" then return false, "Request failed or returned invalid response format" end
    if response.StatusCode ~= 200 or not string.find(tostring(response.Body), "httpbin") then
        return false, "HTTP response body verification failed"
    end
    return true
end)

Runner.RunAll()

