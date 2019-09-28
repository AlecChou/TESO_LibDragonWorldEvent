# Lib Dragon World Event

It's an library addon for [The Elder Scroll Online](https://www.elderscrollsonline.com) which give info about dragons in Elsweyr.

## Dependencies

Only the game. No addon or library is needed.

## Install it

Into the addon folder (`Elder Scrolls Online\live\AddOns` in your document folder), you need to have a folder `LibDragonWorldEvent` and copy all files into it.

So you can :

* Clone the repository in the AddOns folder and name it `LibDragonWorldEvent`.
* Or download the zip file of the last release in github, extract it in the AddOns folder, and rename `TESO_LibDragonWorldEvent-{release}` to `LibDragonWorldEvent`.

## Use it in your addon

Into the txt file for your addon, just add (not declare lua files for this lib) :
```
## DependsOn: LibDragonWorldEvent
```

And you have the choice to include it into a `libs` folder, or say to your user to also download the lib.

## API usage

A dragon is a "World Event" in the API, so we use some event on WorldEvents.

Events triggered :

* `EVENT_ADD_ON_LOADED` : When the addon is loaded
* `EVENT_PLAYER_ACTIVATED` : When a load screen displayed
* `EVENT_WORLD_EVENT_ACTIVATED` : When a WorldEvent start (aka dragon pop)
* `EVENT_WORLD_EVENT_DEACTIVATED` : When a WorldEvent finish (aka dragon killed)
* `EVENT_WORLD_EVENT_UNIT_CHANGED_PIN_TYPE` : When the worldEvent's map pin change (aka new dragon, of change status to "in fight" or "waiting")
* `EVENT_GAME_CAMERA_UI_MODE_CHANGED` : A change in camera mode (free mouse, open inventory, etc). **In released versions, this event is not triggered.** I use it to dump some data when I dev or debug.

Note : Dark anchor, world bosses, etc are not trigger WorldEvent events. So I cannot catch events on them.

## Status

There are 6 status displayed :

* Flying : Dragon just appears, and flying.
* Waiting : Dragon is on the ground and waiting for the fight.
* In fight : Currently in fight against players, with his life > 50%.
* In fight (life < 50%) : Currently in fight against players, with his life < 50%.
* Killed : Dead.
* Unknown : Only to catch not managed cases, normally you should never see this status.

## About lua files

There are loaded in order :

* Initialise.lua
* Dragon.lua
* DragonList.lua
* DragonStatus.lua
* Events.lua
* Timer.lua
* FlyTimer.lua
* Zone.lua
* Run.lua

### Initialise.lua

Declare all variables and the initialise function.

Declared variables :

* `LibDragonWorldEvent` : The global table for all addon's properties and methods.
* `LibDragonWorldEvent.name` : The addon name
* `LibDragonWorldEvent.ready` : If the addon is ready to be used

### Dragon.lua

Table : `LibDragonWorldEvent.Dragon`

Contain all info about a dragon. It's a OOP like with one instance of Dragon by dragon on the map.

Properties :

* `dragonIdx` : Index in the DragonList
* `WEInstanceId` : The WorldEventInstanceId
* `WEId` : The WorldEventId, obtained by function `GetWorldEventId`
* `unit` : Info about unit
  * `tag` : The unit tag
  * `pin` : The unit pin
* `position` : Dragon position (not real-time)
  * `x`
  * `y`
  * `z`
* `status` : Info about dragon's status
  * `previous` : The previous status
  * `current` : The current status
  * `time` : Time when current status has been defined (0 to unknown)

Methods :

* `LibDragonWorldEvent.Dragon:new` : To instanciate a new Dragon instance
* `LibDragonWorldEvent.Dragon:updateWEId` : Update the property `WEId`
* `LibDragonWorldEvent.Dragon:updateUnit` : Update properties `unit.tag` and `unit.pin`
* `LibDragonWorldEvent.Dragon:changeStatus` : Change the dragon's current status
* `LibDragonWorldEvent.Dragon:resetWithStatus` : Reset dragon's status (like just instancied) with a status.
* `LibDragonWorldEvent.Dragon:execStatusFunction` : To call the method dedicated to a status when a dragon change its status from `changeStatus()`.
* `LibDragonWorldEvent.Dragon:poped` : Called when the dragon pop
* `LibDragonWorldEvent.Dragon:killed` : Called when the dragon is killed
* `LibDragonWorldEvent.Dragon:waiting` : Called when the dragon now waiting player
* `LibDragonWorldEvent.Dragon:fight` : Called when the dragon go in fight
* `LibDragonWorldEvent.Dragon:weak` : Called when the dragon is now weak
* `LibDragonWorldEvent.Dragon:flying` : Called when the dragon start to fly
* `LibDragonWorldEvent.Dragon:onLanded` : Called when the dragon just landed

Events :

* `LibDragonWorldEvent.Events.callbackEvents.dragon.new`  
When a new dragon is created.  
callback : `function(table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.changeStatus`  
When a dragon change its status.  
callback : `function(table dragon, string newStatus)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.resetStatus`  
When a dragon change its status.  
callback : `function(table dragon, string newStatus)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.poped`  
When the dragon pop.  
callback : `function(table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.killed`  
When the dragon is killed.  
callback : `function(table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.waiting`  
When the dragon waiting player.  
callback : `function(table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.fight`  
When the dragon go in fight.  
callback : `function(table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.weak`  
When the dragon is now weak.  
callback : `function(table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.flying`  
When the dragon start to fly.  
callback : `function(table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragon.landed`  
When the dragon just landed.  
callback : `function(table dragon)`

### DragonList.lua

Table : `LibDragonWorldEvent.DragonList`

Contain all instancied Dragon instance.

Properties :

* `list` : List of Dragon instance
* `nb` : Number of item in `list`
* `WEInstanceIdToListIdx` : Table with WEInstanceId in key, and index in `list` for value.

Methods :

* `LibDragonWorldEvent.DragonList:reset` : Reset the list
* `LibDragonWorldEvent.DragonList:add` : Add a new dragon to the list
* `LibDragonWorldEvent.DragonList:execOnAll` : Execute a callback for all dragon
* `LibDragonWorldEvent.DragonList:obtainForWEInstanceId` : Obtain the dragon instance for a WEInstanceId
* `LibDragonWorldEvent.DragonList:update` : To update the list : remove all dragon or create all dragon compared to Zone info.
* `LibDragonWorldEvent.DragonList:removeAll` : Remove all dragon and reset GUI items
* `LibDragonWorldEvent.DragonList:createAll` : Create all dragon for the zone

Events :

* `LibDragonWorldEvent.Events.callbackEvents.dragonList.reset`  
When the list is reset.  
callback : `function(table dragonList)`
* `LibDragonWorldEvent.Events.callbackEvents.dragonList.add`  
When a dragon is added to the list.  
callback : `function(table dragonList, table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragonList.update`  
When the list updated with zone info.  
callback : `function(table dragonList)`
* `LibDragonWorldEvent.Events.callbackEvents.dragonList.removeAll`  
When all dragon is removed from the list.  
callback : `function(table dragonList)`
* `LibDragonWorldEvent.Events.callbackEvents.dragonList.createAll`  
When all dragon for a zone are instancied.  
callback : `function(table dragonList)`

### DragonStatus.lua

Table : `LibDragonWorldEvent.DragonStatus`

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

* `LibDragonWorldEvent.DragonStatus:initForDragon` : Initialise status for a dragon
* `LibDragonWorldEvent.DragonStatus:checkAllDragon` : Check status for all dragon in DragonList
* `LibDragonWorldEvent.DragonStatus:checkForDragon` : Check the status of a dragon to know if the status is correct or not.
* `LibDragonWorldEvent.DragonStatus:convertMapPin` : Convert from `MAP_PIN_TYPE_DRAGON_*` constant value to `LibDragonWorldEvent.DragonStatus.list` value

Events :

* `LibDragonWorldEvent.Events.callbackEvents.dragonStatus.initDragon`  
When the status of a dragon is initialised.  
callback : `function(table dragonStatus, table dragon)`
* `LibDragonWorldEvent.Events.callbackEvents.dragonStatus.checkAllDragon`  
When the status of all instancied dragon is checked.  
callback : `function(table dragonStatus)`
* `LibDragonWorldEvent.Events.callbackEvents.dragonStatus.checkDragon`  
When the status of a dragon is checked.  
callback : `function(table dragonStatus, table dragon)`

### Events.lua

Table : `LibDragonWorldEvent.Events`

Define a callbackManager to fire events, and contain all functions called when a listened event is triggered.

Property :

* `callbackManager` : The callback manager used to fire events
* `callbackEvents` : Name of all events sent

Methods :

* `LibDragonWorldEvent.Events.onLoaded` : Called when the addon is loaded
* `LibDragonWorldEvent.Events.onLoadScreen` : Called after each load screen
* `LibDragonWorldEvent.Events.onWEActivate` : Called when a World Event start (aka dragon pop).
* `LibDragonWorldEvent.Events.onWEDeactivate` : Called when a World Event is finished (aka dragon killed).
* `LibDragonWorldEvent.Events.onWEUnitPin` : Called when a World Event has this map pin changed (aka new dragon or dragon in fight).
* `LibDragonWorldEvent.Events.onGuiChanged` : Called when something changes in the GUI (like open inventory).  
Used to debug only, the line to add the listener on the event is commented.

### Timer.lua

Table : `LibDragonWorldEvent.Timer`

Contain all function to manage a timer

Properties :

* `name` : The timer's name
* `enabled` : If the timer is enabled or not
* `time` : The timer clock in ms

Methods :

* `LibDragonWorldEvent.Timer:enable` : Enable the timer
* `LibDragonWorldEvent.Timer:disable` : Disable the timer
* `LibDragonWorldEvent.Timer.update` : Callback function on timer. Called each `LibDragonWorldEvent.Timer.time` ms.
* `LibDragonWorldEvent.Timer:changeStatus` : Call the method to enable or disable timer according to newStatus value

### FlyTimer.lua

Table : `LibDragonWorldEvent.FlyTimer`  
Extends : `LibDragonWorldEvent.Timer`

Contain all function to manage the timer used to know if a dragon currently flying or not

Methods :

* `LibDragonWorldEvent.GUITimer:new` : To create a new instance of FlyTimer. There are one instance by dragon.
* `LibDragonWorldEvent.GUITimer:disable` : Disable the timer; Override the parent function to call the function `Dragon:onLanded()`.
* `LibDragonWorldEvent.GUITimer.update` : Callback function on timer. Called each 1sec in dragons zone. Check if the dragon fly or not.

### Zone.lua

Table : `LibDragonWorldEvent.Zone`

Contain all function to know if the current zone has dragons or not

Properties :

* `onDragonZone` : If player is on a zone with dragon (zone = Elsweyr)
* `onDragonMap` : If player is on a map with dragon (map = delve, dungeon, none, ...)
* `lastMapZoneIdx` : The previous MapZoneIndex
* `changedZone` : If the player has changed zone
* `info` : Info about the current zone (ref to list value corresponding to the zone)
* `nbZone` : Number of zone in the list
* `list` : List of info about zones with dragons.
  Each value is a table with keys :
  * `mapZoneIdx` : The zone's MapZoneIndex
  * `mapName` : The zone/subzone name; Formated to LibMapPins format.
  * `nbDragons` : Number of dragon in the zone
  * `dragons` : Info about each dragon
    * `title` : Title to use for each dragon
    * `WEInstanceId` : The WorldEventInstanceId for each dragon

Methods :

* `LibDragonWorldEvent:updateInfo` : Update info about the current zone.
* `LibDragonWorldEvent:checkDragonZone` : Check if it's a zone with dragons.

Events :

* `LibDragonWorldEvent.Events.callbackEvents.Zone.updateInfo`  
When info about current zone/map is updated.  
callback : `function(table Zone)`
* `LibDragonWorldEvent.Events.callbackEvents.Zone.checkDragonZone`  
When we check if the map contains dragons.  
callback : `function(table Zone)`

### Run.lua

Define a listener to all used events.
