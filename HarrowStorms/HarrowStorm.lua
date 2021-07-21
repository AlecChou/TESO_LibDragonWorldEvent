LibDragonWorldEvent.HarrowStorms.HarrowStorm = {}
LibDragonWorldEvent.HarrowStorms.HarrowStorm.__index = LibDragonWorldEvent.HarrowStorms.HarrowStorm

--[[
-- Instanciate a new Dragon "object"
--
-- @param number harrowStormIdx The harrowStorm index in HarrowStormList.list
-- @param number WEInstanceId The dragon's WorldEventInstanceId
--
-- @return Dragon
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStorm:new(harrowStormIdx)
    local newHarrowStorm = {
        listIdx      = harrowStormIdx,
        WEInstanceId = nil,
        WEId         = nil,
        title        = {
            cp = LibDragonWorldEvent.Zone.info.list.title.cp[harrowStormIdx],
            ln = LibDragonWorldEvent.Zone.info.list.title.ln[harrowStormIdx]
        },
        poi         = {
            zoneIdx = GetZoneIndex(LibDragonWorldEvent.Zone.info.zoneId),
            poiIdx  = LibDragonWorldEvent.Zone.info.list.poiIndices[harrowStormIdx]
        },
        status       = {
            previous  = nil,
            current   = nil,
            time      = 0,
        },
        repop        = {
            endTime  = 0,
            -- repopTime = 0,
        },
    }

    setmetatable(newHarrowStorm, self)

    newHarrowStorm:updateWEInstanceId()
    LibDragonWorldEvent.HarrowStorms.HarrowStormStatus:initForHarrowStorm(newHarrowStorm)

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.harrowStorm.new,
        newHarrowStorm
    )

    return newHarrowStorm
end

--[[
-- Update the WorldEventId
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStorm:updateWEId()
    self.WEId = GetWorldEventId(self.WEInstanceId)
end

--[[
-- Update the WorldEventId
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStorm:updateWEInstanceId()
    self.WEInstanceId = GetPOIWorldEventInstanceId(self.poi.zoneIdx, self.poi.poiIdx)

    if self.WEInstanceId ~= 0 and LibDragonWorldEvent.HarrowStorms.HarrowStormList.currentWEInstanceIdListIdx == 0 then
        LibDragonWorldEvent.HarrowStorms.HarrowStormList.currentWEInstanceIdListIdx = self.listIdx
    end
end

--[[
-- Change the harrowstorm's current status
--
-- @param string newStatus The harrowstorm's new status in HarrowStormstatus.list
-- @param string unitTag (default nil) The new unitTag
-- @param number unitPin (default nil) The new unitPin
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStorm:changeStatus(newStatus, unitTag, unitPin)
    self.status.previous = self.status.current
    self.status.current  = newStatus
    self.status.time     = os.time()

    if self.status.previous == nil or self.status.previous == self.status.current then
        self.status.time = 0
    end
    
    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.harrowStorm.changeStatus,
        self,
        newStatus
    )

    self:execStatusFunction()
end

--[[
-- Reset harrowstorm's status info and define the status with newStatus.
--
-- @param string newStatus The harrowstorm's new status in HarrowStormstatus.list
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStorm:resetWithStatus(newStatus)
    self.status.previous = nil
    self.status.current  = newStatus
    self.status.time     = 0

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.harrowStorm.resetStatus,
        self,
        newStatus
    )
end

--[[
-- Execute the dedicated function for a status
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStorm:execStatusFunction()
    if self.status.current == LibDragonWorldEvent.HarrowStorms.HarrowStormStatus.list.started then
        self:started()
    elseif self.status.current == LibDragonWorldEvent.HarrowStorms.HarrowStormStatus.list.ended then
        self:ended()
    end
end

--[[
-- Called when the harrowstorm (re)pop
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStorm:started()
    -- self.repop.repopTime = os.time()

    -- if self.repop.endTime ~= 0 then
    --     local diffTime = self.repop.repopTime - self.repop.killTime
    --     LibDragonWorldEvent.HarrowStorms.ZoneInfo.repopTime = diffTime
    -- end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.harrowStorm.started,
        self
    )
end

--[[
-- Called when the harrowstorm is killed
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStorm:ended()
    self.repop.endTime = os.time()

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.harrowStorm.ended,
        self
    )
end
