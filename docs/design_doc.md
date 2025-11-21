# Crawlspace - Game Design Document

## Executive Summary

**Genre**: Idle Simulation / Civilization Builder
**Platform**: Desktop (Windows, Mac, Linux) and Mobile (iOS, Android)
**Art Style**: Top-down pixel art with dark atmospheric aesthetic
**Core Loop**: Observe autonomous creatures → Design aesthetics → Unlock technologies → Watch civilization evolve

## Story & Setting

### Backstory
Millennia ago, an artificial intelligence probe from a panspermia seeding mission crash-landed on Earth and entered dormancy. Fast forward to modern times: a house is being constructed, and a squirrel seeking refuge in the crawlspace accidentally reactivates the probe's germination protocols.

The probe's sensors detect a dark, damp crawlspace environment and begin the process of creating life forms suitable for these conditions. As the ancient AI, the player operates the Life Design Terminal to guide this civilization's development.

### Environment: The Crawlspace
- **Dark & Damp**: Limited light from vents creates atmosphere
- **Warm Earth Tones**: Browns, grays, muted greens
- **Dynamic**: Rain leaks in, wind carries debris, temperature shifts
- **Constrained**: Beams, walls, pipes create obstacles and opportunities
- **Living Space**: Above, human activity creates vibrations and changes

## Core Gameplay

### Player Actions

#### 1. Design Terminal (Primary Interface)
The player's main interaction is through a retro AI terminal interface:

- **Blueprint Designer**: Create visual appearance of buildings
  - Pre-made architectural components (walls, roofs, doors)
  - Color palette selector (earth tones)
  - Size templates (creatures choose appropriate size)
  - Save/load custom designs

- **Technology Research**: Unlock new capabilities
  - Spend research points (idle-accumulated resource)
  - Tech tree with layout-adaptive branches
  - Creatures autonomously apply unlocked tech

- **Observation Tools**:
  - Layout map showing civilization spread
  - Population statistics and trends
  - Resource flow visualization
  - Society stage progress

- **Archives**: Gallery of all designs and milestones

#### 2. House Selection (Game Start)
Choose the house architecture, which defines the crawlspace challenge:

- Each layout has unique strategic implications
- Affects available space, light distribution, water flow
- Replayability through different layouts
- Difficulty varies by layout complexity

### Autonomous Creature Behavior

Creatures are fully autonomous agents with needs-driven AI:

#### Needs System
- **Hunger**: Seek food, motivates gathering/farming
- **Safety**: Avoid threats, seek shelter during storms
- **Comfort**: Prefer warm areas near probe/pipes
- **Social**: Naturally form groups and communities

#### Decision Making
Creatures evaluate their situation and make choices:
- When hungry → gather food or move to farm
- When threatened → hide or flee to safe zones
- When idle → explore, socialize, or build
- When resources available → construct needed buildings

#### Building Behavior
- Assess community needs (shelter, storage, workshops)
- Find optimal placement (accessibility, resources, safety)
- Gather required materials
- Collaborate on construction
- Upgrade buildings when tech allows

### Resource System

#### Resource Types
1. **Energy**: Radiates from probe, powers everything
2. **Water**: Forms from rain leaks, essential for life
3. **Materials**: Debris, wood, found objects from crawlspace
4. **Food**: Initially gathered, later farmed with agriculture tech
5. **Research**: Accumulated passively, spent on technology

#### Generation
- **Passive**: Idle accumulation based on population and tech
- **Active**: Creatures gather resources autonomously
- **Environmental**: Rain creates water, wind brings materials
- **Layout-Dependent**: Resources spawn in layout-appropriate locations

#### Consumption
- Creatures consume food and water to survive
- Building construction requires materials and energy
- Technology research consumes research points

### Society Progression

#### Stages (Autonomous Transitions)

1. **Scattered (0-10 population)**
   - Individuals exploring independently
   - Random wandering, basic survival
   - No permanent structures
   - Learning the environment

2. **Tribal (10-25 population)**
   - Form groups around probe
   - Share resources
   - Simple camps
   - Basic cooperation
   - **Unlocks**: Food sharing, primitive tools

3. **Settlement (25-50 population)**
   - Permanent structures
   - Role specialization (gatherers, builders)
   - Organized layout
   - **Unlocks**: Agriculture, workshops, storage

4. **Organized (50-100 population)**
   - Complex infrastructure
   - Government building
   - Multiple districts
   - Advanced cooperation
   - **Unlocks**: Advanced architecture, roads, communication

5. **Advanced (100-200 population)**
   - Technology-driven society
   - Environmental modification
   - Overcoming layout constraints
   - **Unlocks**: Artificial lighting, climate control, automation

6. **Transcendent (200+ population)**
   - Understanding probe origin
   - Connection with AI
   - Considering escape/expansion
   - **Unlocks**: Energy manipulation, probe interface, ???

### Technology Tree

#### Universal Technologies
Available to all layouts, core progression:

- **Tools**: Stone → Bronze → Iron → Machines
- **Architecture**: Basic → Intermediate → Advanced → Monumental
- **Agriculture**: Foraging → Farming → Hydroponics
- **Social**: Cooperation → Organization → Government → Culture
- **Energy**: Fire → Electricity → Probe Power

#### Layout-Specific Branches
Adapt to environmental challenges:

**Cramped Space (Bungalow, Victorian)**:
- Vertical Building (multi-story)
- Compact Design (space-efficient)
- Beam Integration (attach to existing structure)

**Sprawling Space (Ranch, Colonial)**:
- Road Networks (efficient movement)
- Communication Systems (coordinate distant groups)
- Resource Distribution (transport logistics)

**Elevation Management (Split-Level)**:
- Advanced Drainage (redirect water)
- Levee Construction (flood protection)
- Elevation Bridges (connect heights)
- Water Storage (turn flooding into resource)

**Low Light (Two-Story, Bungalow)**:
- Artificial Lighting (tap probe energy)
- Bioluminescence (creature-generated light)
- Light Reflection (redirect vent light)

### Environmental Systems

#### Day/Night Cycle
- Light shafts through vents change intensity
- Affects creature schedules and behavior
- Influences photosynthesis for food production
- South-facing vents get more daytime light

#### Weather Events

**Rain**:
- Water accumulation follows layout drainage
- Creates resource opportunities (water pools)
- Flood threats in low-lying areas
- Creatures respond: seek shelter, build drainage

**Wind**:
- Channeled by walls and beams
- Carries debris and materials
- Can damage weak structures
- Creates wind tunnel effects in long layouts

**Temperature**:
- Probe area stays warm
- Far edges get cold
- Creatures cluster for warmth
- Seasons affect resource generation

#### Dynamic Events

- **Major Storm**: Severe flooding, high winds, survival challenge
- **Pipe Burst**: New water source appears
- **Foundation Crack**: New area opens for expansion
- **Human Activity**: Vibrations, potential discovery threat
- **Pest Invasion**: Spiders enter through vents, creatures must respond

### Cultural Development

Civilization develops unique identity based on:

#### Layout Influence
- Cramped → Efficiency-focused, minimalist
- Sprawling → Exploratory, diverse
- Dark → Light-worshipping, mystical
- Wet → Water-engineering, drainage-focused

#### Player Choices
- Aesthetic designs become cultural style
- Monument designs reflect values
- Tech path creates cultural focus

#### Emergent Traits
- Celebrations during milestones
- Traditions based on events survived
- Architecture style evolution
- Social structure reflects layout geography

## Idle Mechanics

### Offline Progress

When player returns after being away:

1. Calculate elapsed time (max 24 hours)
2. Simulate creature actions:
   - Resource gathering
   - Construction progress
   - Population changes (births/deaths)
   - Weather events
3. Show "Welcome Back" summary:
   - Time elapsed
   - Resources gained
   - Buildings completed
   - Population changes
   - Major events

### Automation

Late-game technologies speed up creature decisions:
- Auto-construction (creatures build faster)
- Auto-research (passive research acceleration)
- Auto-management (more efficient resource use)
- Not micromanagement - creatures still decide autonomously

### Prestige System

**"New Simulation"** option allows restart with bonuses:

- Choose different house layout
- Keep permanent bonuses:
  - Resource generation multiplier
  - Research speed increase
  - Starting resources boost
- Unlock harder house types (Victorian, Split-Level)
- Challenge modes:
  - Extreme weather frequency
  - Limited resources
  - Tiny space (harder layouts)

## Art Direction

### Visual Style
- **Pixel Art**: 16x16 tile base, clean crisp pixels
- **Top-Down**: Bird's eye view of crawlspace
- **Dark Atmosphere**: Limited light creates mood
- **Warm Accent**: Probe's cyan glow, vent light shafts

### Color Palette

**Environment**:
- Deep browns: #2D1B00, #4A2F1A
- Dark grays: #1A1A1A, #333333
- Muted greens (moss): #3A5F3A, #2D4A2D

**Lighting**:
- Warm sunlight: #FFD580, #FFA94D
- Probe cyan glow: #4DD3FF, #80EAFF
- Darkness: #0D0D0D

**Creatures**:
- Stage 1: Translucent whites, light blues
- Stage 2+: Player-designed colors (earth tone palette)

**UI (Terminal)**:
- Phosphor green: #00FF9F
- Frame dark metal: #1C1C1C
- Accent amber: #FFB000

### Animation Style
- Simple, clean pixel animations
- Smooth tweens for movement
- Particle effects for "juice"
- Screen shake for impact

## Sound Design

### Music
- **Ambient Crawlspace**: Dripping water, distant hums
- **Terminal Theme**: Retro computer bleeps and bloops
- Dynamic layers based on society stage

### Sound Effects
- **Creatures**: Soft chirps, movement sounds
- **Environment**: Rain, wind, dripping, creaking
- **Construction**: Hammering, assembling
- **UI**: Satisfying clicks, whooshes, confirmations
- **Events**: Storm rumbles, evolution chimes

## UI/UX

### Terminal Aesthetic
- Retro AI computer interface
- CRT scanline shader effect
- Monochrome green phosphor (customizable)
- Boot sequence on game start
- Glitch effects during major events

### Mobile Considerations
- Touch-friendly button sizes
- Pinch to zoom
- Drag to pan
- Gesture shortcuts
- Portrait and landscape support
- Simplified UI for smaller screens

### Accessibility
- Colorblind modes
- Adjustable text size
- High contrast options
- Sound effect captions
- Slow mode option

## Monetization (Optional Future Consideration)

If released commercially:
- **Premium**: One-time purchase, no ads, all content
- **Mobile Free**: Ads with optional ad removal purchase
- **Cosmetic DLC**: Additional design component packs
- **Never**: Pay-to-win, energy systems, or gameplay-affecting purchases

## Success Metrics

### Player Engagement
- Session length (target: 10-30 minutes active, hours idle)
- Return rate (daily check-ins for idle games)
- Prestige rate (multiple playthroughs)

### Gameplay Balance
- Time to reach each society stage
- House type completion rates
- Technology unlock distribution
- Offline vs active play ratio

## Future Expansion Ideas

### Post-Launch Content
- More house types (Mansion, Cottage, Trailer)
- Seasonal events
- New creature types
- Additional tech trees
- Community design sharing
- Mod support

### Narrative Expansion
- Probe backstory missions
- Contact with original civilization
- Multiple endings based on choices
- Discovery by humans storyline

---

**Version**: 1.0
**Last Updated**: 2024
**Status**: In Development
