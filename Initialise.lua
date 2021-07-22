LibWorldEvents = {}

LibWorldEvents.name  = "LibWorldEvents"
LibWorldEvents.ready = false

-- Define sub-directory namespaces
LibWorldEvents.Dragons      = {}
LibWorldEvents.HarrowStorms = {}

--[[
-- Module initialiser
--]]
function LibWorldEvents:Initialise()
    LibWorldEvents.ready = true
end
