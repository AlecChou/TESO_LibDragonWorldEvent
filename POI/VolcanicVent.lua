LibWorldEvents.POI.VolcanicVent = {}

-- @var bool onMap To know if the user is on the map where the volcanicVents can happen
LibWorldEvents.POI.VolcanicVent.onMap = false

-- @var bool isGenerated To know if the list has been generated or not
LibWorldEvents.POI.VolcanicVent.isGenerated = false

-- @var table List of all zone with volcanicVents world events
LibWorldEvents.POI.VolcanicVent.list = {
    { -- High Isle
        zoneId  = 1318,
        mapName = "systres/u34_systreszone_base",
        list    = {
            title = {
                cp = {},
                ln = {} --generated in generateList()
            },
            poiIDs = {
                [1] = 2492, -- Sapphire Point
                [2] = 2493, -- Navire
                [3] = 2494, -- Feywatch Isle
                [4] = 2495, -- Garick's Rise
                [5] = 2496, -- Serpents Hollow
                [6] = 2497, -- Haunted Coast
                [7] = 2498, -- Flooded Coast
            }
        }
    }
}

--[[
-- Obtain and add the location name of all POI to the list
-- To always have an updated value for the current language, I prefer not to save it myself
--]]
function LibWorldEvents.POI.VolcanicVent:generateList()
    for listIdx, zoneData in ipairs(self.list) do
        for poiListIdx, poiId in ipairs(zoneData.list.poiIDs) do
            local zoneIdx, poiIdx = GetPOIIndices(poiId)
            local poiTitle        = GetPOIInfo(zoneIdx, poiIdx)
            zoneData.list.title.ln[poiListIdx] = zo_strformat(poiTitle)
            -- force cardinal point to be the POI title (removing "volcanic vent"), even if user has changed preferred label type
            zoneData.list.title.cp[poiListIdx] = zo_strformat(poiTitle):gsub(" Volcanic Vent","")
        end
    end

    self.isGenerated = true
end

--[[
-- To obtain the zone's list where a volcanicVents world event can happen
--]]
function LibWorldEvents.POI.VolcanicVent:obtainList()
    if self.isGenerated == false then
        self:generateList()
    end

    return self.list
end