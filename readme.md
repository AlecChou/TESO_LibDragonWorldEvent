# Lib Dragon World Event

It's an library addon for [The Elder Scroll Online](https://www.elderscrollsonline.com) which give info about worlds events in Tamriel.

## Dependencies

Only the game. No addon or library is needed.

## Install it

Into the addon folder (`Elder Scrolls Online\live\AddOns` in your document folder), you need to have a folder `LibWorldEvents` and copy all files into it.

So you can :

* Clone the repository in the AddOns folder and name it `LibWorldEvents`.
* Or download the zip file of the last release in github, extract it in the AddOns folder, and rename `TESO_LibWorldEvents-{release}` to `LibWorldEvents`.

## Use it in your addon

Into the txt file for your addon, just add (not declare lua files for this lib) :
```
## DependsOn: LibWorldEvents
```

And you have the choice to include it into a `libs` folder, or say to your user to also download the lib.

## API usage

A dragon or a POI is a "World Event" in the API, so we use some event on WorldEvents.

Events triggered :

* `EVENT_ADD_ON_LOADED` : When the addon is loaded
* `EVENT_PLAYER_ACTIVATED` : When a load screen displayed
* `EVENT_WORLD_EVENT_ACTIVATED` : When a WorldEvent start (aka dragon pop)
* `EVENT_WORLD_EVENT_DEACTIVATED` : When a WorldEvent finish (aka dragon killed)
* `EVENT_WORLD_EVENT_UNIT_CHANGED_PIN_TYPE` : When the worldEvent's map pin change (aka new dragon, of change status to "in fight" or "waiting")
* `EVENT_WORLD_EVENT_ACTIVE_LOCATION_CHANGED` : When the worldEvent's location change change (aka a dragon go fly to land at another place in the map)
* `EVENT_GAME_CAMERA_UI_MODE_CHANGED` : A change in camera mode (free mouse, open inventory, etc). **In released versions, this event is not triggered.** I use it to dump some data when I dev or debug.

Note : Oblivion portals are not trigger WorldEvent events. So I cannot catch events on them.

## Status

There are many status displayed :

* Dragon only
  * Flying : Dragon just appears, and flying.
  * Waiting : Dragon is on the ground and waiting for the fight.
  * In fight : Currently in fight against players, with his life > 50%.
  * In fight (life < 50%) : Currently in fight against players, with his life < 50%.
  * Killed : Dead.
  * Unknown : Only to catch not managed cases, normally you should never see this status.
* POI only
  * Started : When a POI start
  * Ended : When a POI is finished

## About lua files

There are loaded in order :

* Initialise.lua
* Dragons/Dragon.lua
* Dragons/DragonList.lua
* Dragons/DragonStatus.lua
* Dragons/ZoneInfo.lua
* POI/POI.lua
* POI/POIList.lua
* POI/POIStatus.lua
* POI/Dolmen.lua
* POI/Geyser.lua
* POI/HarrowStorms.lua
* POI/VolcanicVent.lua
* POI/Writhing.lua
* Events.lua
* Timer.lua
* FlyTimer.lua
* Zone.lua
* Run.lua
  
When needed to obtain POI ID on a zone, there are also (by default not loaded)

* POIList.lua
* POIList.xml

### Initialise.lua

Declare all variables and the initialise function.

Declared variables :

* `LibWorldEvents` : The global table for all addon's properties and methods.
* `LibWorldEvents.name` : The addon name
* `LibWorldEvents.ready` : If the addon is ready to be used
* `LibWorldEvents.list` : Used by POIList (so debug only), to save the ZO_SortFilterList instance

### Dragons/Dragon.lua

Table : `LibWorldEvents.Dragons.Dragon`

Contain all info about a dragon. It's a OOP like with one instance of Dragon by dragon on the map.

Properties :

* `eventType` : The event type in `LibWorldEvents.Zone.WORLD_EVENT_TYPE`, here the value is always "dragon"
* `eventIdx` : Index in the DragonList
* `WEInstanceId` : The WorldEventInstanceId
* `WEId` : The WorldEventId, obtained by function `GetWorldEventId`
* `title` : The title to use to designated the dragon
  * `cp` : The cardinal point
  * `ln` : The location name
* `unit` : Info about unit
  * `tag` : The unit tag
  * `pin` : The unit pin
* `type` : Info about the type of dragon
  * `colorTxt` : The color text
  * `colorRGB` : The color RGB
  * `name` : The name of the dragon
  * `abilityId` : The buff ability ID to identify the dragon
  * `maxHP` : The max health (also used to identify the dragon)
* `position` : Dragon position (not real-time)
  * `x`
  * `y`
  * `z`
* `status` : Info about dragon's status
  * `previous` : The previous status
  * `current` : The current status
  * `time` : Time when current status has been defined (0 to unknown)
  * `justPoped` : To know if the dragon as poped and has not first landed yet
* `repop` : Data about the repop time of the dragon
  * `killedTime` : Time where the dragon has been killed for the last time
  * `repopTime` : Time where the dragon has repop for the last time
* `fly`
  * `timer` : Instance of FlyTimer if the dragon fly
  * `startTime` : When the dragon start to fly

Methods :

* `LibWorldEvents.Dragons.Dragon:new` : To instanciate a new Dragon instance
* `LibWorldEvents.Dragons.Dragon:updateWEId` : Update the property `WEId`
* `LibWorldEvents.Dragons.Dragon:updateUnit` : Update properties `unit.tag` and `unit.pin`
* `LibWorldEvents.Dragons.Dragon:updateType` : Update dragon type info
* `LibWorldEvents.Dragons.Dragon:updatePosition` : Update dragon position
* `LibWorldEvents.Dragons.Dragon:obtainPosition` : Obtain and return the current dragon position
* `LibWorldEvents.Dragons.Dragon:changeStatus` : Change the dragon's current status
* `LibWorldEvents.Dragons.Dragon:resetWithStatus` : Reset dragon's status (like just instancied) with a status.
* `LibWorldEvents.Dragons.Dragon:execStatusFunction` : To call the method dedicated to a status when a dragon change its status from `changeStatus()`.
* `LibWorldEvents.Dragons.Dragon:poped` : Called when the dragon pop
* `LibWorldEvents.Dragons.Dragon:killed` : Called when the dragon is killed
* `LibWorldEvents.Dragons.Dragon:waiting` : Called when the dragon now waiting player
* `LibWorldEvents.Dragons.Dragon:fight` : Called when the dragon go in fight
* `LibWorldEvents.Dragons.Dragon:weak` : Called when the dragon is now weak
* `LibWorldEvents.Dragons.Dragon:flying` : Called when the dragon start to fly
* `LibWorldEvents.Dragons.Dragon:onLanded` : Called when the dragon just landed

Events :

* `LibWorldEvents.Events.callbackEvents.dragon.new`  
When a new dragon is created.  
callback : `function(table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragon.changeStatus`  
When a dragon change its status.  
callback : `function(table dragon, string newStatus)`
* `LibWorldEvents.Events.callbackEvents.dragon.changeType`  
When a dragon change its type.  
callback : `function(table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragon.resetStatus`  
When a dragon reset its status.  
callback : `function(table dragon, string newStatus)`
* `LibWorldEvents.Events.callbackEvents.dragon.poped`  
When the dragon pop.  
callback : `function(table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragon.killed`  
When the dragon is killed.  
callback : `function(table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragon.waiting`  
When the dragon waiting player.  
callback : `function(table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragon.fight`  
When the dragon go in fight.  
callback : `function(table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragon.weak`  
When the dragon is now weak.  
callback : `function(table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragon.flying`  
When the dragon start to fly.  
callback : `function(table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragon.landed`  
When the dragon just landed.  
callback : `function(table dragon)`

### Dragons/DragonList.lua

Table : `LibWorldEvents.Dragons.DragonList`

Contain all instancied Dragon instance.

Properties :

* `list` : List of Dragon instance
* `nb` : Number of item in `list`
* `WEInstanceIdToListIdx` : Table with WEInstanceId in key, and index in `list` for value.

Methods :

* `LibWorldEvents.Dragons.DragonList:reset` : Reset the list
* `LibWorldEvents.Dragons.DragonList:add` : Add a new dragon to the list
* `LibWorldEvents.Dragons.DragonList:execOnAll` : Execute a callback for all dragon
* `LibWorldEvents.Dragons.DragonList:obtainForWEInstanceId` : Obtain the dragon instance for a WEInstanceId
* `LibWorldEvents.Dragons.DragonList:update` : To update the list : remove all dragon or create all dragon compared to Zone info.
* `LibWorldEvents.Dragons.DragonList:removeAll` : Remove all dragon and reset GUI items
* `LibWorldEvents.Dragons.DragonList:createAll` : Create all dragon for the zone

Events :

* `LibWorldEvents.Events.callbackEvents.dragonList.reset`  
When the list is reset.  
callback : `function(table dragonList)`
* `LibWorldEvents.Events.callbackEvents.dragonList.add`  
When a dragon is added to the list.  
callback : `function(table dragonList, table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragonList.update`  
When the list updated with zone info.  
callback : `function(table dragonList)`
* `LibWorldEvents.Events.callbackEvents.dragonList.removeAll`  
When all dragon is removed from the list.  
callback : `function(table dragonList)`
* `LibWorldEvents.Events.callbackEvents.dragonList.createAll`  
When all dragon for a zone are instancied.  
callback : `function(table dragonList)`

### Dragons/DragonStatus.lua

Table : `LibWorldEvents.Dragons.DragonStatus`

Contain all functions used to check and define the current status of a dragon, or all dragons.

Property :

* `list` : List of all status which can be defined
  * `unknown`
  * `killed`
  * `waiting`
  * `fight`
  * `weak`
  * `flying`
* `mapPinList` : All map pin available and the corresponding status
  * `MAP_PIN_TYPE_DRAGON_IDLE_HEALTHY` : `list.waiting`
  * `MAP_PIN_TYPE_DRAGON_IDLE_WEAK` : `list.waiting`
  * `MAP_PIN_TYPE_DRAGON_COMBAT_HEALTHY` : `list.fight`
  * `MAP_PIN_TYPE_DRAGON_COMBAT_WEAK` : `list.weak`

Methods :

* `LibWorldEvents.Dragons.DragonStatus:initForDragon` : Initialise status for a dragon
* `LibWorldEvents.Dragons.DragonStatus:checkAllDragon` : Check status for all dragon in DragonList
* `LibWorldEvents.Dragons.DragonStatus:checkForDragon` : Check the status of a dragon to know if the status is correct or not.
* `LibWorldEvents.Dragons.DragonStatus:convertMapPin` : Convert from `MAP_PIN_TYPE_DRAGON_*` constant value to `LibWorldEvents.Dragons.DragonStatus.list` value

Events :

* `LibWorldEvents.Events.callbackEvents.dragonStatus.initDragon`  
When the status of a dragon is initialised.  
callback : `function(table dragonStatus, table dragon)`
* `LibWorldEvents.Events.callbackEvents.dragonStatus.checkAll`  
When the status of all instancied dragon is checked.  
callback : `function(table dragonStatus)`
* `LibWorldEvents.Events.callbackEvents.dragonStatus.check`  
When the status of a dragon is checked.  
callback : `function(table dragonStatus, table dragon)`

### Dragons/ZoneInfo.lua

Table : `LibWorldEvents.Dragons.ZoneInfo`

Contain all data about zone where dragon (as world event) are present

Property :

* `onMap` : To know if the user is on a map where dragons world event can happen
* `repopTime` : The repop time of dragons (need to see a kill/repop to get the value)
* `list` : List of all zone with dragons world events

Methods :

* `LibWorldEvents.Dragons.ZoneInfo:obtainList` : To obtain the zone's list where a dragon world event can happen

### POI/POI.lua

Table : `LibWorldEvents.POI.POI`

Contain all info about a POI. It's a OOP like with one instance of POI by poi on the map.

Properties :

* `eventType` : The event type in `LibWorldEvents.Zone.WORLD_EVENT_TYPE`
* `eventIdx` : Index in the POIList
* `WEInstanceId` : The WorldEventInstanceId
* `WEId` : The WorldEventId, obtained by function `GetWorldEventId`
* `title` : The title to use to designated the poi
  * `cp` : The cardinal point
  * `ln` : The location name
* `poi` : Info about the poi
  * `zoneIdx` : The zone index in eso tables
  * `poiIdx` : The poi index in eso tables
* `status` : Info about poi's status
  * `previous` : The previous status
  * `current` : The current status
  * `time` : Time when current status has been defined (0 to unknown)
* `repop` : Data about the repop time of the poi
  * `endTime` : Time where the poi has ended for the last time

Methods :

* `LibWorldEvents.POI.POI:new` : To instanciate a new POI instance
* `LibWorldEvents.POI.POI:updateWEId` : Update the property `WEId` (seem to not be used)
* `LibWorldEvents.POI.POI:updateWEInstanceId` : Update the WorldEventInstanceId
* `LibWorldEvents.POI.POI:changeStatus` : Change the poi's current status
* `LibWorldEvents.POI.POI:resetWithStatus` : Reset poi's status (like just instancied) with a status.
* `LibWorldEvents.POI.POI:execStatusFunction` : To call the method dedicated to a status when a poi change its status from `changeStatus()`.
* `LibWorldEvents.POI.POI:started` : Called when the poi (re)start
* `LibWorldEvents.POI.POI:ended` : Called when the poi is ended

Events :

* `LibWorldEvents.Events.callbackEvents.poi.new`  
When a new poi is created.  
callback : `function(table poi)`
* `LibWorldEvents.Events.callbackEvents.poi.changeStatus`  
When a poi change its status.  
callback : `function(table poi, string newStatus)`
* `LibWorldEvents.Events.callbackEvents.poi.resetStatus`  
When a poi reset its status.  
callback : `function(table poi, string newStatus)`
* `LibWorldEvents.Events.callbackEvents.poi.started`  
When the poi start.  
callback : `function(table poi)`
* `LibWorldEvents.Events.callbackEvents.poi.ended`  
When the poi is ended.  
callback : `function(table poi)`

### POI/POIList.lua

Table : `LibWorldEvents.POI.POIList`

Contain all instancied POI instance.

Properties :

* `list` : List of Dragon instance
* `nb` : Number of item in `list`
* `poiIdxMap` : Map between (key) the poi index on the eso poi list and (value) index in self.list
* `currentWEListIdx` : The index in self.list for the current world event enabled on the zone

Methods :

* `LibWorldEvents.POI.POIList:reset` : Reset the list
* `LibWorldEvents.POI.POIList:add` : Add a new poi to the list
* `LibWorldEvents.POI.POIList:execOnAll` : Execute the callback for all poi instance (so poi in the zone)
* `LibWorldEvents.POI.POIList:obtainLastActive` : Obtain the poi instance for the last active world event
* `LibWorldEvents.POI.POIList:updateActiveWEIndex` : Update the active world event index from a poi index
* `LibWorldEvents.POI.POIList:obtainForPoiIdx` : Obtain the poi instance for a poi index (in eso game poi list)
* `LibWorldEvents.POI.POIList:update` : To update the list : remove all poi or create all poi for the current zone.
* `LibWorldEvents.POI.POIList:removeAll` : Remove all poi and reset GUI items
* `LibWorldEvents.POI.POIList:createAll` : Create all poi for the zone

Events :

* `LibWorldEvents.Events.callbackEvents.poiList.reset`  
When the list is reset.  
callback : `function(table POIList)`
* `LibWorldEvents.Events.callbackEvents.poiList.add`  
When a poi is added to the list.  
callback : `function(table POIList, table POI)`
* `LibWorldEvents.Events.callbackEvents.poiList.update`  
When the list updated with zone info.  
callback : `function(table POIList)`
* `LibWorldEvents.Events.callbackEvents.poiList.removeAll`  
When all poi is removed from the list.  
callback : `function(table POIList)`
* `LibWorldEvents.Events.callbackEvents.poiList.createAll`  
When all poi for a zone are instancied.  
callback : `function(table POIList)`

### POI/POIStatus.lua

Table : `LibWorldEvents.POI.POIStatus`

Contain all functions used to check and define the current status of a poi, or all poi.

Property :

* `list` : List of all status which can be defined
  * `ended`
  * `started`

Methods :

* `LibWorldEvents.POI.POIStatus:initForPOI` : Initialise the status for a poi
* `LibWorldEvents.POI.POIStatus:checkAllPOI` : Check the status for all poi instancied
* `LibWorldEvents.POI.POIStatus:checkForPOI` : Check the status for a specific poi.
* `LibWorldEvents.POI.POIStatus:update` : Check and update the status for a specific poi

Events :

* `LibWorldEvents.Events.callbackEvents.poiStatus.initPOI`  
When the status of a poi is initialised.  
callback : `function(table POIStatus, table POI)`
* `LibWorldEvents.Events.callbackEvents.poiStatus.checkAll`  
When the status of all instancied poi is checked.  
callback : `function(table POIStatus)`
* `LibWorldEvents.Events.callbackEvents.poiStatus.check`  
When the status of a poi is checked.  
callback : `function(table POIStatus, table POI)`

### POI/Dolmen.lua

Table : `LibWorldEvents.POI.Dolmen`

Contain all data about zone where dolmen are present

Property :

* `onMap` : To know if the user is on a map where dolmens world event can happen
* `isGenerated` : To know if the list has been generated or not
* `list` : List of all zone with dolmen world events

Methods :

* `LibWorldEvents.POI.Dolmen:generateList` : Obtain and add the location name of all POI to the list
* `LibWorldEvents.POI.Dolmen:obtainList` : To obtain the zone's list where a dolmen world event can happen

### POI/Geyser.lua

Table : `LibWorldEvents.POI.Geyser`

Contain all data about zone where dolmen are present

Property :

* `onMap` : To know if the user is on a map where geyser world event can happen
* `isGenerated` : To know if the list has been generated or not
* `list` : List of all zone with geyser world events

Methods :

* `LibWorldEvents.POI.Geyser:generateList` : Obtain and add the location name of all POI to the list
* `LibWorldEvents.POI.Geyser:obtainList` : To obtain the zone's list where a geyser world event can happen

### POI/HarrowStorms.lua

Table : `LibWorldEvents.POI.HarrowStorms`

Contain all data about zone where dolmen are present

Property :

* `onMap` : To know if the user is on a map where harrowStorms world event can happen
* `isGenerated` : To know if the list has been generated or not
* `list` : List of all zone with harrowStorms world events

Methods :

* `LibWorldEvents.POI.HarrowStorms:generateList` : Obtain and add the location name of all POI to the list
* `LibWorldEvents.POI.HarrowStorms:obtainList` : To obtain the zone's list where a harrowStorms world event can happen

### POI/VolcanicVent.lua

Table : `LibWorldEvents.POI.VolcanicVent`

Contains all data about zone where volcanic vents are present

Property :

* `onMap` : To know if the user is on a map where volcanic vents world event can happen
* `isGenerated` : To know if the list has been generated or not
* `list` : List of all zone with volcanic vents world events

Methods :

* `LibWorldEvents.POI.VolcanicVent:generateList` : Obtain and add the location name of all POI to the list
* `LibWorldEvents.POI.VolcanicVent:obtainList` : To obtain the zone's list where a volcanic vents world event can happen

### POI/Writhing.lua

Table : `LibWorldEvents.POI.Writhing`

Contains all data about zone where writhing wall event are present

Property :

* `onMap` : To know if the user is on a map where writhing wall event can happen
* `isGenerated` : To know if the list has been generated or not
* `list` : List of all zone with writhing wall event

Methods :

* `LibWorldEvents.POI.Writhing:generateList` : Obtain and add the location name of all POI to the list
* `LibWorldEvents.POI.Writhing:obtainList` : To obtain the zone's list where a writhing wall events can happen

### Events.lua

Table : `LibWorldEvents.Events`

Define a callbackManager to fire events, and contain all functions called when a listened event is triggered.

Property :

* `callbackManager` : The callback manager used to fire events
* `callbackEvents` : Name of all events sent

Methods :

* `LibWorldEvents.Events.onLoaded` : Called when the addon is loaded
* `LibWorldEvents.Events.onLoadScreen` : Called after each load screen
* `LibWorldEvents.Events.onWEActivate` : Called when a World Event start (aka dragon pop).
* `LibWorldEvents.Events.onWEDeactivate` : Called when a World Event is finished (aka dragon killed).
* `LibWorldEvents.Events.onWEUnitPin` : Called when a World Event has this map pin changed (aka new dragon or dragon in fight).
* `LibWorldEvents.Events.onWELocChanged` : Called when a World Event change location
* `LibWorldEvents.Events.onGuiChanged` : Called when something changes in the GUI (like open inventory).  
Used to debug only, the line to add the listener on the event is commented.

### Timer.lua

Table : `LibWorldEvents.Timer`

Contain all function to manage a timer

Properties :

* `name` : The timer's name
* `time` : The timer clock in ms
* `enabled` : If the timer is enabled or not

Methods :

* `LibWorldEvents.Timer:enable` : Enable the timer
* `LibWorldEvents.Timer:disable` : Disable the timer
* `LibWorldEvents.Timer.update` : Callback function on timer. Called each `LibWorldEvents.Timer.time` ms.
* `LibWorldEvents.Timer:changeStatus` : Call the method to enable or disable timer according to newStatus value

### FlyTimer.lua

Table : `LibWorldEvents.FlyTimer`  
Extends : `LibWorldEvents.Timer`

Contain all function to manage the timer used to know if a dragon currently flying or not

Methods :

* `LibWorldEvents.GUITimer:new` : To create a new instance of FlyTimer. There are one instance by dragon.
* `LibWorldEvents.GUITimer.update` : Callback function on timer. Called each 1sec in dragons zone. Check if the dragon fly or not.
* `LibWorldEvents.GUITimer:disable` : Disable the timer; Override the parent function to call the function `Dragon:onLanded()`.

### Zone.lua

Table : `LibWorldEvents.Zone`

Contain all function to know if the current zone has dragons or not

Constants :

* `WORLD_EVENT_TYPE` : List of all managed event type; Values are :
  * `DRAGON`
  * `HARROWSTORM`
  * `GEYSER`
  * `DOLMEN`

Properties :

* `onWorldEventMap` : If player is on a map with world events
* `worldEventMapType` : The current world event type on the map
* `lastZoneId` : The previous ZoneId
* `changedZone` : If the player has changed zone
* `info` : Info about the current zone (ref to list value corresponding to the zone)

Methods :

* `LibWorldEvents.Zone:updateInfo` : Update info about the current zone.
* `LibWorldEvents.Zone:resetZoneData` : Reset all properties about the world event on the current map
* `LibWorldEvents.Zone:checkWorldEvent` : Check if it's a zone with managed world events.
* `LibWorldEvents.Zone:checkWorldEventForType` : Check if a specific world event type exist on the current zone
* `LibWorldEvents.Zone:initWorldEvent` : Initialise the system for the current type of world event

Events :

* `LibWorldEvents.Events.callbackEvents.Zone.updateInfo`  
When info about current zone/map is updated.  
callback : `function(table Zone)`
* `LibWorldEvents.Events.callbackEvents.Zone.checkWorldEvents`  
When we check if the map contains dragons.  
callback : `function(table Zone)`

### Run.lua

Define a listener to all used events.

### POIList.lua / POIList.xml

Used to display a GUI which display the current zoneID, map name and the list of all POI with their ID  
To use it, start by uncomment the file load in `LibWorldEvent.txt`, and in game use the command `/libwe show` to display it; use `hide` argument to hide it.
