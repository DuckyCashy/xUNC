local SecurityEngine = {}
SecurityEngine.__index = SecurityEngine

function SecurityEngine.new()
    local self = setmetatable({}, SecurityEngine)
    self.SecretKey = "xUNC_Secure_Signature_Key_" .. tostring(math.random(100000, 999999))
    return self
end

function SecurityEngine:ValidateCClosure(func)
    if typeof(func) ~= "function" then
        return false
    end

    local isC = false
    if typeof(iscclosure) == "function" then
        isC = iscclosure(func)
    elseif typeof(debug) == "table" and typeof(debug.getinfo) == "function" then
        local info = debug.getinfo(func)
        isC = typeof(info) == "table" and info.what == "C"
    end

    local success = pcall(function()
        if typeof(debug) == "table" and typeof(debug.getinfo) == "function" then
            return debug.getinfo(func, "n")
        end
    end)
    
    if not success then
        return false
    end

    return isC
end

function SecurityEngine:VerifyCallStack()
    if typeof(debug) ~= "table" or typeof(debug.getinfo) ~= "function" then
        return false
    end

    local level = 1
    local frames = {}

    while true do
        local success, info = pcall(debug.getinfo, level, "s1n")
        if not success or not info then break end
        
        table.insert(frames, {
            Level = level,
            Source = info
        })
        level = level + 1
        if level > 50 then break end
    end

    return #frames > 0
end

function SecurityEngine:HashString(str)
    local hash = 5381
    for i = 1, #str do
        local byte = string.byte(str, i)
        hash = ((hash * 32) + hash) + byte
    end
    return tostring(hash)
end

function SecurityEngine:SignResults(executorName, passes, total)
    local rawPayload = string.format("%s:%d/%d:%s", executorName, passes, total, self.SecretKey)
    local signature = nil

    if typeof(crypt) == "table" and typeof(crypt.hash) == "function" then
        signature = crypt.hash(rawPayload, "sha256")
    else
        signature = self:HashString(rawPayload)
    end

    return signature
end

return SecurityEngine
