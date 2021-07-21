LibDragonWorldEvent = {}

LibDragonWorldEvent.name  = "LibDragonWorldEvent"
LibDragonWorldEvent.ready = false

-- Define sub-directory namespaces
LibDragonWorldEvent.Dragons      = {}
LibDragonWorldEvent.HarrowStorms = {}

--[[
-- Module initialiser
--]]
function LibDragonWorldEvent:Initialise()
    LibDragonWorldEvent.ready = true
end
