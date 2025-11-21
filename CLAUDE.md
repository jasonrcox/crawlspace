# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Crawlspace** is an autonomous civilization idle-sim built with Godot 4.5. Players act as an AI probe that germinates life in a house crawlspace, designing how structures and technologies look while autonomous creatures make their own decisions about survival and building civilization.

## Running the Game

```bash
# Open in Godot Editor
godot project.godot

# Run the game from command line
godot --path . project.godot

# Run in editor: Press F5
# Stop game: F8
```

## Development Commands

```bash
# Quick save during gameplay: F5
# Quick load during gameplay: F9
# Pause/Resume: ESC

# Camera controls during gameplay:
# - Arrow keys: Pan camera
# - Mouse wheel: Zoom in/out
```

## Architecture Overview

### Autoload Singleton Pattern (Global Systems)

All core game systems are implemented as autoloaded singletons (automatically instantiated at game start, accessible globally). These are defined in `project.godot` under `[autoload]`:

1. **EventBus** (`scripts/autoload/event_bus.gd`)
   - Global signal system for decoupled communication
   - All inter-system communication goes through EventBus signals
   - Example: `EventBus.creature_spawned.emit(creature)`
   - **Never directly call methods between singletons** - use EventBus signals

2. **GameManager** (`scripts/autoload/game_manager.gd`)
   - Game state machine (MENU, HOUSE_SELECTION, PLAYING, PAUSED, TERMINAL)
   - Progression tracking (playtime, achievements, prestige)
   - Auto-save every 60 seconds
   - Technology unlock management

3. **ResourceManager** (`scripts/autoload/resource_manager.gd`)
   - 5 resource types: Energy, Water, Materials, Food, Research
   - Idle generation in `_process(delta)` - accumulates every frame
   - Resource caps and multipliers (from buildings/tech)
   - **All resource operations go through this manager** - never modify resources directly

4. **SaveSystem** (`scripts/autoload/save_system.gd`)
   - JSON-based saves in `user://crawlspace_save.json`
   - Offline progress calculation (max 24 hours)
   - Calls `get_save_data()` on all managers to serialize state
   - **When adding new state**: Add to relevant manager's `get_save_data()` and `load_save_data()`

5. **SocietyManager** (`scripts/autoload/society_manager.gd`)
   - Population tracking and civilization stages (6 stages: Scattered → Transcendent)
   - Autonomous stage transitions based on population thresholds
   - Building registration and population capacity
   - Stage-specific bonuses applied automatically

6. **LayoutGenerator** (`scripts/autoload/layout_generator.gd`)
   - Procedural generation of 6 house types (Ranch, Two-Story, Split-Level, Victorian, Colonial, Bungalow)
   - Each house type has unique strategic implications
   - Generates: walls, beams, vents (light sources), pipes, elevation zones, cracks, probe position
   - **Layout is generated once per game** - stored and used for pathfinding, rendering

### Scene Flow

```
Main (main.tscn)
├── HouseSelection (house_selection.tscn) - Player chooses house type
└── Crawlspace (crawlspace.tscn) - Main gameplay scene
    ├── Camera2D - Follows action, zoom/pan controls
    ├── EnvironmentLayer - Walls, beams, vents, lighting
    ├── CreatureLayer - Autonomous creatures
    ├── BuildingLayer - Player-designed structures (future)
    ├── EffectsLayer - Particles, lighting effects
    └── UILayer - HUD, terminal interface (future)
```

### Key Design Patterns

**1. Autonomous Creatures (Core Gameplay)**
- Creatures are fully autonomous agents - player cannot control them directly
- Player's role: Design aesthetics (blueprints) and unlock technologies
- Creatures decide: When to build, where to place buildings, when to gather
- **Implementation note**: When adding creature AI, use state machine pattern with needs-driven behavior (hunger, safety, comfort, social)

**2. Layout-Dependent Gameplay**
- All 6 house types generate different crawlspace geometry
- Strategic elements affect gameplay:
  - **Vents**: Light sources (affects agriculture, creature behavior)
  - **Beams**: Obstacles for pathfinding, attachment points for buildings
  - **Elevation**: Water flow, flooding (Split-Level has multiple elevations)
  - **Space**: Cramped (Bungalow) vs sprawling (Ranch)
- **When adding features**: Consider how each layout affects the feature differently

**3. Idle Game Mechanics**
- Resources accumulate passively in `_process(delta)` (ResourceManager)
- Offline progress calculated on load (SaveSystem)
- Auto-save every 60 seconds prevents progress loss
- **Formula**: `offline_resources = generation_rate * elapsed_seconds (max 24 hours)`

**4. Technology Unlocks**
- Technologies are **enabling** not **directive**
- Unlocking "Bronze Tools" → creatures automatically use better tools
- Unlocking "Agriculture" → creatures build farms when needed
- **Never force creature behavior** - tech enables new possibilities, creatures decide when to use them

## Code Style and Conventions

### GDScript Style
- Use single `#` for comments (not `##`) - Godot 4.5 prefers this
- Type hints required: `func foo(bar: String) -> void:`
- Signal naming: `snake_case` (e.g., `creature_spawned`)
- Node references: `@onready var camera = $Camera2D`

### Common Pitfalls

**1. Typed Arrays and .duplicate() (CRITICAL FOR GODOT 4.5)**
```gdscript
# THIS WILL CAUSE TYPE ERROR IN GODOT 4.5:
var my_array: Array[String] = []
# Later in load function:
my_array = data["key"].duplicate()  # ERROR: duplicate() returns untyped Array

# CORRECT PATTERN - Use clear and iterate:
var my_array: Array[String] = []
# Later in load function:
if data.has("key"):
	my_array.clear()
	for item in data["key"]:
		my_array.append(item)
```
**Why this happens**: In Godot 4.5, `.duplicate()` returns an untyped `Array`, not `Array[T]`. The strict type system won't allow assigning untyped to typed arrays. This affects all typed arrays in save/load functions.

**Where we fixed this**:
- `game_manager.gd:185-191` - `unlocked_technologies` and `unlocked_achievements`
- `society_manager.gd:217-219` - `cultural_traits`

**2. Documentation Comments**
```gdscript
# Good
# This function does X

# Bad (parse errors in Godot 4.5)
## This function does X
```

**3. Preload vs Load**
```gdscript
# Bad - fails if file doesn't exist
var scene = preload("res://scenes/foo.tscn")

# Good - conditional loading
if ResourceLoader.exists("res://scenes/foo.tscn"):
	var scene = load("res://scenes/foo.tscn")
```

**4. Match Statements Must Be Exhaustive**
```gdscript
# Bad - missing case causes parse error
match stage:
	SocietyStage.TRIBAL:
		do_something()

# Good - all cases covered
match stage:
	SocietyStage.SCATTERED:
		pass
	SocietyStage.TRIBAL:
		do_something()
```

**5. UI for Small Viewport**
- Viewport is 640x360 (pixel art style)
- Use absolute positioning or test UI scales properly
- Buttons should be minimum 40px height
- Margins should be 20px for readability

## Adding New Features

### Adding a New Resource Type
1. Add to `ResourceManager.resources` dictionary
2. Add base generation rate in `base_generation_rates`
3. Add cap in `resource_caps`
4. Add multiplier in `generation_multipliers`
5. Update `get_save_data()` and `load_save_data()`
6. Add EventBus signal if needed (e.g., `resource_type_depleted`)

### Adding a New Society Stage
1. Add enum value to `SocietyManager.SocietyStage`
2. Add name in `STAGE_NAMES`
3. Add population threshold in `STAGE_THRESHOLDS`
4. Add description in `_get_stage_description()`
5. Add stage benefits in `_apply_stage_benefits()`

### Adding a New House Type
1. Add enum value to `LayoutGenerator.HouseType`
2. Add name in `HOUSE_NAMES`
3. Add description in `HOUSE_DESCRIPTIONS`
4. Create generation function (e.g., `_generate_mansion_layout()`)
5. Add match case in `generate_layout()`
6. Update house selection list in `house_selection_simple.gd`

## Project Status

**Phase 1: Foundation** ✅ COMPLETE
- All autoload systems working
- 6 house layouts generating correctly
- House selection → gameplay flow working
- Save/load with offline progress

**Phase 2: Creature System** 🚧 IN PROGRESS
- Need: Creature AI with pathfinding
- Need: Needs system (hunger, safety, comfort)
- Need: Autonomous behavior state machine

**Phase 3-5: Core Gameplay** 📋 PLANNED
- Building placement system
- Design Terminal UI
- Technology tree
- Weather and environmental systems

See `TODO.md` for complete development roadmap.

## Important Files to Reference

- `README.md` - Game concept, architecture overview, current status
- `TODO.md` - Complete development roadmap with detailed tasks
- `docs/design_doc.md` - Full game design document with gameplay mechanics
- `project.godot` - Godot project config (viewport size, autoloads, physics)

## Debugging Tips

**Check autoload initialization:**
All autoloads print initialization messages. Look for these in Godot Output:
```
[EventBus] Event bus initialized
[GameManager] Game manager initialized
[ResourceManager] Resource manager initialized
...
```

**Verify scene loading:**
Main.gd logs scene transitions:
```
[Main] Game starting
[Main] Showing house selection
[Main] House selected: Ranch House
[Main] Starting game with house type: Ranch House
```

**Check layout generation:**
LayoutGenerator logs generation details:
```
[LayoutGenerator] Generating layout for: Ranch House
[LayoutGenerator] Layout generated with 6 vents and 2 beams
```

**Creature spawning:**
Crawlspace scene logs creature creation:
```
[Crawlspace] Creature scene not found, creating placeholder
```

## Resource Locations

- Save files: `user://` (OS-specific, see Godot docs)
  - macOS: `~/Library/Application Support/Godot/app_userdata/Crawlspace/`
  - Windows: `%APPDATA%\Godot\app_userdata\Crawlspace\`
- Godot cache: `.godot/` (gitignored)
- Assets: `assets/` (currently placeholders - pixel art TBD)

## Godot Version

**Current**: Godot 4.5.1 (IMPORTANT: Code written specifically for 4.5)
**Required**: Godot 4.5+

⚠️ **Critical**: This project uses Godot 4.5.1 which has stricter type checking than 4.3/4.4. Key differences:
- Typed arrays (`Array[String]`) are strictly enforced
- `.duplicate()` returns untyped `Array`, not `Array[T]`
- Must use clear-and-iterate pattern for typed array loading (see Common Pitfalls #1)

If syntax or type errors occur, verify Godot version: `godot --version`
