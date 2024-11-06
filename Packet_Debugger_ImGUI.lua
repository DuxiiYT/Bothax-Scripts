-- Home Key - Toggle on / off

local IsMenuVisible = true;

local function SendTextOverlay(Text)
    SendVariantList({
        [0] = 'OnTextOverlay',
        [1] = Text
    })
end

local CaptureTextPacket = true;
local TextPacket = "";

local CaptureVarlist = true;
local VarlistText = '';

local CaptureRawPacket = true;
local RawPacketText = '';

local CaptureIncomingRawPacket = true;
local IncomingRawPacketText = '';

local function WriteFile(Path, Content)
    local f = io.open(Path, 'w')
    if f then
        f:write(Content);
        f:close();
    end
end

local function DrawMenu()
    if IsMenuVisible == true then
        ImGui.SetNextWindowSize(ImVec2(520, 365))
        if ImGui.Begin('ImGui Packet Debugger', true, (2)) then
            if ImGui.BeginTabBar("pktDebugger") then

                if ImGui.BeginTabItem("Text Packet") then
                    ImGui.InputTextMultiline("##textPacketText", TextPacket, 999999, ImVec2(500, 300), 16384)
                    ImGui.EndTabItem();
                end

                if ImGui.BeginTabItem("Variant List") then
                    ImGui.InputTextMultiline("##varlistText", VarlistText, 999999, ImVec2(500, 300), 16384)
                    ImGui.EndTabItem();
                end

                if ImGui.BeginTabItem("Raw Packet") then
                    ImGui.InputTextMultiline("##rawPacketText", RawPacketText, 999999, ImVec2(500, 300), 16384)
                    ImGui.EndTabItem();
                end

                if ImGui.BeginTabItem("Incoming Raw Packet") then
                    ImGui.InputTextMultiline("##incRawPacketText", IncomingRawPacketText, 999999, ImVec2(500, 300), 16384)
                    ImGui.EndTabItem();
                end

                if ImGui.BeginTabItem("Settings") then
                    if ImGui.Checkbox('Capture Text Packet', CaptureTextPacket) then
                        CaptureTextPacket = not CaptureTextPacket;
                    end
                    if ImGui.Checkbox('Capture Variant List', CaptureVarlist) then
                        CaptureVarlist = not CaptureVarlist;
                    end
                    if ImGui.Checkbox('Capture Raw Packet', CaptureRawPacket) then
                        CaptureRawPacket = not CaptureRawPacket;
                    end
                    if ImGui.Checkbox('Capture Incoming Raw Packet', CaptureIncomingRawPacket) then
                        CaptureIncomingRawPacket = not CaptureIncomingRawPacket;
                    end

                    ImGui.Spacing();
                    ImGui.Separator();
                    ImGui.Spacing();

                    if ImGui.Button('Clear Text Packet Logs') then
                        TextPacket = '';
                        SendTextOverlay('Cleared `2Text Packet``!')
                    end

                    if ImGui.Button('Clear Variant List Logs') then
                        VarlistText = '';
                        SendTextOverlay('Cleared `2Variant List Logs``!')
                    end

                    if ImGui.Button('Clear Raw Packet Logs') then
                        RawPacketText = '';
                        SendTextOverlay('Cleared `2Raw Packet Logs``!')
                    end

                    if ImGui.Button('Clear Incoming Raw Packet Logs') then
                        IncomingRawPacketText = '';
                        SendTextOverlay('Cleared `2Incoming Raw Packet Logs``!')
                    end

                    ImGui.Spacing();
                    ImGui.Separator();
                    ImGui.Spacing();

                    if ImGui.Button('Save everything to a file!') then
                        -- Desktop <3
                        local FinalPath = os.getenv('USERPROFILE') .. '\\Desktop';
                        WriteFile(FinalPath .. '\\TextPacket.txt', TextPacket)
                        WriteFile(FinalPath .. '\\VariantList.txt', VarlistText)
                        WriteFile(FinalPath .. '\\RawPacket.txt', RawPacketText)
                        WriteFile(FinalPath .. '\\IncomingRawPacket.txt', IncomingRawPacketText)
                        SendTextOverlay('Files were saved on your `2desktop``!')
                    end

                    ImGui.EndTabItem();
                end

                ImGui.EndTabBar();
            end
            ImGui.End();
        end
    end
end

AddHook('OnDraw', 'drawhook', DrawMenu)
AddHook('OnInput', 'inputHook', function (Key)
    if Key == 36 then
        IsMenuVisible = not IsMenuVisible;
        SendTextOverlay('Packet Debugger Menu: ' .. (IsMenuVisible and '`2Visible``!' or '`4Hidden``!'))
    end
end)

AddHook('OnSendPacket', 'pkt', function (type, pkt)
    if CaptureTextPacket == true then
        TextPacket = TextPacket .. '[Type: ' .. type .. ']\n' .. pkt .. '\n\n'
    end
end)

AddHook('OnVariant', 'varHook', function (v, netid)
    if CaptureVarlist == true then
        VarlistText = VarlistText .. '[0]: ' .. v[0] .. '\n';
        for i = 1, 5 do
            if v[i] ~= nil then
                if type(v[i]) == 'table' then
                    local TableText = '{';
                    for k, v in pairs(v[i]) do
                        TableText = TableText .. k .. ' = ' .. v .. ','
                    end
                    TableText = TableText:sub(0, TableText:len() - 1) .. '}'
                    VarlistText = VarlistText .. '['..i..']: ' .. TableText .. '\n'
                else
                    VarlistText = VarlistText .. '['..i..']: ' .. v[i] .. '\n'
                end
            end
        end
        VarlistText = VarlistText .. 'NetID: ' .. netid .. '\n\n'
    end
end)

AddHook('OnSendPacketRaw', 'onrawpkt', function (pkt, flags)
    if CaptureRawPacket == true then
        local Text = 'SendPacketRaw(false, {\n'
        for k, v in pairs(pkt) do
            Text = Text .. '    ' .. k .. ' = ' .. v .. ',\n'
        end
        Text = Text .. '})\n'
        RawPacketText = RawPacketText .. Text .. '\n';
    end
end)

AddHook('OnProcessTankUpdatePacket', 'onincpkt', function (pkt)
    if CaptureIncomingRawPacket == true then
        local Text = 'SendPacketRaw(true, {\n'
        for k, v in pairs(pkt) do
            Text = Text .. '    ' .. k .. ' = ' .. v .. ',\n'
        end
        Text = Text .. '})\n'
        IncomingRawPacketText = IncomingRawPacketText .. Text .. '\n';
    end
end)