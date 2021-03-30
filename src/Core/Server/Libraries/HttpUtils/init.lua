local HttpService = game:GetService("HttpService")

local Promise

local function requestAsync(requestFields)
    return Promise.new(function(resolve, reject)
        local response = HttpService:RequestAsync(requestFields)

        if response.Success then
            resolve(response)
        else
            reject(response)
        end
    end)
end

local HttpUtils = {}

function HttpUtils.get(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "GET",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.head(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "HEAD",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.post(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.put(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "PUT",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.delete(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "DELETE",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.connect(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "CONNECT",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.options(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "OPTIONS",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.trace(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "TRACE",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.path(url, headers, body)
    return requestAsync(
        {
            Url = url,
            Method = "PATH",
            Headers = headers,
            Body = body
        }
    )
end

function HttpUtils.formatQueryStrings(baseUrl, queryStrings)
    local url = baseUrl

    local i = 1
    for k,v in pairs(queryStrings) do
        if i == 1 then
            url ..= ("?%s=%s"):format(k, v)
        else
            url ..= ("&%s=%s"):format(k, v)
        end

        i += 1
    end

    return url
end

function HttpUtils:start()
    Promise = self:Load("Cardinal.Promise")
end

return HttpUtils