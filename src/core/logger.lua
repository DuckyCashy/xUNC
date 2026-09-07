local Logger = {}

function Logger.Header(version)
    print("\n==============================================")
    print("      ℹ️ STARTING xUNC SUITE TEST RUN ℹ️      ")
    print("            'Zero Spoof, All Proof.'          ")
    print("                Version: " .. tostring(version))
    print("==============================================\n")
end

function Logger.Pass(name)
    print("✅ [PASS] " .. tostring(name))
end

function Logger.Fail(name, reason)
    print("❌ [FAIL] " .. tostring(name) .. " -> " .. tostring(reason))
end

function Logger.Footer(passed, failed)
    local total = passed + failed
    local percentage = total > 0 and math.floor((passed / total) * 100) or 0
    print("\n==============================================")
    print(string.format("ℹ️ xUNC FINAL SCORE: %d/%d (%d%%)", passed, total, percentage))
    print("==============================================\n")
end

return Logger
