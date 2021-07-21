LibDragonWorldEvent.Dragons.DragonList = {}

-- @var table List of all dragons instancied
LibDragonWorldEvent.Dragons.DragonList.list = {}

-- @var number Number of item in list
LibDragonWorldEvent.Dragons.DragonList.nb   = 0

-- @var table Map table with WEInstanceId as key, and index in list as value
LibDragonWorldEvent.Dragons.DragonList.WEInstanceIdToListIdx = {}

--[[
-- Reset the list
--]]
function LibDragonWorldEvent.Dragons.DragonList:reset()
    self.list                  = {}
    self.nb                    = 0
    self.WEInstanceIdToListIdx = {}

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragonList.reset,
        self
    )
end

--[[
-- Add a new dragon to the list
--
-- @param Dragon dragon : The dragon instance to add
--]]
function LibDragonWorldEvent.Dragons.DragonList:add(dragon)
    local newIdx = self.nb + 1

    self.list[newIdx] = dragon
    self.nb           = newIdx

    self.WEInstanceIdToListIdx[dragon.WEInstanceId] = newIdx

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragonList.add,
        self,
        dragon
    )
end

--[[
-- Execute the callback for all dragon
--
-- @param function callback : A callback called for each dragon in the list.
-- The callback take the dragon instance as parameter.
--]]
function LibDragonWorldEvent.Dragons.DragonList:execOnAll(callback)
    local dragonIdx = 1

    for dragonIdx = 1, self.nb do
        callback(self.list[dragonIdx])
    end
end

--[[
-- Obtain the dragon instance for a WEInstanceId
--
-- @return Dragon
--]]
function LibDragonWorldEvent.Dragons.DragonList:obtainForWEInstanceId(WEInstanceId)
    local dragonIdx = self.WEInstanceIdToListIdx[WEInstanceId]

    return self.list[dragonIdx]
end

--[[
-- To update the list : remove all dragon or create all dragon compared to Zone info.
--]]
function LibDragonWorldEvent.Dragons.DragonList:update()
    if LibDragonWorldEvent.Zone.changedZone == true then
        self:removeAll()
    end

    if LibDragonWorldEvent.Dragons.ZoneInfo.onMap == true and self.nb == 0 then
        self:createAll()
    end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragonList.update,
        self
    )
end

--[[
-- Remove all dragon instance in the list and reset GUI items list
--]]
function LibDragonWorldEvent.Dragons.DragonList:removeAll()
    self:reset()

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragonList.removeAll,
        self
    )
end

--[[
-- Create a dragon instance for each dragon in the zone, and add it to the list.
--]]
function LibDragonWorldEvent.Dragons.DragonList:createAll()
    self:removeAll()

    for dragonIdx, WEInstanceId in ipairs(LibDragonWorldEvent.Zone.info.list.WEInstanceId) do
        local dragon = LibDragonWorldEvent.Dragons.Dragon:new(dragonIdx, WEInstanceId)

        self:add(dragon)
    end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragonList.createAll,
        self
    )
end
