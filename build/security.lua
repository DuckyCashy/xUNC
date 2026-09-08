local SecurityEngine = {}
SecurityEngine.__index = SecurityEngine

function SecurityEngine.new()
    local self = setmetatable({}, SecurityEngine)
    self.SecretKey = "xUNC_Secure_Signature_Key_" .. tostring(math.random(100000, 999999))
    return self
end

function SecurityEngine:ValidateCClosure(func)
    if type(func) ~= "function" then
        return false, "Target is not a function"
    end

    local isC = false
    if iscclosure then
        isC = iscclosure(func)
    else
        isC = debug.info(func, "s") == "[C]"
    end

    local success, name = pcall(debug.info, func, "n")
    if not success then
        return false, "Closure info spoof detected"
    end

    return isC
end

function SecurityEngine:VerifyCallStack()
    local level = 1
    local frames = {}

    while true do
        local info = debug.info(level, "s1n")
        if not info then break end
        
        table.insert(frames, {
            Level = level,
            Source = info
        })
        level = level + 1
        if level > 50 then break end
    end

    return #frames > 0, frames
end

function SecurityEngine:HashString(str)
    local hash = 5381
    for i = 1, #str do
        local byte = string.byte(str, i)
        hash = ((hash * 32) + hash) + byte
    end
    return tostring(hash)
end

function SecurityEngine:SignResults(executorName, passedTests, totalTests)
    local rawPayload = string.format("%s:%d/%d:%s", executorName, passedTests, totalTests, self.SecretKey)
    local signature = nil

    if crypt and crypt.hash then
        signature = crypt.hash(rawPayload, "sha256")
    else
        signature = self:HashString(rawPayload)
    end

    return {
        Executor = executorName,
        Passed = passedTests,
        Total = totalTests,
        Signature = signature,
        Verified = true
    }
end

return SecurityEngine
