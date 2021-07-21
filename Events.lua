LibDragonWorldEvent.Events = {}

LibDragonWorldEvent.Events.callbackManager = ZO_CallbackObject:New()
LibDragonWorldEvent.Events.callbackEvents  = {
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
function LibDragonWorldEvent.Events.onLoaded(eventCode, addOnName)
    -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
    if addOnName == LibDragonWorldEvent.name then
        LibDragonWorldEvent:Initialise()
    end
end

--[[
-- Called when the user's interface loads and their character is activated after logging in or performing a reload of the UI.
-- This happens after <EVENT_ADD_ON_LOADED>, so the UI and all addons should be initialised already.
--
-- @param integer eventCode
-- @param boolean initial : true if the user just logged on, false with a UI reload (for example)
--]]
function LibDragonWorldEvent.Events.onLoadScreen(eventCode, initial)
    if LibDragonWorldEvent.ready == false then
        return
    end

    LibDragonWorldEvent.Zone:updateInfo()
    LibDragonWorldEvent.Zone:initWorldEvent()
end

--[[
-- Called when a World Event start (aka dragon pop).
--
-- @param number eventCode
-- @param number worldEventInstanceId The concerned world event (aka dragon).
--]]
function LibDragonWorldEvent.Events.onWEActivate(eventCode, worldEventInstanceId)
    if LibDragonWorldEvent.ready == false then
        return
    end

    if LibDragonWorldEvent.Dragons.ZoneInfo.onMap == true then
        local dragon = LibDragonWorldEvent.Dragons.DragonList:obtainForWEInstanceId(worldEventInstanceId)

        if dragon == nil then -- dragon not already created
            return
        end

        dragon:poped()
    elseif LibDragonWorldEvent.HarrowStorms.ZoneInfo.onMap == true then
        local _, poiIdx = GetWorldEventPOIInfo(worldEventInstanceId)
        LibDragonWorldEvent.HarrowStorms.HarrowStormList:updateWEInstanceId(poiIdx)
        local harrowStorm = LibDragonWorldEvent.HarrowStorms.HarrowStormList:obtainForPoiIdx(poiIdx)

        if harrowStorm == nil then
            return
        end

        harrowStorm:changeStatus(LibDragonWorldEvent.HarrowStorms.HarrowStormStatus.list.started)
    end
end

--[[
-- Called when a World Event is finished (aka dragon killed).
--
-- @param number eventCode
-- @param number worldEventInstanceId The concerned world event (aka dragon).
--]]
function LibDragonWorldEvent.Events.onWEDeactivate(eventCode, worldEventInstanceId)
    if LibDragonWorldEvent.ready == false then
        return
    end

    if LibDragonWorldEvent.Dragons.ZoneInfo.onMap == true then
        local dragon = LibDragonWorldEvent.Dragons.DragonList:obtainForWEInstanceId(worldEventInstanceId)

        if dragon == nil then -- dragon not already created
            return
        end

        dragon:changeStatus(LibDragonWorldEvent.Dragons.DragonStatus.list.killed)
    elseif LibDragonWorldEvent.HarrowStorms.ZoneInfo.onMap == true then
        local harrowStorm = LibDragonWorldEvent.HarrowStorms.HarrowStormList:obtainLastActive()

        if harrowStorm == nil then
            return
        end

        harrowStorm:changeStatus(LibDragonWorldEvent.HarrowStorms.HarrowStormStatus.list.ended)
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
function LibDragonWorldEvent.Events.onWEUnitPin(eventCode, worldEventInstanceId, unitTag, oldPinType, newPinType)
    if LibDragonWorldEvent.ready == false then
        return
    end

    if LibDragonWorldEvent.Dragons.ZoneInfo.onMap == false then
        return
    end

    local dragon = LibDragonWorldEvent.Dragons.DragonList:obtainForWEInstanceId(worldEventInstanceId)
    local status = LibDragonWorldEvent.Dragons.DragonStatus:convertMapPin(newPinType)

    if dragon == nil then -- dragon not already created
        return
    end

    if status == LibDragonWorldEvent.Dragons.DragonStatus.list.waiting and dragon.justPoped == true then
        status = LibDragonWorldEvent.Dragons.DragonStatus.list.flying
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
function LibDragonWorldEvent.Events.onWELocChanged(eventCode, worldEventInstanceId, oldWorldEventLocationId, newWorldEventLocationId)
    if LibDragonWorldEvent.ready == false then
        return
    end

    if LibDragonWorldEvent.Dragons.ZoneInfo.onMap == false then
        return
    end

    local dragon       = LibDragonWorldEvent.Dragons.DragonList:obtainForWEInstanceId(worldEventInstanceId)
    local flyingStatus = LibDragonWorldEvent.Dragons.DragonStatus.list.flying

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
function LibDragonWorldEvent.Events.onGuiChanged(eventCode)
    if LibDragonWorldEvent.ready == false then
        return
    end
end
