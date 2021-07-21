LibDragonWorldEvent.Zone = {}

LibDragonWorldEvent.Zone.WORLD_EVENT_TYPE = {
    DRAGON = "dragon",
    HARROWSTORM = "harrowstorm",

    --Not plugged in game yet
    -- DOLMEN = "dolmen",
    -- OBLIVON_PORTAL = "oblivon portal"
}

-- @var boolean If player is on a map with dragon
LibDragonWorldEvent.Zone.onWorldEventMap = false

LibDragonWorldEvent.Zone.worldEventMapType = nil

-- @var nil|number The previous ZoneId
LibDragonWorldEvent.Zone.lastZoneId   = nil

-- @var boolean If the player has changed zone
LibDragonWorldEvent.Zone.changedZone  = false

-- @var ref-to-table Info about the current zone (ref to list value corresponding to the zone)
LibDragonWorldEvent.Zone.info         = nil

--[[
-- Update info about the current zone.
--]]
function LibDragonWorldEvent.Zone:updateInfo()
    local currentZoneId = GetZoneId(GetCurrentMapZoneIndex())

    self:checkWorldEvent(currentZoneId)

    self.changedZone = false
    if self.lastZoneId ~= currentZoneId then
        self.changedZone = true
        self.lastZoneId  = currentZoneId
    end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.zone.updateInfo,
        self
    )
end

function LibDragonWorldEvent.Zone:resetZoneData()
    self.info              = nil
    self.onWorldEventMap   = false
    self.worldEventMapType = nil
end

--[[
-- Check if it's a zone with dragons.
--
-- @param number currentZoneId The current zone id
--]]
function LibDragonWorldEvent.Zone:checkWorldEvent(currentZoneId)
    self:resetZoneData()

    local dragonsZoneList     = LibDragonWorldEvent.Dragons.ZoneInfo:obtainList()
    local harrowstormZoneList = LibDragonWorldEvent.HarrowStorms.ZoneInfo:obtainList()
    -- local dolmenMapList      = LibDragonWorldEvent.Dolmens.ZoneInfo:obtainList() --Not plugged in game yet

    self:checkWorldEventForType(currentZoneId, self.WORLD_EVENT_TYPE.DRAGON, dragonsZoneList)
    self:checkWorldEventForType(currentZoneId, self.WORLD_EVENT_TYPE.HARROWSTORM, harrowstormZoneList)

    -- If we are in a dungeon/delve/battleground or in an house : no world event.
    if IsUnitInDungeon("player") or GetCurrentZoneHouseId() ~= 0 then
        self:resetZoneData()
    end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.zone.checkWorldEvents,
        self
    )
end

function LibDragonWorldEvent.Zone:checkWorldEventForType(currentZoneId, weType, zoneList)
    if self.onWorldEventMap == true then
        return
    end

    for zoneListIdx, zoneInfo in ipairs(zoneList) do
        if currentZoneId == zoneInfo.zoneId then
            self.info              = zoneList[zoneListIdx]
            self.onWorldEventMap   = true
            self.worldEventMapType = weType
            return
        end
    end
end

function LibDragonWorldEvent.Zone:initWorldEvent()
    if self.onWorldEventMap == false then
        return
    end

    LibDragonWorldEvent.Dragons.ZoneInfo.onMap      = false
    LibDragonWorldEvent.HarrowStorms.ZoneInfo.onMap = false

    if self.worldEventMapType == self.WORLD_EVENT_TYPE.DRAGON then
        LibDragonWorldEvent.Dragons.ZoneInfo.onMap = true

        LibDragonWorldEvent.Dragons.DragonList:update()
        LibDragonWorldEvent.Dragons.DragonStatus:checkAllDragon()
    elseif self.worldEventMapType == self.WORLD_EVENT_TYPE.HARROWSTORM then
        LibDragonWorldEvent.HarrowStorms.ZoneInfo.onMap = true

        LibDragonWorldEvent.HarrowStorms.HarrowStormList:update()
        LibDragonWorldEvent.HarrowStorms.HarrowStormStatus:checkAllHarrowStorm()
    end
end
