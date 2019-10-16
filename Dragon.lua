LibDragonWorldEvent.Dragon = {}
LibDragonWorldEvent.Dragon.__index = LibDragonWorldEvent.Dragon

--[[
-- Instanciate a new Dragon "object"
--
-- @param number dragonIdx The dragon index in DragonList.list
-- @param number WEInstanceId The dragon's WorldEventInstanceId
--
-- @return Dragon
--]]
function LibDragonWorldEvent.Dragon:new(dragonIdx, WEInstanceId)
    local newDragon = {
        dragonIdx    = dragonIdx,
        WEInstanceId = WEInstanceId,
        WEId         = nil,
        title        = {
            cp = LibDragonWorldEvent.Zone.info.dragons.title.cp[dragonIdx],
            ln = LibDragonWorldEvent.Zone.info.dragons.title.ln[dragonIdx]
        },
        unit         = {
            tag = nil,
            pin = nil,
        },
        position     = {
            x = 0,
            y = 0,
            z = 0,
        },
        status       = {
            previous  = nil,
            current   = nil,
            time      = 0,
            justPoped = false,
        },
        repop        = {
            killTime  = 0,
            repopTime = 0,
        },
        fly          = {
            timer     = nil,
            startTime = 0,
        },
    }

    setmetatable(newDragon, self)

    newDragon:updateUnit()
    LibDragonWorldEvent.DragonStatus:initForDragon(newDragon)

    -- Not need, already updated each 1 second
    -- LibDragonWorldEvent.GUI:updateForDragon(newDragon)

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.new,
        newDragon
    )

    return newDragon
end

--[[
-- Update the WorldEventId
--]]
function LibDragonWorldEvent.Dragon:updateWEId()
    self.WEId = GetWorldEventId(self.WEInstanceId)
end

--[[
-- Update the dragon's UnitTag and UnitPinType
--]]
function LibDragonWorldEvent.Dragon:updateUnit()
    self:updateWEId()

    self.unit.tag = GetWorldEventInstanceUnitTag(self.WEInstanceId, 1)
    self.unit.pin = GetWorldEventInstanceUnitPinType(self.WEInstanceId, self.unit.tag)
end

--[[
-- Update dragon position
--
-- @param table|nil position (default nil) Current position
--]]
function LibDragonWorldEvent.Dragon:updatePosition(position)
    if position == nil then
        local position = self:obtainPosition()
    end

    self.position.x = position.x
    self.position.y = position.y
    self.position.z = position.z
end

--[[
-- Obtain and return the current dragonn position
--
-- @return table
--]]
function LibDragonWorldEvent.Dragon:obtainPosition()
    local zoneId, worldX, worldY, worldZ = GetUnitWorldPosition(self.unit.tag)

    return {
        x = worldX,
        y = worldY,
        z = worldZ
    }
end

--[[
-- Change the dragon's current status
--
-- @param string newStatus The dragon's new status in DragonStatus.list
-- @param string unitTag (default nil) The new unitTag
-- @param number unitPin (default nil) The new unitPin
--]]
function LibDragonWorldEvent.Dragon:changeStatus(newStatus, unitTag, unitPin)
    self.status.previous = self.status.current
    self.status.current  = newStatus
    self.status.time     = os.time()

    if self.status.previous == nil or self.status.previous == self.status.current then
        self.status.time = 0
    end

    if unitTag ~= nil then
        self.unit.tag = unitTag
    end

    if unitPin ~= nil then
        self.unit.pin = unitPin
    end

    if self.unit.tag == "invalid" then
        self:updateUnit()
    end

    -- To disable flyTimer if dragon change of status before the end of timer
    -- For example, sometimes, dragon go in fight before to be landed :o
    if self.fly.timer ~= nil and self.status.current ~= LibDragonWorldEvent.DragonStatus.list.flying then
        self.fly.timer:disable()
    end
    
    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.changeStatus,
        self,
        newStatus
    )

    self:execStatusFunction()
end

--[[
-- Reset dragon's status info and define the status with newStatus.
--
-- @param string newStatus The dragon's new status in DragonStatus.list
--]]
function LibDragonWorldEvent.Dragon:resetWithStatus(newStatus)
    self.status.previous = nil
    self.status.current  = newStatus
    self.status.time     = 0

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.resetStatus,
        self,
        newStatus
    )
end

--[[
-- Execute the dedicated function for a status
--]]
function LibDragonWorldEvent.Dragon:execStatusFunction()
    if self.status.current == LibDragonWorldEvent.DragonStatus.list.killed then
        self:killed()
    elseif self.status.current == LibDragonWorldEvent.DragonStatus.list.waiting then
        self:waiting()
    elseif self.status.current == LibDragonWorldEvent.DragonStatus.list.fight then
        self:fight()
    elseif self.status.current == LibDragonWorldEvent.DragonStatus.list.weak then
        self:weak()
    elseif self.status.current == LibDragonWorldEvent.DragonStatus.list.flying then
        self:flying()
    end
end

--[[
-- Called when the dragon (re)pop
--]]
function LibDragonWorldEvent.Dragon:poped()
    self.justPoped       = true
    self.repop.repopTime = os.time()

    if self.unit.tag == "invalid" then
        self:updateUnit()
    end

    if self.repop.killTime ~= 0 then
        local diffTime = self.repop.repopTime - self.repop.killTime
        LibDragonWorldEvent.Zone.repopTime = diffTime
    end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.poped,
        self
    )
end

--[[
-- Called when the dragon is killed
--]]
function LibDragonWorldEvent.Dragon:killed()
    self.repop.killTime = os.time()

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.killed,
        self
    )
end

--[[
-- Called when the dragon start to waiting
--]]
function LibDragonWorldEvent.Dragon:waiting()
    self.flyTimer = nil

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.waiting,
        self
    )
end

--[[
-- Called when the dragon go in fight
--]]
function LibDragonWorldEvent.Dragon:fight()
    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.fight,
        self
    )
end

--[[
-- Called when the dragon is now weak
--]]
function LibDragonWorldEvent.Dragon:weak()
    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.weak,
        self
    )
end

--[[
-- Called when the dragon start to fly
--]]
function LibDragonWorldEvent.Dragon:flying()
    self.fly.startTime = os.time()
    self.fly.timer     = LibDragonWorldEvent.FlyTimer:new(self)

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.flying,
        self
    )
end

--[[
-- Called when the dragon has landed
--]]
function LibDragonWorldEvent.Dragon:onLanded()
    local flyingStatus  = LibDragonWorldEvent.DragonStatus.list.flying
    local waitingStatus = LibDragonWorldEvent.DragonStatus.list.waiting

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.dragon.landed,
        self
    )

    if self.status.current == flyingStatus then
        self:changeStatus(waitingStatus)
    end
end
