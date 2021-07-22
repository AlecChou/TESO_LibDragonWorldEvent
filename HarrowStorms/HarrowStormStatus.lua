LibWorldEvents.HarrowStorms.HarrowStormStatus = {}

-- @var table : List of all status which can be defined
LibWorldEvents.HarrowStorms.HarrowStormStatus.list = {
    ended   = "ended",
    started = "started",
}

--[[
-- Initialise the status for a dragon
--
-- @param Dragon dragon : The dragon with the status to initialise
--]]
function LibWorldEvents.HarrowStorms.HarrowStormStatus:initForHarrowStorm(harrowStorm)
    self:update(harrowStorm)

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStormStatus.initHarrowStorm,
        self,
        harrowStorm
    )
end

--[[
-- Check the status for all dragon instancied
--]]
function LibWorldEvents.HarrowStorms.HarrowStormStatus:checkAllHarrowStorm()
    LibWorldEvents.HarrowStorms.HarrowStormList:execOnAll(self.checkForHarrowStorm)

    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStormStatus.checkAll,
        self
    )
end

--[[
-- Check the status for a specific dragon.
-- It's a callback for DragonList:execOnAll
--
-- @param Dragon dragon The dragon to check
--]]
function LibWorldEvents.HarrowStorms.HarrowStormStatus.checkForHarrowStorm(harrowStorm)
    LibWorldEvents.HarrowStorms.HarrowStormStatus:update(harrowStorm)
    
    LibWorldEvents.Events.callbackManager:FireCallbacks(
        LibWorldEvents.Events.callbackEvents.harrowStormStatus.check,
        LibWorldEvents.HarrowStorms.HarrowStormStatus,
        harrowStorm
    )
end

function LibWorldEvents.HarrowStorms.HarrowStormStatus:update(harrowStorm)
    harrowStorm:updateWEInstanceId()
    
    if harrowStorm.WEInstanceId ~= 0 then
        harrowStorm:resetWithStatus(self.list.started)
    else
        harrowStorm:resetWithStatus(self.list.ended)
    end
end


