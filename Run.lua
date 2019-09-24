EVENT_MANAGER:RegisterForEvent(LibDragonWorldEvent.name, EVENT_ADD_ON_LOADED, LibDragonWorldEvent.Events.onLoaded)
EVENT_MANAGER:RegisterForEvent(LibDragonWorldEvent.name, EVENT_PLAYER_ACTIVATED, LibDragonWorldEvent.Events.onLoadScreen)
EVENT_MANAGER:RegisterForEvent(LibDragonWorldEvent.name, EVENT_WORLD_EVENT_ACTIVATED, LibDragonWorldEvent.Events.onWEActivate)
EVENT_MANAGER:RegisterForEvent(LibDragonWorldEvent.name, EVENT_WORLD_EVENT_DEACTIVATED, LibDragonWorldEvent.Events.onWEDeactivate)
EVENT_MANAGER:RegisterForEvent(LibDragonWorldEvent.name, EVENT_WORLD_EVENT_UNIT_CHANGED_PIN_TYPE, LibDragonWorldEvent.Events.onWEUnitPin)
-- EVENT_MANAGER:RegisterForEvent(LibDragonWorldEvent.name, EVENT_GAME_CAMERA_UI_MODE_CHANGED, LibDragonWorldEvent.Events.onGuiChanged) -- Used to dump some data, so to debug only
