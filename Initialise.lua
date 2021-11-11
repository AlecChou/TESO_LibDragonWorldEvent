LibWorldEvents = {}

LibWorldEvents.name  = "LibWorldEvents"
LibWorldEvents.ready = false

-- Define sub-directory namespaces
LibWorldEvents.Dragons = {}
LibWorldEvents.POI     = {}

--[[
-- Module initialiser
--]]
function LibWorldEvents:Initialise()
    LibWorldEvents.ready = true
end
