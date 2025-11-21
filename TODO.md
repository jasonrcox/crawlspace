# Crawlspace - Development TODO

**Last Updated**: 2024
**Project Status**: Foundation Complete, Core Systems In Development

---

## ✅ Phase 1: Foundation - COMPLETE

### Project Setup
- [x] Initialize Godot 4.3 project
- [x] Configure pixel-art rendering settings (320x180, nearest neighbor, integer scaling)
- [x] Set up mobile compatibility settings
- [x] Create complete folder structure
- [x] Create project icon
- [x] Configure physics and input settings

### Autoload Singletons
- [x] EventBus - Global signal system
- [x] GameManager - Game state and progression
- [x] ResourceManager - Resource generation and management (5 resource types)
- [x] SaveSystem - Save/load with offline progress calculation
- [x] SocietyManager - Population and civilization stages
- [x] LayoutGenerator - Procedural crawlspace generation

### Layout Generation System
- [x] Implement 6 house types:
  - [x] Ranch House (wide, many vents)
  - [x] Two-Story House (compact, beam maze)
  - [x] Split-Level House (multi-elevation)
  - [x] Victorian House (irregular shape)
  - [x] Colonial House (long rectangular)
  - [x] Bungalow (small and cramped)
- [x] Generate walls, beams, vents, pipes
- [x] Calculate elevation zones
- [x] Define spawn zones and probe position
- [x] Implement strategic implications per layout

### Basic Scenes
- [x] Main scene with game flow controller
- [x] House selection screen
- [x] Crawlspace gameplay scene
- [x] Camera setup with zoom and pan controls

### Environment Rendering
- [x] Render layout boundaries
- [x] Render walls (Line2D)
- [x] Render support beams with collision
- [x] Render vents with PointLight2D
- [x] Render pipes (placeholder markers)
- [x] Render foundation cracks
- [x] Spawn glowing probe at designated position
- [x] Apply CanvasModulate for dark atmosphere

### Documentation
- [x] Create README.md
- [x] Create comprehensive design document
- [x] Document architecture and systems
- [x] Create TODO.md (this file)

---

## 🚧 Phase 2: Creature System - IN PROGRESS

### Creature Base
- [ ] Create creature base scene (`scenes/creatures/creature_base.tscn`)
- [ ] Create creature script with CharacterBody2D
- [ ] Add sprite (8x8 placeholder circle)
- [ ] Add CollisionShape2D for physics
- [ ] Implement basic movement and velocity
- [ ] Add health and age tracking
- [ ] Implement death conditions

### Needs System
- [ ] Implement need values (hunger, safety, comfort, social)
- [ ] Create need decay over time
- [ ] Add need satisfaction methods
- [ ] Visual indicators for needs (optional debug)

### Creature AI - State Machine
- [ ] Implement state enum (Idle, Seeking, Gathering, Building, Fleeing, Resting, Socializing)
- [ ] Create state transition logic based on needs
- [ ] Implement decision-making system
- [ ] Add priority evaluation for actions

### Pathfinding
- [ ] Implement A* pathfinding algorithm
- [ ] Use LayoutGenerator data for obstacles (beams, walls)
- [ ] Add navigation mesh generation
- [ ] Handle elevation changes (Split-Level)
- [ ] Optimize pathfinding for multiple creatures

### Behavior Implementation
- [ ] **Idle**: Random wandering, exploration
- [ ] **Seeking**: Move toward resource/food/shelter
- [ ] **Gathering**: Collect resources autonomously
- [ ] **Building**: Participate in construction
- [ ] **Fleeing**: Escape from threats (storms, pests)
- [ ] **Resting**: Recover near probe or shelter
- [ ] **Socializing**: Group behaviors, clustering

### Population Management
- [ ] Implement spawning system (near probe)
- [ ] Add birth mechanic (population growth)
- [ ] Handle death and cleanup
- [ ] Track population statistics
- [ ] Enforce population caps based on buildings
- [ ] Connect to SocietyManager

### Creature Visuals
- [ ] Create placeholder sprite variations
- [ ] Add simple walk animation
- [ ] Add idle animation
- [ ] Add death animation/effect
- [ ] Add evolution visual changes (when society progresses)

---

## 📋 Phase 3: Building & Construction System

### Building Base
- [ ] Create building base scene template
- [ ] Building types:
  - [ ] Shelter (basic housing, +5 population cap)
  - [ ] Housing (improved, +10 population cap)
  - [ ] Apartment (advanced, +20 population cap)
  - [ ] Workshop (production boost)
  - [ ] Farm (food generation)
  - [ ] Storage (increase resource caps)
  - [ ] Monument (cultural, morale boost)
  - [ ] Laboratory (research boost)
- [ ] Add construction progress tracking
- [ ] Implement building completion
- [ ] Handle building destruction

### Autonomous Placement AI
- [ ] Evaluate valid building locations:
  - [ ] Check clearance from obstacles
  - [ ] Verify accessibility (pathfinding)
  - [ ] Consider proximity to resources (water, light, probe)
  - [ ] Avoid blocking creature paths
- [ ] Implement priority system for building needs:
  - [ ] Shelter when population high
  - [ ] Storage when resources capped
  - [ ] Farms when food scarce
  - [ ] Workshops when materials needed
- [ ] Handle multiple construction projects
- [ ] Creature collaboration on construction

### Building Effects
- [ ] Apply population cap increases
- [ ] Apply resource generation multipliers
- [ ] Apply resource cap increases
- [ ] Handle building upgrades (tech unlocks)
- [ ] Implement building attachment to beams (cramped layouts)
- [ ] Elevated platforms in flood zones

### Visual Representation
- [ ] Placeholder building sprites (16x16 rectangles)
- [ ] Construction progress visual (partial sprite)
- [ ] Completion particle effect
- [ ] Building shadows/lighting interaction

---

## 🖥️ Phase 4: Design Terminal UI

### Terminal Structure
- [ ] Create terminal overlay scene (CanvasLayer)
- [ ] Implement terminal open/close toggle (Tab key)
- [ ] Add retro CRT shader effect
- [ ] Add scanline shader
- [ ] Create terminal frame/border sprite
- [ ] Add boot sequence animation

### Tab System
- [ ] Implement TabContainer for multiple screens
- [ ] Create tab buttons with retro styling

### Overview Tab
- [ ] Display current society stage
- [ ] Show population count
- [ ] Show resource counters with generation rates
- [ ] Recent events log
- [ ] Layout minimap with civilization spread

### Layout Map Tab
- [ ] Full top-down view of crawlspace
- [ ] Show all walls, beams, vents
- [ ] Highlight creature locations
- [ ] Highlight building locations
- [ ] Color-coded elevation zones (Split-Level)
- [ ] Resource spawn markers

### Blueprint Designer Tab
- [ ] Create canvas for designing buildings
- [ ] Component library (walls, roofs, doors, windows, decorations)
- [ ] Drag-and-drop system
- [ ] Earth-tone color palette selector
- [ ] Size templates (small, medium, large)
- [ ] Preview rendering
- [ ] Save/load blueprint designs
- [ ] Apply design to building type

### Technology Tree Tab
- [ ] Create tech tree visualization (GraphEdit or custom)
- [ ] Display tech nodes with lock/unlock states
- [ ] Show tech costs (research points)
- [ ] Show tech descriptions and effects
- [ ] Implement unlock button (spend research)
- [ ] Show dependencies between techs
- [ ] Highlight layout-specific tech branches

### Tools & Culture Tab
- [ ] Design tool/equipment appearance
- [ ] Design monuments and cultural symbols
- [ ] Preview how designs look on creatures
- [ ] Save cultural design library

### Archives Tab
- [ ] Gallery of all blueprint designs
- [ ] Civilization timeline with milestones
- [ ] Achievement display
- [ ] Screenshots/snapshots of civilization

### Statistics Tab
- [ ] Population growth graph
- [ ] Resource production history charts
- [ ] Territory expansion map over time
- [ ] Efficiency metrics
- [ ] Buildings constructed count
- [ ] Technologies unlocked list

### Terminal Polish
- [ ] Probe AI commentary messages
- [ ] "Detecting optimal settlement patterns..."
- [ ] "Warning: Flooding detected in sector 3..."
- [ ] Typing text animation
- [ ] Button hover/click effects
- [ ] Notification system (EventBus integration)
- [ ] Mobile touch optimization

---

## 🔬 Phase 5: Technology System

### Technology Data Structure
- [ ] Create technology resource class
- [ ] Define tech properties:
  - [ ] ID, name, description
  - [ ] Research cost
  - [ ] Dependencies (prerequisite techs)
  - [ ] Effects (resource multipliers, unlocks)
  - [ ] Layout-specific flags
- [ ] Create tech data files in `data/resources/technology_data/`

### Universal Technologies
- [ ] **Tools Tier**:
  - [ ] Stone Tools (gathering +20%)
  - [ ] Bronze Tools (gathering +50%)
  - [ ] Iron Tools (gathering +100%)
  - [ ] Machines (automation)
- [ ] **Architecture Tier**:
  - [ ] Basic Architecture (shelters)
  - [ ] Intermediate Architecture (housing, workshops)
  - [ ] Advanced Architecture (apartments, multi-story)
  - [ ] Monumental Architecture (monuments)
- [ ] **Agriculture Tier**:
  - [ ] Foraging (basic food)
  - [ ] Farming (farm buildings, food generation)
  - [ ] Hydroponics (advanced food, light-independent)
- [ ] **Social Tier**:
  - [ ] Cooperation (work together)
  - [ ] Organization (faster coordination)
  - [ ] Government (town hall, districts)
  - [ ] Culture (monuments, celebrations)
- [ ] **Energy Tier**:
  - [ ] Fire (warmth, cooking)
  - [ ] Electricity (probe connection)
  - [ ] Advanced Power (energy generation boost)

### Layout-Specific Technologies
- [ ] **Cramped Space Branch** (Bungalow, Victorian):
  - [ ] Vertical Building (multi-story structures)
  - [ ] Compact Design (smaller efficient buildings)
  - [ ] Beam Integration (attach to support beams)
- [ ] **Sprawling Space Branch** (Ranch, Colonial):
  - [ ] Road Networks (movement speed boost)
  - [ ] Communication Systems (coordinate distant groups)
  - [ ] Resource Distribution (transport efficiency)
- [ ] **Elevation Management Branch** (Split-Level):
  - [ ] Advanced Drainage (redirect water)
  - [ ] Levee Construction (flood protection)
  - [ ] Elevation Bridges (connect different heights)
  - [ ] Water Storage (convert flooding to resource)
- [ ] **Low Light Branch** (Two-Story, Bungalow):
  - [ ] Artificial Lighting (PointLight2D from buildings)
  - [ ] Bioluminescence (creatures glow)
  - [ ] Light Reflection (redirect vent light)

### Technology System Implementation
- [ ] Tech unlock logic in GameManager
- [ ] Cost checking and spending research points
- [ ] Apply tech effects to ResourceManager
- [ ] Apply tech effects to creatures (new behaviors)
- [ ] Apply tech effects to buildings (new types)
- [ ] Save/load unlocked technologies
- [ ] Notification when tech is unlocked

### Tech-Driven Behaviors
- [ ] Creatures auto-equip unlocked tools
- [ ] Creatures use new building types when available
- [ ] Creatures adapt strategies based on tech (drainage, lighting)
- [ ] Building upgrades when architecture tech unlocked

---

## 🌦️ Phase 6: Weather & Environmental Systems

### Day/Night Cycle
- [ ] Implement time-of-day tracking
- [ ] Modulate vent light intensity by time
- [ ] Affect creature schedules (more active in light)
- [ ] Influence food production (photosynthesis)
- [ ] Vent orientation matters (south-facing = more light)
- [ ] Visual transition between day/night

### Rain System
- [ ] Create GPUParticles2D for rain effect
- [ ] Rain enters through vents
- [ ] Water accumulation based on layout:
  - [ ] Follow elevation and drainage patterns
  - [ ] Pool in low areas (Split-Level)
  - [ ] Flow through cracks
- [ ] Create water puddle/pool visuals
- [ ] Generate water resources from rain
- [ ] Flooding mechanic (too much water)
- [ ] Creature response: seek shelter, avoid water

### Wind System
- [ ] Create GPUParticles2D for wind/dust
- [ ] Wind channeled by walls and beams
- [ ] Wind tunnels in long layouts (Colonial)
- [ ] Carry debris/materials
- [ ] Affect weak structures (damage)
- [ ] Visual wind direction indicator
- [ ] Creature response: brace, move to shelter

### Temperature System
- [ ] Track temperature zones
- [ ] Probe area stays warm (PointLight2D warmth visual)
- [ ] Pipes provide warmth
- [ ] Far edges get cold
- [ ] Seasonal changes
- [ ] Creature response: cluster for warmth, prefer warm areas

### Dynamic Weather Events
- [ ] **Major Storm**:
  - [ ] Heavy rain, strong wind
  - [ ] Severe flooding risk
  - [ ] Structure damage
  - [ ] Creature emergency behavior
  - [ ] Layout-dependent severity
- [ ] **Pipe Burst**:
  - [ ] Sudden water source
  - [ ] New resource opportunity
  - [ ] Potential flooding
- [ ] **Foundation Crack Expansion**:
  - [ ] New leak point
  - [ ] Exploration opportunity
  - [ ] Expansion area
- [ ] **Human Activity**:
  - [ ] Vibrations (screen shake)
  - [ ] Temporary disruption
  - [ ] Creatures hide/investigate
  - [ ] Possible repairs blocking areas
- [ ] **Pest Invasion**:
  - [ ] Spiders/centipedes enter
  - [ ] Threat to creatures
  - [ ] Creatures defend or flee
  - [ ] Society response based on stage

### Environmental Audio
- [ ] Ambient dripping sounds
- [ ] Rain sound effects
- [ ] Wind whoosh
- [ ] Thunder rumble (storms)
- [ ] Creature background chatter
- [ ] Positional audio (AudioStreamPlayer2D)

---

## 🎨 Phase 7: Visual Polish & Effects

### Particle Effects
- [ ] Resource collection sparkles
- [ ] Construction progress particles
- [ ] Building completion burst
- [ ] Evolution glow/burst (society stage up)
- [ ] Death fade-out
- [ ] Technology unlock flash
- [ ] Celebration fireworks (milestones)

### Animations
- [ ] Creature walk cycle
- [ ] Creature idle bounce
- [ ] Building construction progress (growing)
- [ ] Probe pulsing glow
- [ ] Vent light flickering
- [ ] Water ripples in puddles

### Screen Effects
- [ ] Screen shake for storms
- [ ] Screen shake for major events
- [ ] Flash for technology unlock
- [ ] Transition effects (scene changes)
- [ ] Slow-motion for dramatic moments (optional)

### Lighting Polish
- [ ] Dynamic shadows from beams
- [ ] Light occlusion (LightOccluder2D)
- [ ] God rays from vents (custom shader)
- [ ] Bioluminescence glow (advanced tech)
- [ ] Fire light from buildings
- [ ] Probe pulsing energy effect

### UI Polish
- [ ] Smooth counter animations (resource numbers)
- [ ] Progress bars with easing
- [ ] Button hover animations
- [ ] Tooltip system with delays
- [ ] Notification popups with slide-in
- [ ] Achievement popup celebration
- [ ] Welcome back summary with formatting

### Shader Effects
- [ ] CRT scanline shader for terminal
- [ ] Pixel-perfect shader (if needed)
- [ ] Light shaft "god ray" shader
- [ ] Water surface shimmer shader
- [ ] Glow/bloom effect for probe and lights

---

## 🔊 Phase 8: Audio Implementation

### Music
- [ ] Ambient crawlspace theme (looping)
- [ ] Terminal UI theme (when terminal open)
- [ ] Dynamic music layers based on society stage
- [ ] Tension music for storms/events
- [ ] Victory/celebration music for milestones
- [ ] Peaceful music for night cycle

### Sound Effects - Creatures
- [ ] Spawn/birth sound
- [ ] Movement sounds (tiny steps)
- [ ] Gathering resource sound
- [ ] Death sound
- [ ] Social chatter (ambient)
- [ ] Panic sounds (fleeing)

### Sound Effects - Environment
- [ ] Rain dripping
- [ ] Wind howling
- [ ] Thunder crash
- [ ] Water pooling/flowing
- [ ] Structure creaking
- [ ] Human activity vibration

### Sound Effects - Construction
- [ ] Hammering
- [ ] Building assembly
- [ ] Completion chime
- [ ] Structure collapse/damage

### Sound Effects - UI
- [ ] Button click
- [ ] Tab switch
- [ ] Technology unlock chime
- [ ] Notification pop
- [ ] Terminal boot beeps
- [ ] Resource counter tick
- [ ] Achievement fanfare

### Audio Management
- [ ] Volume controls (master, music, sfx)
- [ ] Audio settings in terminal
- [ ] Mute option
- [ ] Audio ducking (lower music when effects play)
- [ ] Positional 2D audio for environment

---

## 📱 Phase 9: Mobile Optimization

### Touch Controls
- [ ] Implement touch input detection
- [ ] Pinch to zoom gesture
- [ ] Drag to pan camera
- [ ] Tap to inspect creature/building
- [ ] Double-tap to center on probe
- [ ] Swipe gestures for terminal tabs
- [ ] Virtual buttons for terminal toggle

### UI Adaptation
- [ ] Scale UI for different screen sizes
- [ ] Portrait mode layout
- [ ] Landscape mode layout
- [ ] Larger touch targets (min 44x44 points)
- [ ] Simplified terminal for mobile
- [ ] On-screen tutorial hints

### Performance Optimization
- [ ] Object pooling for creatures
- [ ] Particle system culling
- [ ] Off-screen creature deactivation
- [ ] Efficient pathfinding (limit updates)
- [ ] Layout chunk loading (large layouts)
- [ ] Reduce draw calls
- [ ] LOD system (if needed)
- [ ] Target 60 FPS on mid-range devices

### Platform-Specific
- [ ] Test on iOS devices
- [ ] Test on Android devices
- [ ] Handle safe areas (notches)
- [ ] Battery optimization
- [ ] Cloud save sync (optional)
- [ ] Platform-specific input (back button on Android)

---

## 🎯 Phase 10: Balancing & Gameplay Tuning

### Resource Generation Rates
- [ ] Balance base generation rates
- [ ] Tune multipliers from tech/buildings
- [ ] Test resource caps feel right
- [ ] Ensure no resource becomes bottleneck too early
- [ ] Balance offline vs active generation

### Population Growth
- [ ] Tune birth rate
- [ ] Balance death rate (age, starvation)
- [ ] Ensure population cap progression feels good
- [ ] Test population density per layout

### Society Stage Progression
- [ ] Tune population thresholds for stages
- [ ] Ensure stage transitions feel earned
- [ ] Balance time to reach each stage
- [ ] Test pacing across different layouts

### Technology Costs
- [ ] Balance research point costs
- [ ] Ensure tech tree progression is smooth
- [ ] Test that layout-specific techs unlock at right time
- [ ] Verify dependencies make sense

### Building Costs
- [ ] Balance material and energy costs
- [ ] Tune construction time
- [ ] Ensure buildings feel impactful
- [ ] Test building variety and usage

### Weather Frequency
- [ ] Balance storm frequency
- [ ] Tune event severity
- [ ] Ensure events create challenge, not frustration
- [ ] Test layout-specific event impact

### Difficulty Curve
- [ ] Test each house type difficulty
- [ ] Ensure Bungalow is challenging but fair
- [ ] Ensure Ranch is accessible for new players
- [ ] Balance replayability incentive

### Prestige Bonuses
- [ ] Tune prestige bonus values
- [ ] Ensure prestige feels rewarding
- [ ] Balance starting resources after prestige
- [ ] Test multiple prestige loops

---

## 🐛 Phase 11: Bug Fixing & Testing

### Core Systems Testing
- [ ] Test save/load in all scenarios
- [ ] Verify offline progress calculation accuracy
- [ ] Test prestige doesn't break systems
- [ ] Test all autoload singletons communicate correctly
- [ ] Verify EventBus signals work as expected

### Gameplay Testing
- [ ] Test all 6 house layouts thoroughly
- [ ] Verify creature AI makes sensible decisions
- [ ] Test building placement in all layouts
- [ ] Verify pathfinding works around obstacles
- [ ] Test elevation handling (Split-Level)

### UI Testing
- [ ] Test terminal on different resolutions
- [ ] Verify all buttons work
- [ ] Test tab switching
- [ ] Verify blueprint designer functionality
- [ ] Test tech tree interactions

### Edge Cases
- [ ] Test with 0 population (extinction)
- [ ] Test with max population
- [ ] Test with 0 resources
- [ ] Test with capped resources
- [ ] Test saving during events
- [ ] Test loading old save versions

### Performance Testing
- [ ] Profile frame rate with 200+ creatures
- [ ] Test memory usage over time
- [ ] Check for memory leaks
- [ ] Test on low-end hardware
- [ ] Test on mobile devices

### Platform Testing
- [ ] Windows build testing
- [ ] macOS build testing
- [ ] Linux build testing
- [ ] iOS build testing
- [ ] Android build testing

---

## 📦 Phase 12: Release Preparation

### Asset Creation
- [ ] Create all final pixel art sprites
- [ ] Create UI graphics
- [ ] Create icons and logos
- [ ] Create promotional artwork
- [ ] Create screenshots
- [ ] Create trailer footage

### Documentation
- [ ] Write player-facing manual/guide
- [ ] Create tutorial/onboarding
- [ ] Write changelog
- [ ] Create credits screen
- [ ] Write press kit

### Marketing Materials
- [ ] Create game trailer
- [ ] Write game description
- [ ] Create store page graphics
- [ ] Social media assets
- [ ] Press release

### Build Pipeline
- [ ] Set up export presets for all platforms
- [ ] Test exported builds
- [ ] Implement version numbering
- [ ] Set up update/patch system
- [ ] Prepare for distribution

### Final Polish
- [ ] Accessibility pass
- [ ] Localization preparation (if planned)
- [ ] Final balance pass
- [ ] Final bug fixing
- [ ] Performance optimization pass
- [ ] Legal review (credits, licenses)

---

## 🚀 Future Enhancements (Post-Launch)

### Content Additions
- [ ] More house types (Mansion, Cottage, Trailer, Castle)
- [ ] Seasonal events (Halloween, Winter)
- [ ] New creature types/stages
- [ ] Additional tech trees (Magic? Alien?)
- [ ] More building types
- [ ] Challenge modes (speed run, survival)

### Features
- [ ] Design sharing (export/import blueprints)
- [ ] Achievements system
- [ ] Statistics tracking (global)
- [ ] Leaderboards (fastest to transcendent)
- [ ] Mod support
- [ ] Level editor

### Narrative Expansion
- [ ] Probe backstory missions
- [ ] Multiple endings
- [ ] Discovery by humans storyline
- [ ] Communication with original alien civilization
- [ ] Escape/transcendence sequence

### Platform Expansion
- [ ] Steam release
- [ ] Itch.io release
- [ ] Mobile app stores
- [ ] Console ports (Switch?)
- [ ] Web version (HTML5 export)

---

## 📝 Notes & Decisions

### Technical Decisions Made
- **Engine**: Godot 4.3 (modern, good 2D support, mobile-friendly)
- **Resolution**: 320x180 base (authentic pixel art feel)
- **Save Format**: JSON (human-readable, debug-friendly)
- **Architecture**: Autoload singletons for game systems (clean separation)
- **Creature AI**: State machine with needs-driven decisions

### Design Decisions Made
- **Player Role**: Observer/designer, not micromanager
- **Creature Autonomy**: Full autonomy, player can't control directly
- **Layout Choice**: Affects entire playthrough, creates replayability
- **Idle Focus**: Game progresses offline, respects player's time
- **Prestige System**: Enables multiple playthroughs with progression

### Open Questions
- [ ] How many creature sprites needed? (placeholder vs. detailed)
- [ ] Should there be a "god mode" debug option?
- [ ] Steam achievements or in-game only?
- [ ] Multiplayer or shared world? (probably not, but consider)
- [ ] DLC plans? Expansion packs?

### Known Limitations
- Offline progress capped at 24 hours (prevent exploits)
- Maximum population ~500 (performance considerations)
- Layout is fixed once chosen (can't change mid-game)
- Creatures don't have individual names/personalities (might add later)

---

## 🎯 Current Priority

**PHASE 2: CREATURE SYSTEM**
Focus on implementing autonomous creature AI with pathfinding and needs-driven behavior. This is the core of the gameplay experience.

**Next 3 Tasks**:
1. Create creature base scene and script
2. Implement needs system (hunger, safety, comfort)
3. Implement basic pathfinding using LayoutGenerator data

---

**Last Updated**: 2024
**Estimated Completion**: Phase 2-5 (Core gameplay) ~4-6 weeks | Full Release ~3-4 months

*Track progress by checking off completed items with [x]*
