local Drawing = Drawing

local function registerDrawingTests(Runner)
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
end

return registerDrawingTests
