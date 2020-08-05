LibDragonWorldEvent.Zone = {}

-- @var boolean If player is on a zone with dragon
LibDragonWorldEvent.Zone.onDragonZone = false -- Elweyr is a zone

-- @var boolean If player is on a map with dragon
LibDragonWorldEvent.Zone.onDragonMap  = false -- A delve is a map in the zone

-- @var nil|number The previous ZoneId
LibDragonWorldEvent.Zone.lastZoneId   = nil

-- @var boolean If the player has changed zone
LibDragonWorldEvent.Zone.changedZone  = false

-- @var ref-to-table Info about the current zone (ref to list value corresponding to the zone)
LibDragonWorldEvent.Zone.info         = nil

-- @var number Number of zone in the list
LibDragonWorldEvent.Zone.nbZone       = 2

-- @var table List of info about zones with dragons.
-- Note : mapZone if formatted for LibMapPins, so used by DragonNextLocation
-- and not for the zone detection.
LibDragonWorldEvent.Zone.list         = {
    [1] = { -- North Elsweyr
        zoneId     = 1086,
        mapName    = "elsweyr/elsweyr_base",
        nbDragons  = 3,
        dragons    = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_NORTH),
                    [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH_EAST),
                    [3] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH_WEST)
                },
                ln = {
                    [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_LN_PROWLS_EDGE),
                    [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_LN_SANDBLOWN),
                    [3] = GetString(SI_LIB_DRAGON_WORLD_EVENT_LN_SCAB_RIDGE)
                }
            },
            WEInstanceId = {
                [1] = 2,
                [2] = 1,
                [3] = 3,
            },
        },
    },
    [2] = { -- South Elsweyr
        zoneId     = 1133,
        mapName    = "southernelsweyr/southernelsweyr_base",
        nbDragons  = 2,
        dragons    = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_NORTH),
                    [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH)
                },
                ln = {
                    [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_NORTH),
                    [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH)
                },
            },
            WEInstanceId = {
                [1] = 12,
                [2] = 13,
            },
        },
    }
}

LibDragonWorldEvent.Zone.repopTime = 0

--[[
-- Update info about the current zone.
--]]
function LibDragonWorldEvent.Zone:updateInfo()
    local currentZoneId = GetZoneId(GetCurrentMapZoneIndex())

    self:checkDragonZone(currentZoneId)

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

--[[
-- Check if it's a zone with dragons.
--
-- @param number currentZoneId The current zone id
--]]
function LibDragonWorldEvent.Zone:checkDragonZone(currentZoneId)
    self.onDragonZone = false
    self.onDragonMap  = false

    local listIdx = 1
    local zoneId  = 0

    for listIdx=1, self.nbZone do
        zoneId = self.list[listIdx].zoneId

        if currentZoneId == zoneId then
            self.onDragonMap  = true
            self.onDragonZone = true
            self.info         = self.list[listIdx]
        end
    end

    -- If we are in a dungeon/delve/battleground or in an house : no world event.
    if IsUnitInDungeon("player") or GetCurrentZoneHouseId() ~= 0 then
        self.onDragonMap = false
    end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.zone.checkDragonZone,
        self
    )
end
