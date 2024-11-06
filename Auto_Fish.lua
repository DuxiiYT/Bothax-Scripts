local test = false
local x = GetLocal().pos.x
local y = GetLocal().pos.y

function Place(id, x, y)
    local pkt = {}
    pkt.type = 3
    pkt.value = id
    pkt.px = math.floor(GetLocal().pos.x / 32 + x)
    pkt.py = math.floor(GetLocal().pos.y / 32 + y)
    pkt.x = GetLocal().pos.x
    pkt.y = GetLocal().pos.y
    SendPacketRaw(false, pkt)
end

AddHook("onprocesstankupdatepacket", "rp", function(packet)
    if packet.type == 17 then
        Place(3016, -1, 1)
        return true
    end
end)

AddHook("onvariant", "var", function(var)
    if var[0] == "OnConsoleMessage" then
        if var[1]:find("You caught") or var[1]:find("There was") then 
            test = true

            SendPacket(2, "action|input\ntext|`a Hooked up! " .. var[1] .. " ")
            return true
        end
    end
end)

AddHook("onvariant", "var", function(var)
    if var[0] == "OnSDBroadcast" then 

        SendPacket(2, "action|input\ntext|`8SDB Has been `4triggered! ")
        return true
    end
end)

while true do
    if test then
        Sleep(950)
        Place(3016, -1, 1)
        Sleep(250)
        test = false
    end
end