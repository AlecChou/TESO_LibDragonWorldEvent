LibWorldEvents.HarrowStorms.HarrowStormList = {}

-- @var table List of all dragons instancied
LibWorldEvents.HarrowStorms.HarrowStormList.list = {}

-- @var number Number of item in list
LibWorldEvents.HarrowStorms.HarrowStormList.nb   = 0

LibWorldEvents.HarrowStorms.HarrowStormList.poiIdxMap = {}

LibWorldEvents.HarrowStorms.HarrowStormList.currentWEInstanceIdListIdx = 0

--[[
-- Reset the list
--]]
function LibWorldEvents.HarrowStorms.HarrowStormList:reset()
    self.list                       = {}
    self.poiIdxMap                  = {}
    self.nb                         = 0
    self.currentWEInstanceIdListIdx = 0

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStormList.reset,
        self
    )
end

--[[
-- Add a new dragon to the list
--
-- @param Dragon dragon : The dragon instance to add
--]]
function LibWorldEvents.HarrowStorms.HarrowStormList:add(harrowstorm)
    local newIdx = self.nb + 1

    self.list[newIdx] = harrowstorm
    self.nb           = newIdx

    -- if harrowstorm.WEInstanceId ~= nil then
    --     self.currentWEInstanceIdListIdx = newIdx
    -- end

    local poiIdx = harrowstorm.poi.poiIdx
    self.poiIdxMap[poiIdx] = newIdx

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStormList.add,
        self,
        harrowstorm
    )
end

--[[
-- Execute the callback for all dragon
--
-- @param function callback : A callback called for each dragon in the list.
-- The callback take the dragon instance as parameter.
--]]
function LibWorldEvents.HarrowStorms.HarrowStormList:execOnAll(callback)
    local harrowStormIdx = 1

    for harrowStormIdx = 1, self.nb do
        callback(self.list[harrowStormIdx])
    end
end

--[[
-- Obtain the dragon instance for a WEInstanceId
--
-- @return Dragon
--]]
function LibWorldEvents.HarrowStorms.HarrowStormList:obtainLastActive()
    local harrowStormIdx = self.currentWEInstanceIdListIdx

    return self.list[harrowStormIdx]
end

function LibWorldEvents.HarrowStorms.HarrowStormList:updateWEInstanceId(poiIdx)
    for listIdx, harrowStorm in ipairs(self.list) do
        if harrowStorm.poi.poiIdx == poiIdx then
            self.currentWEInstanceIdListIdx = listIdx
            return
        end
    end
end

function LibWorldEvents.HarrowStorms.HarrowStormList:obtainForPoiIdx(poiIdx)
    local harrowStormIdx = self.poiIdxMap[poiIdx]

    return self.list[harrowStormIdx]
end

--[[
-- To update the list : remove all dragon or create all dragon compared to Zone info.
--]]
function LibWorldEvents.HarrowStorms.HarrowStormList:update()
    if LibWorldEvents.Zone.changedZone == true then
        self:removeAll()
    end

    if LibWorldEvents.Zone.onWorldEventMap == true and self.nb == 0 then
        self:createAll()
    end

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStormList.update,
        self
    )
end

--[[
-- Remove all dragon instance in the list and reset GUI items list
--]]
function LibWorldEvents.HarrowStorms.HarrowStormList:removeAll()
    self:reset()

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStormList.removeAll,
        self
    )
end

--[[
-- Create a dragon instance for each dragon in the zone, and add it to the list.
--]]
function LibWorldEvents.HarrowStorms.HarrowStormList:createAll()
    self:removeAll()

    for harrowStormIdx, harrowstormInfo in ipairs(LibWorldEvents.Zone.info.list.poiIndices) do
        local harrowStorm = LibWorldEvents.HarrowStorms.HarrowStorm:new(harrowStormIdx)

        self:add(harrowStorm)
    end

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStormList.createAll,
        self
    )
end
