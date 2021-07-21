LibDragonWorldEvent.HarrowStorms.ZoneInfo = {}

LibDragonWorldEvent.HarrowStorms.ZoneInfo.onMap = false

LibDragonWorldEvent.HarrowStorms.ZoneInfo.poiIcon = "/esoui/art/icons/poi/poi_portal_complete.dds"

LibDragonWorldEvent.HarrowStorms.ZoneInfo.isGenerated = false

LibDragonWorldEvent.HarrowStorms.ZoneInfo.list = {
    { -- Western Skyrim
        zoneId = 1160,
        list   = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_NORTH),
                    [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_EAST),
                    [3] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_CENTER),
                    [4] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH),
                    [5] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH_WEST),
                    [6] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_WEST)
                },
                ln = {} --generated in generateList()
            },
            poiIndices = { --can't obtain poiID T-T
                [1] = 34,
                [2] = 33,
                [3] = 30,
                [4] = 29,
                [5] = 32,
                [6] = 31,
            },
        },
    },
    { -- Blackreach: Greymoor caverns
        zoneId = 1161,
        list   = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_WEST),
                    [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_EAST),
                    [3] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_CENTER),
                    [4] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH)
                },
                ln = {} --generated in generateList()
            },
            poiIndices = { --can't obtain poiID T-T
                [1] = 21,
                [2] = 18,
                [3] = 20,
                [4] = 19,
            },
        },
    },
    { -- The Reach
        zoneId = 1207,
        list   = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_NORTH),
                    [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_EAST),
                    [3] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH),
                    [4] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_WEST)
                },
                ln = { --generated in generateList()
                    [1] = "",
                    [2] = "",
                    [3] = "",
                    [4] = "",
                }
            },
            poiIndices = { --can't obtain poiID T-T
                [1] = 9,
                [2] = 13,
                [3] = 14,
                [4] = 8,
            },
        },
    }
}

function LibDragonWorldEvent.HarrowStorms.ZoneInfo:generateList()
    for listIdx, zoneData in ipairs(self.list) do
        local zoneIdx = GetZoneIndex(zoneData.zoneId)

        for poiListIdx, poiIdx in ipairs(zoneData.list.poiIndices) do
            local poiTitle = GetPOIInfo(zoneIdx, poiIdx)
            zoneData.list.title.ln[poiListIdx] = zo_strformat(poiTitle)
        end
    end

    self.isGenerated = true
end

function LibDragonWorldEvent.HarrowStorms.ZoneInfo:obtainList()
    if self.isGenerated == false then
        self:generateList()
    end

    return self.list
end
