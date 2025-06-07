# Codex-Insania

Modular Mudlet system for **Achaea**. Includes automatic curing, PvE/PvP helpers and optional GUI.  Optimised for the *Unnamable* SnB specialization.

## Installation
1. Download or clone this repository.
2. In Mudlet, go to `Settings -> Script Import` and select `AchaeaSystem/core.lua`.
3. The system will load its modules automatically on first run.

## Basic Commands
- `lua AchaeaSystem.modules.pve.start("target")` - begin automated bashing.
- `lua AchaeaSystem.modules.pve.stop()` - stop bashing.
- `lua AchaeaSystem.modules.group.follow("leader")` - follow a group leader.
- `lua AchaeaSystem.modules.group.stop()` - stop following.

The system listens to GMCP events to keep your curing and defences updated. Modules can be extended by adding new files under `AchaeaSystem/modules`.

## Modules
- **curing** – hybrid server/client curing helpers.
- **pve** – automated bashing using Crowdmap.
- **pvp** – utilities for limb counting and Unnamable class logic.
- **group** – group coordination tools.
- **shrine** – essence donation and corpse offering automation.
- **gui** – Geyser front-end.
- **eventBus** – lightweight publish/subscribe hub.
- **queue** – action queue used by all modules.
- **limbs** – facade for Romaen's limb tracker. Install `limb.1.3.mpackage` manually; it is not included in this repository.
- **affSync** – bridge to AfflictionTracker emitting `aff.update`.
- **limbSync** – optional bridge to Legacy limb tracker emitting `limb.update`.
- **offense** – finisher logic, toggle with `opp on|off`.
- **groupComms** – responds to focus tells from leader.
- **curing** – controls server-side curing. Toggle with `ssc on|off`.
- **cooldowns** – tracks skill cooldowns and emits `cooldown.*` events.
- **targeting** – central target handler listening to focus tells.
- **area** – records recently visited areas.

Each module exposes a `register()` method to attach its event handlers and an `unregister()` method to clean up.
Modules also define an optional `init()` which the core calls during startup to register default handlers. You may reload a module at any time by running its `unregister()` function followed by `register()`.
Modules listed in `core.lua` are loaded automatically when the system initialises.

### Custom Events
Modules communicate through a small pub/sub API. Use `AchaeaSystem.publish("event", ...)` to raise an event and `AchaeaSystem.subscribe("event", handler)` to listen. Remove a subscription with `AchaeaSystem.unsubscribe(id)`.
For normal Mudlet events you can register callbacks with `AchaeaSystem.registerEventHandler(event, handler)` (alias `AchaeaSystem.on`) which returns an id for later removal via `AchaeaSystem.unregisterEventHandler(id)` (alias `AchaeaSystem.off`). `AchaeaSystem.fireEvent` is a synonym for `publish`.
The event API is implemented by the `eventBus` module and can be used by your own scripts as well.

### Loading Modules
To enable a feature, call its `register()` function. When you no longer need the
feature during a session, call `unregister()` to remove its triggers and handlers.

```lua
-- start the curing module
local curing = AchaeaSystem.modules.curing
curing.register()

-- later, disable it
curing.unregister()
```

### Server Curing
Toggle server-side curing:

```
ssc on
ssc off
enemyclass <class>
```

### Example
```lua
-- load bashing and gui helpers
local pve = AchaeaSystem.modules.pve
pve.register()
pve.start("training dummy")
AchaeaSystem.modules.gui.init()
```


### Shrine Module Example
The shrine module tracks nearby shrines and corpses. It publishes `shrine.essence`, `shrine.presence`, and `shrine.corpses` events.

```lua
local shrine = AchaeaSystem.modules.shrine
shrine.register()
AchaeaSystem.subscribe('shrine.essence', function(amount)
  cecho('<blue>Essence now: ' .. amount .. '\n')
end)
```

### Offense Module Example
The offense module listens to your affliction and limb trackers. Toggle it with
`opp on` or `opp off`.

```lua
local offense = AchaeaSystem.modules.offense
offense.register()
```
### Events and Aliases
See each module header for the events it registers. Aliases such as `crowdmap goto <area>` or `extinction <target>` rely on the standard Achaea aliases provided by the Mudlet client.
Additional aliases:
```
cd <skill>      -- show cooldown remaining
focus <name>    -- set current target
horror          -- add a horror stack manually
opp on|off      -- toggle PvP brain loop
shrineauto on|off -- auto offer corpses when near a shrine
setfinisher <n> -- set horror stack threshold
lastareas       -- print recently visited areas
setclass <cls>  -- override class module
focusme         -- tell group to focus you
```

### Development
Run `lua5.4 scripts/test_runner.lua` to check syntax. Documentation is generated in `docs/api/` on load.
