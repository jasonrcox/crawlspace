# Crawlspace - Autonomous Civilization Idle-Sim

An idle-sim game where you play as an ancient panspermia AI probe that germinated life in a house crawlspace. Watch autonomous creatures build a civilization while you design their technology and guide their evolution through the Life Design Terminal.

## Game Concept

Millennia ago, a panspermia artificial intelligence probe landed on Earth and went dormant. When a house was built over it, a squirrel accidentally reactivated the probe, which began germinating life suitable for the environment. The player operates the Life Design Terminal inside the probe, designing how structures and technologies look while autonomous creatures make their own decisions about survival and society building.

## Current Status

### ✅ Completed
- **Project Setup**: Godot 4.3 with mobile compatibility and pixel-art rendering
- **Autoload Systems**:
  - EventBus (global signals)
  - GameManager (game state, progression)
  - ResourceManager (idle resource generation)
  - SaveSystem (save/load with offline progress)
  - SocietyManager (population, civilization stages)
  - LayoutGenerator (procedural crawlspace creation)
- **Layout Generation**: 6 distinct house types with strategic gameplay implications
- **Basic Scene Structure**: Main menu, house selection, and crawlspace gameplay
- **Environment Rendering**: Walls, beams, vents (light sources), pipes, cracks

### 🚧 In Progress
- Creature AI with autonomous decision-making
- Building placement system
- Design Terminal UI

### 📋 To Do
- Technology tree with layout-adaptive paths
- Weather and environmental systems
- Resource spawning based on layout
- Society progression mechanics
- Polish and visual effects
- Mobile optimization

## House Types

Each house type creates a unique crawlspace layout with different strategic challenges:

1. **Ranch House**: Wide and shallow with many vents - easiest, excellent light distribution
2. **Two-Story House**: Compact square with maze-like support beams - moderate difficulty
3. **Split-Level House**: Multiple elevation zones with drainage challenges - complex water management
4. **Victorian House**: Irregular shape with cramped corners - unpredictable, exploration-focused
5. **Colonial House**: Long rectangular with central support beam - balanced and organized
6. **Bungalow**: Small and cramped with minimal vents - most challenging, space-constrained

## Architecture

### Autoload Singletons

- **EventBus**: Global event system for decoupled communication
- **GameManager**: Handles game state, progression, achievements, and prestige
- **ResourceManager**: Manages resources (Energy, Water, Materials, Food, Research) with idle generation
- **SaveSystem**: Saves/loads game state, calculates offline progress (capped at 24 hours)
- **SocietyManager**: Tracks population, society stages (Scattered → Transcendent), and cultural traits
- **LayoutGenerator**: Procedurally generates crawlspace layouts based on house type

### Key Systems

#### Resource System
- 5 resource types: Energy, Water, Materials, Food, Research
- Passive idle generation with multipliers
- Resource caps with building upgrades
- Consumption tracking

#### Society Progression
- 6 stages: Scattered (0-10) → Tribal (10-25) → Settlement (25-50) → Organized (50-100) → Advanced (100-200) → Transcendent (200+)
- Autonomous stage transitions based on population
- Stage-specific bonuses and capabilities

#### Layout System
- Procedurally generated based on house architecture
- Strategic elements: walls, beams (obstacles), vents (light), pipes, elevation, cracks
- Different layouts favor different strategies

## Project Structure

```
crawlspace/
├── project.godot           # Main project config
├── scenes/                 # All scene files
│   ├── main/              # Main menu and flow
│   ├── environment/       # Crawlspace scene
│   ├── creatures/         # Creature scenes
│   ├── ui/               # UI components
│   └── ...
├── scripts/               # GDScript files
│   ├── autoload/         # Global singletons
│   ├── systems/          # Game systems
│   ├── creatures/        # Creature logic
│   └── ui/               # UI controllers
├── assets/                # Game assets
│   ├── sprites/          # Pixel art sprites (placeholder)
│   ├── audio/            # Sound effects and music
│   └── shaders/          # Custom shaders
└── data/                  # Game data resources
    └── saves/            # Save files
```

## Controls (Development)

- **F5**: Quick Save
- **F9**: Quick Load
- **ESC**: Pause/Resume
- **Arrow Keys**: Pan Camera
- **Mouse Wheel**: Zoom Camera

## Technical Specs

- **Engine**: Godot 4.3
- **Resolution**: 320x180 base (scales to 1280x720)
- **Rendering**: Pixel-perfect with nearest neighbor filtering
- **Target Platform**: Desktop and Mobile (touch controls)
- **Art Style**: Top-down pixel art with dark atmospheric earth tones

## Development Phases

1. ✅ **Foundation** - Project setup, autoload systems, layout generation
2. ✅ **Environment** - Crawlspace rendering, camera, lighting
3. 🚧 **Creatures** - Autonomous AI, pathfinding, needs system
4. 📋 **Construction** - Building placement, structure types
5. 📋 **Terminal UI** - Design interface for blueprints and tech
6. 📋 **Progression** - Technology tree, society evolution
7. 📋 **Weather** - Dynamic environmental challenges
8. 📋 **Polish** - Effects, audio, optimization

## Design Philosophy

### Player Role
- **Observer**: Watch civilization emerge organically
- **Designer**: Create aesthetic blueprints for structures and tech
- **Guide**: Unlock technologies that enable new behaviors
- **Strategist**: Choose house layout that defines the challenge

### Creature Autonomy
- Creatures make all tactical decisions (where to build, what to gather, when to act)
- Driven by needs: hunger, safety, comfort, social connection
- Learn and adapt to environment through exploration
- Form societies naturally based on population and resources

### Idle Mechanics
- Continues offline (up to 24 hours)
- Resource generation based on population and tech
- Welcome back summary showing progress
- Auto-save every 60 seconds

## Next Steps

1. Create creature scene with basic AI
2. Implement pathfinding using layout data
3. Add resource spawning based on layout features
4. Create basic terminal UI overlay
5. Implement technology unlock system

---

*Generated with Claude Code*
