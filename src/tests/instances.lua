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
local Instance = Instance
local task = task or { wait = function(s) local t = os.clock() repeat until os.clock() - t >= s end }

local function registerInstanceTests(Runner)
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
        if not clicked then return false, "fireclickdetector failed to trigger event" end
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
        if not triggered then return false, "fireproximityprompt failed to trigger event" end
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
        if not touched then return false, "firetouchinterest failed to trigger event" end
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
end

return registerInstanceTests
