LibWorldEvents.POI.Geyser = {}

LibWorldEvents.POI.Geyser.onMap = false

LibWorldEvents.POI.Geyser.isGenerated = false

LibWorldEvents.POI.Geyser.list = {
    { -- Le couchant / Summerset
        zoneId  = 1011,
        mapName = "summerset/summerset_base",
        list    = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_WORLD_EVENTS_CP_NORTH_EAST),
                    [2] = GetString(SI_LIB_WORLD_EVENTS_CP_SOUTH_EAST),
                    [3] = GetString(SI_LIB_WORLD_EVENTS_CP_SOUTH_CENTER),
                    [4] = GetString(SI_LIB_WORLD_EVENTS_CP_SOUTH_WEST),
                    [5] = GetString(SI_LIB_WORLD_EVENTS_CP_CENTER_WEST),
                    [6] = GetString(SI_LIB_WORLD_EVENTS_CP_NORTH_WEST)
                },
                ln = {} --generated in generateList()
            },
            poiIDs = {
                [1] = 2016, --Direnni Abyssal Geyser
                [2] = 2038, --Sil-Var-Woad Abyssal Geyser
                [3] = 2071, --Sunhold Abyssal Geyser
                [4] = 2059, --Welenkin Abyssal Geyser
                [5] = 2049, --Rellenthil Abyssal Geyser
                [6] = 2058, --Corgrad Abyssal Geyser
            },
        },
    }
}

function LibWorldEvents.POI.Geyser:generateList()
    for listIdx, zoneData in ipairs(self.list) do
        local zoneIdx = GetZoneIndex(zoneData.zoneId)

        for poiListIdx, poiIdx in ipairs(zoneData.list.poiIDs) do
            local poiTitle = GetPOIInfo(zoneIdx, poiIdx)
            zoneData.list.title.ln[poiListIdx] = zo_strformat(poiTitle)
        end
    end

    self.isGenerated = true
end

function LibWorldEvents.POI.Geyser:obtainList()
    if self.isGenerated == false then
        self:generateList()
    end

    return self.list
end
