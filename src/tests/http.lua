local request = request or http_request or (syn and syn.request)
local HttpService = game:GetService("HttpService")
local crypt = crypt

local function registerHttpTests(Runner)
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
        if not enc then return false, "Base64 encode function missing" end
        if enc("xUNC") ~= "eFVOQw==" then return false, "Base64 encoding output mismatch" end
        return true
    end)

    Runner.Register("Base64 Decoding Capability (crypt.base64decode / base64_decode)", function()
        local dec = (crypt and crypt.base64decode) or base64_decode or base64decode
        if not dec then return false, "Base64 decode function missing" end
        if dec("eFVOQw==") ~= "xUNC" then return false, "Base64 decoding output mismatch" end
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
end

return registerHttpTests
