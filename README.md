System made for Achaea

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

Each module exposes a `register()` method to attach its event handlers and an `unregister()` method to clean up.
Modules also define an optional `init()` which the core calls during startup to register default handlers.  You can reload a module at any time by running its `unregister()` and `register()` functions.

### Custom Events
Modules communicate using Mudlet's event system.  `AchaeaSystem.fireEvent(name, ...)` will raise an event, while `AchaeaSystem.on(name, handler)` registers a new anonymous handler.  Store the returned id and pass it to `AchaeaSystem.off(id)` to remove the handler.

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

### Example
```lua
-- load bashing and gui helpers
local pve = AchaeaSystem.modules.pve
pve.register()
pve.start("training dummy")
AchaeaSystem.modules.gui.init()
```

### Events and Aliases
See each module header for the events it registers. Aliases such as `crowdmap goto <area>` or `extinction <target>` rely on the standard Achaea aliases provided by the Mudlet client.