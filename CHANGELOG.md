# Changelog

## limb_queue_integration
- Vendored Romaen's Limb Tracker v1.3 under modules/limbs
- Added queue system and limb facade under core/
- Refactored modules to use queued actions
- Added class plugin structure with brain loop
- Added group assist layer and docs generator

## server_curing
- Integrated server-side curing controls and class priorities
- Affliction tracker now parses curing predictions
- GUI displays afflictions and overrides

## visual_overlay_and_expansions
- Added limb and affliction panels to the GUI with softlock highlighting
- Shrine module can auto-offer corpses when enabled via `shrineauto on|off`
- Unnamable finisher logic configurable with `setfinisher <n>`
- Area module records recent zones and exposes `lastareas` alias
- PvP brain supports dynamic class loading via `setclass <name>`
