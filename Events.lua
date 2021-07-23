LibWorldEvents.Events = {}

LibWorldEvents.Events.callbackManager = ZO_CallbackObject:New()
LibWorldEvents.Events.callbackEvents  = {
    dragon       = {
        new          = "LibDragonWE_Event_Dragon_New",
        changeStatus = "LibDragonWE_Event_Dragon_ChangeStatus",
        changeType   = "LibDragonWE_Event_Dragon_ChangeType",
        resetStatus  = "LibDragonWE_Event_Dragon_ResetStatus",
        poped        = "LibDragonWE_Event_Dragon_Poped",
        killed       = "LibDragonWE_Event_Dragon_Killed",
        waiting      = "LibDragonWE_Event_Dragon_Waiting",
        fight        = "LibDragonWE_Event_Dragon_Fight",
        weak         = "LibDragonWE_Event_Dragon_Weak",
        flying       = "LibDragonWE_Event_Dragon_flying",
        landed       = "LibDragonWE_Event_Dragon_landed",
    },
    dragonList   = {
        reset     = "LibDragonWE_Event_DragonList_Reset",
        add       = "LibDragonWE_Event_DragonList_Add",
        update    = "LibDragonWE_Event_DragonList_Update",
        removeAll = "LibDragonWE_Event_DragonList_RemoveAll",
        createAll = "LibDragonWE_Event_DragonList_CreateAll",
    },
    dragonStatus = {
        initDragon = "LibDragonWE_Event_DragonStatus_InitDragon",
        checkAll   = "LibDragonWE_Event_DragonStatus_CheckAll",
        check      = "LibDragonWE_Event_DragonStatus_Check",
    },
    harrowStorm       = {
        new          = "LibDragonWE_Event_HarrowStorm_New",
        changeStatus = "LibDragonWE_Event_HarrowStorm_ChangeStatus",
        resetStatus  = "LibDragonWE_Event_HarrowStorm_ResetStatus",
        started      = "LibDragonWE_Event_HarrowStorm_Started",
        ended        = "LibDragonWE_Event_HarrowStorm_Ended",
    },
    harrowStormList   = {
        reset     = "LibDragonWE_Event_HarrowStormList_Reset",
        add       = "LibDragonWE_Event_HarrowStormList_Add",
        update    = "LibDragonWE_Event_HarrowStormList_Update",
        removeAll = "LibDragonWE_Event_HarrowStormList_RemoveAll",
        createAll = "LibDragonWE_Event_HarrowStormList_CreateAll",
    },
    harrowStormStatus = {
        initHarrowStorm = "LibDragonWE_Event_HarrowStormStatus_InitHarrowStorm",
        checkAll        = "LibDragonWE_Event_HarrowStormStatus_CheckAll",
        check           = "LibDragonWE_Event_HarrowStormStatus_Check",
    },
    zone         = {
        updateInfo       = "LibDragonWE_Event_Zone_UpdateInfo",
        checkWorldEvents = "LibDragonWE_Event_Zone_CheckWorldEvents",
    }
}

--[[
-- Called when the addon is loaded
--
-- @param number eventCode
-- @param string addonName name of the loaded addon
--]]
function LibWorldEvents.Events.onLoaded(eventCode, addOnName)
    -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
    if addOnName == LibWorldEvents.name then
        LibWorldEvents:Initialise()
    end
end

--[[
-- Called when the user's interface loads and their character is activated after logging in or performing a reload of the UI.
-- This happens after <EVENT_ADD_ON_LOADED>, so the UI and all addons should be initialised already.
--
-- @param integer eventCode
-- @param boolean initial : true if the user just logged on, false with a UI reload (for example)
--]]
function LibWorldEvents.Events.onLoadScreen(eventCode, initial)
    if LibWorldEvents.ready == false then
        return
    end

    LibWorldEvents.Zone:updateInfo()
end

--[[
-- Called when a World Event start (aka dragon pop).
--
-- @param number eventCode
-- @param number worldEventInstanceId The concerned world event (aka dragon).
--]]
function LibWorldEvents.Events.onWEActivate(eventCode, worldEventInstanceId)
    if LibWorldEvents.ready == false then
        return
    end

    if LibWorldEvents.Dragons.ZoneInfo.onMap == true then
        local dragon = LibWorldEvents.Dragons.DragonList:obtainForWEInstanceId(worldEventInstanceId)

        if dragon == nil then -- dragon not already created
            return
        end

        dragon:poped()
    elseif LibWorldEvents.HarrowStorms.ZoneInfo.onMap == true then
        local _, poiIdx = GetWorldEventPOIInfo(worldEventInstanceId)
        LibWorldEvents.HarrowStorms.HarrowStormList:updateWEInstanceId(poiIdx)
        local harrowStorm = LibWorldEvents.HarrowStorms.HarrowStormList:obtainForPoiIdx(poiIdx)

        if harrowStorm == nil then
            return
        end

        harrowStorm:changeStatus(LibWorldEvents.HarrowStorms.HarrowStormStatus.list.started)
    end
end

--[[
-- Called when a World Event is finished (aka dragon killed).
--
-- @param number eventCode
-- @param number worldEventInstanceId The concerned world event (aka dragon).
--]]
function LibWorldEvents.Events.onWEDeactivate(eventCode, worldEventInstanceId)
    if LibWorldEvents.ready == false then
        return
    end

    if LibWorldEvents.Dragons.ZoneInfo.onMap == true then
        local dragon = LibWorldEvents.Dragons.DragonList:obtainForWEInstanceId(worldEventInstanceId)

        if dragon == nil then -- dragon not already created
            return
        end

        dragon:changeStatus(LibWorldEvents.Dragons.DragonStatus.list.killed)
    elseif LibWorldEvents.HarrowStorms.ZoneInfo.onMap == true then
        local harrowStorm = LibWorldEvents.HarrowStorms.HarrowStormList:obtainLastActive()

        if harrowStorm == nil then
            return
        end

        harrowStorm:changeStatus(LibWorldEvents.HarrowStorms.HarrowStormStatus.list.ended)
        harrowStorm:ended()
    end
end

--[[
-- Called when a World Event has this map pin changed (aka new dragon or dragon in fight).
--
-- @param number eventCode
-- @param number worldEventInstanceId The concerned world event (aka dragon).
-- @param string unitTag The dragon's unitTag
-- @param number oldPinType the old pinType
-- @param number newPinType the new pinType
--]]
function LibWorldEvents.Events.onWEUnitPin(eventCode, worldEventInstanceId, unitTag, oldPinType, newPinType)
    if LibWorldEvents.ready == false then
        return
    end

    if LibWorldEvents.Dragons.ZoneInfo.onMap == false then
        return
    end

    local dragon = LibWorldEvents.Dragons.DragonList:obtainForWEInstanceId(worldEventInstanceId)
    local status = LibWorldEvents.Dragons.DragonStatus:convertMapPin(newPinType)

    if dragon == nil then -- dragon not already created
        return
    end

    if status == LibWorldEvents.Dragons.DragonStatus.list.waiting and dragon.justPoped == true then
        status = LibWorldEvents.Dragons.DragonStatus.list.flying
    end

    dragon:changeStatus(status, unitTag, newPinType)
end

--[[
-- Called when a World Event change location
--
-- @param number eventCode
-- @param number worldEventInstanceId The concerned world event (aka dragon).
-- @param number oldWorldEventLocationId The old dragon's locationId
-- @param number newWorldEventLocationId The new dragon's locationId
--]]
function LibWorldEvents.Events.onWELocChanged(eventCode, worldEventInstanceId, oldWorldEventLocationId, newWorldEventLocationId)
    if LibWorldEvents.ready == false then
        return
    end

    if LibWorldEvents.Dragons.ZoneInfo.onMap == false then
        return
    end

    local dragon       = LibWorldEvents.Dragons.DragonList:obtainForWEInstanceId(worldEventInstanceId)
    local flyingStatus = LibWorldEvents.Dragons.DragonStatus.list.flying

    if dragon == nil then -- dragon not already created
        return
    end

    -- Check because on a pop dragon, we have events onWEActivate, onWEUnitPin and onWELocChanged
    if dragon.status.current ~= flyingStatus then
        dragon:changeStatus(flyingStatus)
    end
end

--[[
-- Called when something change in GUI (like open inventory).
-- Used to some debug, the add to event is commented.
--]]
function LibWorldEvents.Events.onGuiChanged(eventCode)
    if LibWorldEvents.ready == false then
        return
    end
end
