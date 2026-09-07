local getnilinstances = getnilinstances
local fireclickdetector = fireclickdetector
local Instance = Instance
local task = task or { wait = function(s) local t = os.clock() repeat until os.clock() - t >= s end }

local function registerInstanceTests(Runner)
    Runner.Register("Nil Parent Instance Retrieval (getnilinstances)", function()
        if not getnilinstances then 
            return false, "getnilinstances missing" 
        end
        
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
        
        if not found then
            return false, "Failed to locate unparented instance in nil memory"
        end
        
        return true
    end)

    Runner.Register("ClickDetector Simulation (fireclickdetector)", function()
        if not fireclickdetector then 
            return false, "fireclickdetector missing" 
        end
        
        local detector = Instance.new("ClickDetector")
        local clicked = false
        
        local connection = detector.MouseClick:Connect(function()
            clicked = true
        end)
        
        fireclickdetector(detector)
        task.wait(0.1)
        
        connection:Disconnect()
        detector:Destroy()
        
        if not clicked then
            return false, "fireclickdetector failed to trigger MouseClick event"
        end
        
        return true
    end)
end

return registerInstanceTests
