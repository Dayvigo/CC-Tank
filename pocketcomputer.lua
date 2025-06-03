local modem = peripheral.find("modem") 
local mSend, mRecieve = 100, 100 --送受信ポート番号(お好みで)

local keys_ = { --キーバインドはお好みで
    w = false, s = false, a = false, d = false,
    space = false,
    t = false,
    r = false,
    f = false,
    i = false,
    up = false, down = false, left = false, right = false,
    enter = false
}

local function handleKeys()
    while true do
        local event, keyCode = os.pullEvent()
        if event == "key" or event == "key_up" then
            local keyName = keys.getName(keyCode)
            if keys_[keyName] ~= nil then
                keys_[keyName] = (event == "key")
                print(keyName, event)
            end
        end
    end
end

local function sendLoop()
    while true do
        modem.transmit(mSend, mRecieve, {
            id = 15999,
            keys = keys_
        })
        sleep(0.01)  
    end
end

parallel.waitForAll(handleKeys, sendLoop)
