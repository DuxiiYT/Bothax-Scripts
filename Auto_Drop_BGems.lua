Made by Wakka


```lua
BGems = 1e6 -- Howmany bgems u want to drops
            -- e1=0 (puluhan)
            -- e2=00 (ratusan)
            -- e3=000 (ribuan)
            -- e4=0000 (puluhan ribu)
            -- e5=00000 (ratusan ribu)
            -- e6=000000 (jutaan)

AddHook("onvariant", "Wakka", function(var)
    if var[0] == "OnDialogRequest" and var[1]:find("`bThe Black Backpack") then
        return true
    end
    return false
end)

local function scanObject(id)
    local count = 0
    for _, object in pairs(GetObjectList()) do
        if object.id == id then
            count = count + object.amount
        end
    end
    return count
end

local function dropTheGems()
    local BGemsDropAmount = 0
    while scanObject(15212) < BGems do
        SendPacket(2, "action|dialog_return\ndialog_name|popup\nbuttonClicked|bgem_dropall")
        Sleep(250)
        end
    end

dropTheGems()
```