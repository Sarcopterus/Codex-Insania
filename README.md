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

The system listens to GMCP events to keep your curing and defences updated.  Modules can be extended by adding new files under `AchaeaSystem/modules`.
