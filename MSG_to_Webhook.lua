local DiscorduserID = "" -- Add your Discord IDs inorder to get Ping

local name
local Text
local world

AddHook("onvariant", "packet", function(var)
    if var[0] == "OnConsoleMessage" then
        if var[1]:find("%[MSG%]") then
            local msg = var[1]
            msg = msg:gsub("`.", "")
            name = msg:match("from %(.-%)"):match("%((.-)%)")
            Text = msg:match(">([^>]+)$")
            world = msg:match("in %[(.-)%]")
            WeeBhooks()
        end
    end
end)

function WeeBhooks()
    local Sendme = "" -- Place Your Webhook link
    local requestBody = [[
    {
        "content": "<@]]..DiscorduserID..[[>", 
        "embeds": [
            {
                "title": "You've Got a Message",
                "description": "**From:** ]] .. name .. [[\n**Message:** ]] .. Text .. [[\n**World:** ]] .. world .. [[",
                "color": 8421504,
                "fields": [
                    {
                        "name": "",
                        "value": "",
                        "inline": false
                    }
                ]
            }
        ],
        "username": "MSG Receiver",
        "avatar_url": "",
        "attachments": []
    }
    ]]
    MakeRequest(Sendme, "POST", {["Content-Type"] = "application/json"}, requestBody)
end