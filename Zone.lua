LibWorldEvents.Zone = {}

LibWorldEvents.Zone.WORLD_EVENT_TYPE = {
    DRAGON = "dragon",
    HARROWSTORM = "harrowstorm",

    --Not plugged in game yet
    -- DOLMEN = "dolmen",
    -- OBLIVON_PORTAL = "oblivon portal"
}

-- @var boolean If player is on a map with dragon
LibWorldEvents.Zone.onWorldEventMap = false

LibWorldEvents.Zone.worldEventMapType = nil

-- @var nil|number The previous ZoneId
LibWorldEvents.Zone.lastZoneId   = nil

-- @var boolean If the player has changed zone
LibWorldEvents.Zone.changedZone  = false

-- @var ref-to-table Info about the current zone (ref to list value corresponding to the zone)
LibWorldEvents.Zone.info         = nil

--[[
-- Update info about the current zone.
--]]
function LibWorldEvents.Zone:updateInfo()
    local currentZoneId = GetZoneId(GetCurrentMapZoneIndex())

    self.changedZone = false
    if self.lastZoneId ~= currentZoneId then
        self.changedZone = true
        self.lastZoneId  = currentZoneId
    end

    self:checkWorldEvent(currentZoneId)
    self:initWorldEvent()

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.zone.updateInfo,
        self
    )
end

function LibWorldEvents.Zone:resetZoneData()
    self.info              = nil
    self.onWorldEventMap   = false
    self.worldEventMapType = nil

    LibWorldEvents.Dragons.ZoneInfo.onMap      = false
    LibWorldEvents.HarrowStorms.ZoneInfo.onMap = false
end

--[[
-- Check if it's a zone with dragons.
--
-- @param number currentZoneId The current zone id
--]]
function LibWorldEvents.Zone:checkWorldEvent(currentZoneId)
    self:resetZoneData()

    local dragonsZoneList     = LibWorldEvents.Dragons.ZoneInfo:obtainList()
    local harrowstormZoneList = LibWorldEvents.HarrowStorms.ZoneInfo:obtainList()
    -- local dolmenMapList      = LibWorldEvents.Dolmens.ZoneInfo:obtainList() --Not plugged in game yet

    self:checkWorldEventForType(currentZoneId, self.WORLD_EVENT_TYPE.DRAGON, dragonsZoneList)
    self:checkWorldEventForType(currentZoneId, self.WORLD_EVENT_TYPE.HARROWSTORM, harrowstormZoneList)

    -- If we are in a dungeon/delve/battleground or in an house : no world event.
    if IsUnitInDungeon("player") or GetCurrentZoneHouseId() ~= 0 then
        self:resetZoneData()
    end

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.zone.checkWorldEvents,
        self
    )
end

function LibWorldEvents.Zone:checkWorldEventForType(currentZoneId, weType, zoneList)
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

function LibWorldEvents.Zone:initWorldEvent()
    if self.onWorldEventMap == false then
        return
    end

    if self.worldEventMapType == self.WORLD_EVENT_TYPE.DRAGON then
        LibWorldEvents.Dragons.ZoneInfo.onMap = true

        LibWorldEvents.Dragons.DragonList:update()
        LibWorldEvents.Dragons.DragonStatus:checkAllDragon()
    elseif self.worldEventMapType == self.WORLD_EVENT_TYPE.HARROWSTORM then
        LibWorldEvents.HarrowStorms.ZoneInfo.onMap = true

        LibWorldEvents.HarrowStorms.HarrowStormList:update()
        LibWorldEvents.HarrowStorms.HarrowStormStatus:checkAllHarrowStorm()
    end
end
