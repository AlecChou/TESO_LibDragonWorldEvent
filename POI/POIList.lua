LibWorldEvents.POI.POIList = {}

-- @var table List of all dragons instancied
LibWorldEvents.POI.POIList.list = {}

-- @var number Number of item in list
LibWorldEvents.POI.POIList.nb   = 0

LibWorldEvents.POI.POIList.poiIdxMap = {}

LibWorldEvents.POI.POIList.currentWEInstanceIdListIdx = 0

--[[
-- Reset the list
--]]
function LibWorldEvents.POI.POIList:reset()
    self.list                       = {}
    self.poiIdxMap                  = {}
    self.nb                         = 0
    self.currentWEInstanceIdListIdx = 0

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.poiList.reset,
        self
    )
end

--[[
-- Add a new poi to the list
--
-- @param POI poi : The poi instance to add
--]]
function LibWorldEvents.POI.POIList:add(poi)
    local newIdx = self.nb + 1

    self.list[newIdx] = poi
    self.nb           = newIdx

    local poiIdx = poi.poi.poiIdx
    self.poiIdxMap[poiIdx] = newIdx

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.poiList.add,
        self,
        poi
    )
end

--[[
-- Execute the callback for all poi instance (so poi in the zone)
--
-- @param function callback : A callback called for each poi in the list.
-- The callback take the poi instance as parameter.
--]]
function LibWorldEvents.POI.POIList:execOnAll(callback)
    local poiIdx = 1

    for poiIdx = 1, self.nb do
        callback(self.list[poiIdx])
    end
end

--[[
-- Obtain the poi instance for a WEInstanceId
--
-- @return POI
--]]
function LibWorldEvents.POI.POIList:obtainLastActive()
    local poiIdx = self.currentWEInstanceIdListIdx

    return self.list[poiIdx]
end

function LibWorldEvents.POI.POIList:updateWEInstanceId(poiIdx)
    for listIdx, poi in ipairs(self.list) do
        if poi.poi.poiIdx == poiIdx then
            self.currentWEInstanceIdListIdx = listIdx
            return
        end
    end
end

function LibWorldEvents.POI.POIList:obtainForPoiIdx(poiIdx)
    local poi = self.poiIdxMap[poiIdx]

    return self.list[poi]
end

--[[
-- To update the list : remove all poi or create all poi for the current zone.
--]]
function LibWorldEvents.POI.POIList:update()
    if LibWorldEvents.Zone.changedZone == true then
        self:removeAll()
    end

    if LibWorldEvents.Zone.onWorldEventMap == true and self.nb == 0 then
        self:createAll()
    end

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.poiList.update,
        self
    )
end

--[[
-- Remove all dragon instance in the list and reset GUI items list
--]]
function LibWorldEvents.POI.POIList:removeAll()
    self:reset()

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.poiList.removeAll,
        self
    )
end

--[[
-- Create a poi instance for each poi's worlds events in the zone, and add it to the list.
--]]
function LibWorldEvents.POI.POIList:createAll()
    self:removeAll()

    for poiIdx, poiID in ipairs(LibWorldEvents.Zone.info.list.poiIDs) do
        local poi = LibWorldEvents.POI.POI:new(poiIdx)

        self:add(poi)
    end

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.poiList.createAll,
        self
    )
end
