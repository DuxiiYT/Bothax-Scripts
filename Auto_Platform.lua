platform_id = 3126 -- Custom platform
delay_place = 10 -- Custom Delay
starty, endy = 1, 199 -- Change to 1, 99 for normal world
startx, endx = 0, 199

ChangeValue("[C] Modfly", true)

function place(id, x, y)
    local pkt = {
        type = 3,
        value = id,
        px = math.floor(GetLocal().pos.x / 32 + x),
        py = math.floor(GetLocal().pos.y / 32 + y),
        x = GetLocal().pos.x,
        y = GetLocal().pos.y
    }
    SendPacketRaw(false, pkt)
end

function findItem(id)
    for _, itm in pairs(GetInventory()) do
        if itm.id == id then
            return itm.amount
        end
    end
    return 0
end

function placeplat()
    for y = starty, endy, 2 do
        for x = startx, endx do
            if GetTile(x, y).fg == 0 then
                LogToConsole("Put Plat at ("..x..","..y..")")
                FindPath(x + 1, y, 100)
                Sleep(delay_place)
                place(platform_id, -1, 0)
                Sleep(delay_place)
                while findItem(platform_id) == 0 do
                    SendPacket(2, "action|dialog_return\ndialog_name|item_search\n"..platform_id.."|1\n"..platform_id + 1 .."|0")
                    Sleep(2000)
                end
            end
        end
    end
end

while true do
    placeplat()
end