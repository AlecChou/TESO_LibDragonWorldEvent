LibDragonWorldEvent.DragonStatus = {}

-- @var table : List of all status which can be defined
LibDragonWorldEvent.DragonStatus.list = {
    unknown = "unknown",
    killed  = "killed",
    waiting = "waiting",
    fight   = "fight",
    weak    = "weak",
    flying  = "flying",
}

-- @var table : All map pin available and the corresponding status
LibDragonWorldEvent.DragonStatus.mapPinList = {
    [MAP_PIN_TYPE_DRAGON_IDLE_HEALTHY]   = LibDragonWorldEvent.DragonStatus.list.waiting,
    [MAP_PIN_TYPE_DRAGON_IDLE_WEAK]      = LibDragonWorldEvent.DragonStatus.list.waiting,
    [MAP_PIN_TYPE_DRAGON_COMBAT_HEALTHY] = LibDragonWorldEvent.DragonStatus.list.fight,
    [MAP_PIN_TYPE_DRAGON_COMBAT_WEAK]    = LibDragonWorldEvent.DragonStatus.list.weak,
}

--[[
-- Initialise the status for a dragon
--
-- @param Dragon dragon : The dragon with the status to initialise
--]]
function LibDragonWorldEvent.DragonStatus:initForDragon(dragon)
    local status = self:convertMapPin(dragon.unit.pin)
    dragon:resetWithStatus(status)

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragonStatus.initDragon,
        self,
        dragon
    )
end

--[[
-- Check the status for all dragon instancied
--]]
function LibDragonWorldEvent.DragonStatus:checkAllDragon()
    LibDragonWorldEvent.DragonList:execOnAll(self.checkForDragon)

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragonStatus.checkAllDragon,
        self
    )
end

--[[
-- Check the status for a specific dragon.
-- It's a callback for DragonList:execOnAll
--
-- @param Dragon dragon The dragon to check
--]]
function LibDragonWorldEvent.DragonStatus.checkForDragon(dragon)
    dragon:updateUnit()
    local realStatus = LibDragonWorldEvent.DragonStatus:convertMapPin(dragon.unit.pin)

    if dragon.status.current ~= realStatus then
        dragon:resetWithStatus(realStatus)
    end
    
    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragonStatus.checkDragon,
        self,
        dragon
    )
end

--[[
-- Convert from MAP_PIN_TYPE_DRAGON_* constant to a status in the list
--
-- @param number mapPin The dragon map pin
--
-- @return string
--]]
function LibDragonWorldEvent.DragonStatus:convertMapPin(mapPin)
    local status = self.mapPinList[mapPin]

    if status == nil then
        return self.list.killed
    else
        return status
    end
end
