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

return Runner
