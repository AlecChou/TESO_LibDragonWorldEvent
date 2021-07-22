LibWorldEvents.HarrowStorms.HarrowStorm = {}
LibWorldEvents.HarrowStorms.HarrowStorm.__index = LibWorldEvents.HarrowStorms.HarrowStorm

--[[
-- Instanciate a new Dragon "object"
--
-- @param number harrowStormIdx The harrowStorm index in HarrowStormList.list
-- @param number WEInstanceId The dragon's WorldEventInstanceId
--
-- @return Dragon
--]]
function LibWorldEvents.HarrowStorms.HarrowStorm:new(harrowStormIdx)
    local newHarrowStorm = {
        listIdx      = harrowStormIdx,
        WEInstanceId = nil,
        WEId         = nil,
        title        = {
            cp = LibWorldEvents.Zone.info.list.title.cp[harrowStormIdx],
            ln = LibWorldEvents.Zone.info.list.title.ln[harrowStormIdx]
        },
        poi         = {
            zoneIdx = GetZoneIndex(LibWorldEvents.Zone.info.zoneId),
            poiIdx  = LibWorldEvents.Zone.info.list.poiIndices[harrowStormIdx]
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
    LibWorldEvents.HarrowStorms.HarrowStormStatus:initForHarrowStorm(newHarrowStorm)

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStorm.new,
        newHarrowStorm
    )

    return newHarrowStorm
end

--[[
-- Update the WorldEventId
--]]
function LibWorldEvents.HarrowStorms.HarrowStorm:updateWEId()
    self.WEId = GetWorldEventId(self.WEInstanceId)
end

--[[
-- Update the WorldEventId
--]]
function LibWorldEvents.HarrowStorms.HarrowStorm:updateWEInstanceId()
    self.WEInstanceId = GetPOIWorldEventInstanceId(self.poi.zoneIdx, self.poi.poiIdx)

    if self.WEInstanceId ~= 0 and LibWorldEvents.HarrowStorms.HarrowStormList.currentWEInstanceIdListIdx == 0 then
        LibWorldEvents.HarrowStorms.HarrowStormList.currentWEInstanceIdListIdx = self.listIdx
    end
end

--[[
-- Change the harrowstorm's current status
--
-- @param string newStatus The harrowstorm's new status in HarrowStormstatus.list
-- @param string unitTag (default nil) The new unitTag
-- @param number unitPin (default nil) The new unitPin
--]]
function LibWorldEvents.HarrowStorms.HarrowStorm:changeStatus(newStatus, unitTag, unitPin)
    self.status.previous = self.status.current
    self.status.current  = newStatus
    self.status.time     = os.time()

    if self.status.previous == nil or self.status.previous == self.status.current then
        self.status.time = 0
    end
    
    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStorm.changeStatus,
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
function LibWorldEvents.HarrowStorms.HarrowStorm:resetWithStatus(newStatus)
    self.status.previous = nil
    self.status.current  = newStatus
    self.status.time     = 0

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStorm.resetStatus,
        self,
        newStatus
    )
end

--[[
-- Execute the dedicated function for a status
--]]
function LibWorldEvents.HarrowStorms.HarrowStorm:execStatusFunction()
    if self.status.current == LibWorldEvents.HarrowStorms.HarrowStormStatus.list.started then
        self:started()
    elseif self.status.current == LibWorldEvents.HarrowStorms.HarrowStormStatus.list.ended then
        self:ended()
    end
end

--[[
-- Called when the harrowstorm (re)pop
--]]
function LibWorldEvents.HarrowStorms.HarrowStorm:started()
    -- self.repop.repopTime = os.time()

    -- if self.repop.endTime ~= 0 then
    --     local diffTime = self.repop.repopTime - self.repop.killTime
    --     LibWorldEvents.HarrowStorms.ZoneInfo.repopTime = diffTime
    -- end

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStorm.started,
        self
    )
end

--[[
-- Called when the harrowstorm is killed
--]]
function LibWorldEvents.HarrowStorms.HarrowStorm:ended()
    self.repop.endTime = os.time()

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStorm.ended,
        self
    )
end
