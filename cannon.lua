local modem = peripheral.find("modem")
local cannon = peripheral.find("cbcmodernwarfare:compact_mount") -- MWのマウントを想定
local mSend, mRecive = 100, 100 --送受信ポート番号
modem.open(mRecive)

local keys = {}
local nPitch = cannon.getPitch() 
local sPitch = nPitch
local nPitch = math.max(-30, math.min(60, sPitch))

local function process_Messages()
    while true do
        local _, _, _, _, msg = os.pullEvent("modem_message")
        if type(msg) == "table" and msg.id == 15999 and type(msg.keys) == "table" then
            keys = msg.keys
        end
    end
end

local function cannonPitch()
    while true do
        if keys.r then 
            sPitch = sPitch + 3
            cannon.setPitch(sPitch)
        elseif keys.f then
            sPitch = sPitch - 3
            cannon.setPitch(sPitch)
        end
        sleep(0.01) 
    end
end

local function cannonFire()
    while true do
        if keys.enter then
            cannon.fire()
        end
        sleep(0.01)
    end
    
end
parallel.waitForAll(process_Messages, cannonPitch,cannonFire)