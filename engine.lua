local left = peripheral.wrap("left")
local right = peripheral.wrap("right")

right.setTargetSpeed(0)
left.setTargetSpeed(0)

local modem = peripheral.find("modem")
local mSend, mRecieve = 100, 100 --送受信ポート番号
modem.open(mRecieve)

local keys = {}
local speed_Variations = { 46, 92, 138, 186, 212, 256} --nギアごとの回転速度
local speed = 0 
local gear = 0

local function process_Messages()
    while true do
        local _, _, _, _, msg, _ = os.pullEvent("modem_message")
       if msg.id == 15999 then
            keys = msg.keys
        end
    end
end

local function setSpeed(speedl,speedr)
    left.setTargetSpeed(speedl)
    right.setTargetSpeed(speedr)
end

local function key ()
    while true do
        if keys.s then
            if keys.a then
                setSpeed(-speed/4, speed)
            elseif keys.d then
                setSpeed(speed, -speed/4)
            else setSpeed(speed, speed) end
        elseif keys.w then 
            if keys.a then
                setSpeed(speed/4, -speed)
            elseif keys.d then
                setSpeed(-speed, speed/4)
            else setSpeed(-speed, -speed) end
        elseif keys.a then
            setSpeed(-speed, speed)
        elseif keys.d then
            setSpeed(speed, -speed)
        else setSpeed(0, 0) end
        os.pullEvent()
    end
end 
local function gearbox()
    local access = true
    while true do
        if access then
            if keys.r and gear < 6 then --ギア数(ここでは6)
                gear = gear + 1
                access = false
                print("Gear:", gear, "Speed:", speed_Variations[gear])  
            end
            if keys.f and gear > 0 then
                gear = gear - 1
                access = false
                print("Gear:", gear, "Speed:", speed_Variations[gear])  
            end
        end
        if not keys.r and not keys.f then access = true end
        
        if gear == 0 then
            speed = 0
        else
            speed = speed_Variations[gear] or 0  
        end
        
        os.pullEvent()
    end
end
	

parallel.waitForAll(
    process_Messages,
key,
gearbox
)

