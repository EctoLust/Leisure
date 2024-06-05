-- Ported to DST from https://github.com/Gork3m/Lovense.lua
local require = GLOBAL.require

local LovenseSession = {}

do
    local baseUrl = "https://c.lovense-api.com"
    local wsUrl = "wss://c.lovense-api.com"
    local request = syn and syn.request or request
    local connect = syn and syn.websocket.connect or WebSocket.connect
    local JSON =
        setmetatable(
        {},
        {
            __index = function(t, k)
                local prefix = k:sub(1, 2)
                local httpserv = game:GetService("HttpService")
                return function(...)
                    return httpserv["JSON" .. prefix .. "code"](httpserv, ...) -- :troll:
                end
            end
        }
    )

    local mt = {
        __index = LovenseSession
    }
    local function getSessionData(accessCode)
        local httpBoundary = "---------------------------" .. math.random(1, 1000000)
        return request(
            {
                Url = baseUrl .. "/anon/controllink/join",
                Headers = {
                    ["Content-Type"] = "multipart/form-data; boundary=" .. httpBoundary
                },
                Body = "--" ..
                    httpBoundary ..
                        "\r\n" ..
                            'Content-Disposition: form-data; name="id"\r\n\r\n' ..
                                accessCode .. "\r\n" .. "--" .. httpBoundary .. "--\r\n",
                Method = "POST"
            }
        )
    end
    function LovenseSession:new(accessCode)
        local self = setmetatable({}, mt)
        self.debuggingOn = true -- you can change this
        self.accessCode = accessCode
        return self
    end
    function LovenseSession:Connect()
        local data = JSON.Decode(getSessionData(self.accessCode).Body)
        if data.message then
            if self.debuggingOn then
                warn("[LOVENSE] " .. data.message)
            end
            return false
        end
        local ws_url =
            data.data.wsUrl:gsub("https://", "wss://"):gsub("%.com%?", ".com/anon.io/?") .. "&EIO=3&transport=websocket"
        if self.debuggingOn then
            print("[LOVENSE] Access code is valid! Attempting to connect..")
        end
        local _, ws = pcall(connect, ws_url)
        
        assert(_, ws)
        print(_, ws)
        self.active = true
        self.ws = ws
        self.sessionData = data
        local function startsWith(str, start)
            return string.sub(str, 1, string.len(start)) == start
        end
        
        self.connected = false
        local initDone = false
        local hbStarted = false
        ws.OnMessage:Connect(
            function(msg)
                if startsWith(msg, "0") then -- opcode 0: init
                     if self.debuggingOn then
                        print("[LOVENSE] Init payload received")
                    end
                    local wsData = JSON.Decode(msg:sub(2))
                    self.wsData = wsData
                    initDone = true
                elseif startsWith(msg, "40") and initDone and not hbStarted then -- opcode 40: start heartbeating
                    if self.debuggingOn then
                        print("[LOVENSE] Connected!")
                    end
                    self.toys = data.data.controlLinkData.creator.toys
                    self.connected = true
                    hbStarted = true
                    spawn(
                        function()
                            while self.active do
                                ws:Send(tostring(self.wsData.pingCode))
                                wait(self.wsData.pingInterval)
                            end
                        end
                    )
                elseif startsWith(msg, tostring(self.wsData.pongCode)) and initDone then
                    ws:Send('42["anon_open_control_panel_ts",{"linkId":"' .. data.data.controlLinkData.linkId .. '"}]')
                end
            end
        )
        ws.OnClose:Connect(
            function()
                self.active = false
                self.connected = false
            end
        )
        while not self.connected do
            wait()
        end
        return true
    end
    function LovenseSession:Disconnect()
        self.active = false
        self.connected = false
        self.ws:Close()
    end
    function LovenseSession:Vibrate(strength)
        if not self.connected then
            warn("[LOVENSE] Not connected!")
        end

        self.ws:Send(
            '42["anon_command_link_ts",{"toyCommandJson":"{\\"cate\\":\\"id\\",\\"id\\":{\\"' ..
                self.toys[1].id ..
                    '\\":{\\"v\\":-1,\\"v1\\":' ..
                        strength ..
                            ',\\"v2\\":' ..
                                strength ..
                                    ',\\"p\\":-1,\\"r\\":-1}}}","linkId":"' ..
                                        self.sessionData.data.controlLinkData.linkId .. '","userTouch":false}]'
        )
    end
end


GLOBAL.LOVENSECONNECT = function(code)
    print("[LOVENSE] Trying to connect sex toy "..code)
	local session = LovenseSession:new(code)
	if (session:Connect()) then
	    print("[LOVENSE] WHAT THE FUCK?? THIS WORKS!")
	else
	    print("[LOVENSE] Na, connection failed.")
	end
	--session:Vibrate(5) -- from 0 to 20
	--session:Disconnect()
end