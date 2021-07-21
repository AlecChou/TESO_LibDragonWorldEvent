LibDragonWorldEvent.HarrowStorms.HarrowStormStatus = {}

-- @var table : List of all status which can be defined
LibDragonWorldEvent.HarrowStorms.HarrowStormStatus.list = {
    ended   = "ended",
    started = "started",
}

--[[
-- Initialise the status for a dragon
--
-- @param Dragon dragon : The dragon with the status to initialise
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStormStatus:initForHarrowStorm(harrowStorm)
    self:update(harrowStorm)

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.harrowStormStatus.initHarrowStorm,
        self,
        harrowStorm
    )
end

--[[
-- Check the status for all dragon instancied
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStormStatus:checkAllHarrowStorm()
    LibDragonWorldEvent.HarrowStorms.HarrowStormList:execOnAll(self.checkForHarrowStorm)

    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.harrowStormStatus.checkAll,
        self
    )
end

--[[
-- Check the status for a specific dragon.
-- It's a callback for DragonList:execOnAll
--
-- @param Dragon dragon The dragon to check
--]]
function LibDragonWorldEvent.HarrowStorms.HarrowStormStatus.checkForHarrowStorm(harrowStorm)
    LibDragonWorldEvent.HarrowStorms.HarrowStormStatus:update(harrowStorm)
    
    LibDragonWorldEvent.Events.callbackManager:FireCallbacks(
        LibDragonWorldEvent.Events.callbackEvents.harrowStormStatus.check,
        LibDragonWorldEvent.HarrowStorms.HarrowStormStatus,
        harrowStorm
    )
end

function LibDragonWorldEvent.HarrowStorms.HarrowStormStatus:update(harrowStorm)
    harrowStorm:updateWEInstanceId()
    
    if harrowStorm.WEInstanceId ~= 0 then
        harrowStorm:resetWithStatus(self.list.started)
    else
        harrowStorm:resetWithStatus(self.list.ended)
    end
end


