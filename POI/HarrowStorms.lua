LibWorldEvents.POI.HarrowStorms = {}

LibWorldEvents.POI.HarrowStorms.onMap = false

LibWorldEvents.POI.HarrowStorms.isGenerated = false

LibWorldEvents.POI.HarrowStorms.list = {
    { -- Western Skyrim
        zoneId  = 1160,
        mapName = "skyrim/westernskryim_base",
        list    = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_WORLD_EVENTS_CP_NORTH),
                    [2] = GetString(SI_LIB_WORLD_EVENTS_CP_EAST),
                    [3] = GetString(SI_LIB_WORLD_EVENTS_CP_CENTER),
                    [4] = GetString(SI_LIB_WORLD_EVENTS_CP_SOUTH),
                    [5] = GetString(SI_LIB_WORLD_EVENTS_CP_SOUTH_WEST),
                    [6] = GetString(SI_LIB_WORLD_EVENTS_CP_WEST)
                },
                ln = {} --generated in generateList()
            },
            poiIDs = {
                [1] = 2258,
                [2] = 2257,
                [3] = 2253,
                [4] = 2252,
                [5] = 2255,
                [6] = 2254,
            },
        },
    },
    { -- Blackreach: Greymoor caverns
        zoneId  = 1161,
        mapName = "skyrim/blackreach_base",
        list    = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_WORLD_EVENTS_CP_WEST),
                    [2] = GetString(SI_LIB_WORLD_EVENTS_CP_EAST),
                    [3] = GetString(SI_LIB_WORLD_EVENTS_CP_CENTER),
                    [4] = GetString(SI_LIB_WORLD_EVENTS_CP_SOUTH)
                },
                ln = {} --generated in generateList()
            },
            poiIDs = {
                [1] = 2269,
                [2] = 2266,
                [3] = 2268,
                [4] = 2267,
            },
        },
    },
    { -- The Reach
        zoneId  = 1207,
        mapName = "reach/reach_base",
        list    = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_WORLD_EVENTS_CP_NORTH),
                    [2] = GetString(SI_LIB_WORLD_EVENTS_CP_EAST),
                    [3] = GetString(SI_LIB_WORLD_EVENTS_CP_SOUTH),
                    [4] = GetString(SI_LIB_WORLD_EVENTS_CP_WEST)
                },
                ln = { --generated in generateList()
                    [1] = "",
                    [2] = "",
                    [3] = "",
                    [4] = "",
                }
            },
            poiIDs = {
                [1] = 2298,
                [2] = 2302,
                [3] = 2303,
                [4] = 2297,
            },
        },
    }
}

function LibWorldEvents.POI.HarrowStorms:generateList()
    for listIdx, zoneData in ipairs(self.list) do
        local zoneIdx = GetZoneIndex(zoneData.zoneId)

        for poiListIdx, poiIdx in ipairs(zoneData.list.poiIDs) do
            local poiTitle = GetPOIInfo(zoneIdx, poiIdx)
            zoneData.list.title.ln[poiListIdx] = zo_strformat(poiTitle)
        end
    end

    self.isGenerated = true
end

function LibWorldEvents.POI.HarrowStorms:obtainList()
    if self.isGenerated == false then
        self:generateList()
    end

    return self.list
end
