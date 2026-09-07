local Drawing = Drawing
local task = task or { wait = function(s) local t = os.clock() repeat until os.clock() - t >= s end }

local function registerDrawingTests(Runner)
    Runner.Register("Drawing Library Operations (Drawing.new)", function()
        if not (Drawing and Drawing.new) then
            return false, "Drawing library or Drawing.new missing"
        end
        
        local square = Drawing.new("Square")
        if type(square) ~= "table" and type(square) ~= "userdata" then
            return false, "Drawing.new failed to construct object"
        end
        
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
end

return registerDrawingTests
