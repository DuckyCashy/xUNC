local request = request or http_request or (syn and syn.request)

local function registerHttpTests(Runner)
    Runner.Register("HTTP Request Functionality (request)", function()
        if not request then
            return false, "No valid request function found"
        end
        
        local success, response = pcall(function()
            return request({
                Url = "https://httpbin.org/get",
                Method = "GET"
            })
        end)
        
        if not success or type(response) ~= "table" then
            return false, "Request failed or returned invalid response format"
        end
        
        if response.StatusCode ~= 200 or not string.find(tostring(response.Body), "httpbin") then
            return false, "HTTP response body verification failed"
        end
        
        return true
    end)
end

return registerHttpTests
