LibDragonWorldEvent.Dragons.ZoneInfo = {}

LibDragonWorldEvent.Dragons.ZoneInfo.onMap = false

LibDragonWorldEvent.Dragons.ZoneInfo.repopTime = 0

LibDragonWorldEvent.Dragons.ZoneInfo.list = {
    { -- North Elsweyr
        zoneId = 1086,
        list   = {
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
    { -- South Elsweyr
        zoneId = 1133,
        list   = {
            title = {
                cp = {
                    [1] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_NORTH),
                    [2] = GetString(SI_LIB_DRAGON_WORLD_EVENT_CP_SOUTH)
                },
                ln = {
                    --Not an copy/paste error, the in game name are really north/south
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

function LibDragonWorldEvent.Dragons.ZoneInfo:obtainList()
    return self.list
end
