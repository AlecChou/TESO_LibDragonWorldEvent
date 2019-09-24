LibDragonWorldEvent.Zone = {}

-- @var boolean If player is on a zone with dragon
LibDragonWorldEvent.Zone.onDragonZone   = false -- Elweyr is a zone

-- @var boolean If player is on a map with dragon
LibDragonWorldEvent.Zone.onDragonMap    = false -- A delve is a map in the zone

-- @var nil|number The previous MapZoneIndex
LibDragonWorldEvent.Zone.lastMapZoneIdx = nil

-- @var boolean If the player has changed zone
LibDragonWorldEvent.Zone.changedZone    = false

-- @var ref-to-table Info about the current zone (ref to list value corresponding to the zone)
LibDragonWorldEvent.Zone.info           = nil

-- @var number Number of zone in the list
LibDragonWorldEvent.Zone.nbZone         = 2

-- @var table List of info about zones with dragons.
LibDragonWorldEvent.Zone.list           = {
    [1] = { -- North Elsweyr
        mapZoneIdx = 680,
        nbDragons  = 3,
        dragons    = {
            title = {
                [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_NORTH),
                [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH),
                [3] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_WEST)
            },
            WEInstanceId = {
                [1] = 2,
                [2] = 1,
                [3] = 3,
            },
        },
    },
    [2] = { -- South Elsweyr
        mapZoneIdx = 719,
        nbDragons  = 2,
        dragons    = {
            title = {
                [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_NORTH),
                [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH)
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
    local currentMapZoneIdx = GetCurrentMapZoneIndex()

    self:checkDragonZone(currentMapZoneIdx)

    self.changedZone = false
    if self.lastMapZoneIdx ~= currentMapZoneIdx then
        self.changedZone    = true
        self.lastMapZoneIdx = currentMapZoneIdx
    end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.zone.updateInfo,
        self
    )
end

--[[
-- Check if it's a zone with dragons.
--
-- @param number currentMapZoneIdx The current MapZoneIndex
--]]
function LibDragonWorldEvent.Zone:checkDragonZone(currentMapZoneIdx)
    self.onDragonZone = false
    self.onDragonMap  = false

    local listIdx    = 1
    local mapZoneIdx = 0

    for listIdx=1, self.nbZone do
        mapZoneIdx = self.list[listIdx].mapZoneIdx

        if currentMapZoneIdx == mapZoneIdx then
            self.onDragonMap  = true
            self.onDragonZone = true
            self.info         = self.list[listIdx]
        end
    end

    -- If we are in a dungeon/delve or battleground : no world event.
    if GetMapContentType() ~= MAP_CONTENT_NONE then
        self.onDragonMap = false
    end

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.zone.checkDragonZone,
        self
    )
end
