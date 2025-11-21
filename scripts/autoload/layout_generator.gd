extends Node
# Generates crawlspace layouts based on house architecture
# Creates strategic gameplay variations through geometry

# House type definitions
enum HouseType {
	RANCH,
	TWO_STORY,
	SPLIT_LEVEL,
	VICTORIAN,
	COLONIAL,
	BUNGALOW
}

const HOUSE_NAMES = {
	HouseType.RANCH: "Ranch House",
	HouseType.TWO_STORY: "Two-Story House",
	HouseType.SPLIT_LEVEL: "Split-Level House",
	HouseType.VICTORIAN: "Victorian House",
	HouseType.COLONIAL: "Colonial House",
	HouseType.BUNGALOW: "Bungalow"
}

const HOUSE_DESCRIPTIONS = {
	HouseType.RANCH: "Wide and shallow with many vents. Good light distribution.",
	HouseType.TWO_STORY: "Compact square with support beams. Moderate difficulty.",
	HouseType.SPLIT_LEVEL: "Multiple elevations with drainage challenges.",
	HouseType.VICTORIAN: "Irregular shape with cramped corners. Unpredictable.",
	HouseType.COLONIAL: "Long rectangular with central support. Balanced layout.",
	HouseType.BUNGALOW: "Small and cramped with minimal vents. Challenging."
}

# Current layout data
var current_house_type: HouseType = HouseType.RANCH
var layout_bounds: Rect2
var walls: Array[PackedVector2Array] = []  # Wall polylines
var beams: Array[Dictionary] = []  # {start: Vector2, end: Vector2}
var vents: Array[Dictionary] = []  # {position: Vector2, size: Vector2, orientation: String}
var pipes: Array[Dictionary] = []  # {position: Vector2, type: String}
var elevation_zones: Array[Dictionary] = []  # {rect: Rect2, height: float}
var cracks: Array[Vector2] = []  # Potential leak points
var probe_position: Vector2 = Vector2.ZERO
var spawn_zones: Array[Rect2] = []  # Safe areas for creature spawning

# Navigation data
var walkable_areas: Array[Rect2] = []
var obstacle_areas: Array[Rect2] = []

func _ready():
	print("[LayoutGenerator] Layout generator initialized")

# Generate layout based on house type
func generate_layout(house_type_name: String):
	print("[LayoutGenerator] Generating layout for: ", house_type_name)

	# Convert string to enum
	current_house_type = _get_house_type_from_name(house_type_name)

	# Clear previous layout
	_clear_layout()

	# Generate based on type
	match current_house_type:
		HouseType.RANCH:
			_generate_ranch_layout()
		HouseType.TWO_STORY:
			_generate_two_story_layout()
		HouseType.SPLIT_LEVEL:
			_generate_split_level_layout()
		HouseType.VICTORIAN:
			_generate_victorian_layout()
		HouseType.COLONIAL:
			_generate_colonial_layout()
		HouseType.BUNGALOW:
			_generate_bungalow_layout()

	print("[LayoutGenerator] Layout generated with ", vents.size(), " vents and ", beams.size(), " beams")

func _clear_layout():
	walls.clear()
	beams.clear()
	vents.clear()
	pipes.clear()
	elevation_zones.clear()
	cracks.clear()
	spawn_zones.clear()
	walkable_areas.clear()
	obstacle_areas.clear()

# RANCH LAYOUT: Wide and shallow, many vents, open spaces
func _generate_ranch_layout():
	# Large rectangular space: 60x30 tiles (960x480 pixels at 16px tiles)
	layout_bounds = Rect2(0, 0, 960, 480)

	# Outer walls
	walls.append(PackedVector2Array([
		Vector2(0, 0),
		Vector2(960, 0),
		Vector2(960, 480),
		Vector2(0, 480),
		Vector2(0, 0)
	]))

	# Support beams (fewer, well-spaced)
	beams.append({"start": Vector2(320, 0), "end": Vector2(320, 480)})
	beams.append({"start": Vector2(640, 0), "end": Vector2(640, 480)})

	# Many vents (6 vents for good light)
	vents.append({"position": Vector2(160, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(480, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(800, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(160, 480), "size": Vector2(64, 32), "orientation": "south"})
	vents.append({"position": Vector2(640, 480), "size": Vector2(64, 32), "orientation": "south"})
	vents.append({"position": Vector2(0, 240), "size": Vector2(32, 64), "orientation": "west"})

	# Pipes
	pipes.append({"position": Vector2(100, 100), "type": "water"})
	pipes.append({"position": Vector2(600, 300), "type": "electrical"})

	# Single elevation (flat)
	elevation_zones.append({"rect": layout_bounds, "height": 0.0})

	# Foundation cracks
	cracks.append(Vector2(200, 480))
	cracks.append(Vector2(700, 480))

	# Probe position (center)
	probe_position = Vector2(480, 240)

	# Spawn zones (open areas)
	spawn_zones.append(Rect2(100, 100, 200, 200))
	spawn_zones.append(Rect2(400, 150, 200, 200))
	spawn_zones.append(Rect2(700, 100, 200, 200))

# TWO-STORY LAYOUT: Compact square, support beam maze, fewer vents
func _generate_two_story_layout():
	# Compact square: 40x40 tiles (640x640 pixels)
	layout_bounds = Rect2(0, 0, 640, 640)

	# Outer walls
	walls.append(PackedVector2Array([
		Vector2(0, 0),
		Vector2(640, 0),
		Vector2(640, 640),
		Vector2(0, 640),
		Vector2(0, 0)
	]))

	# Many support beams (maze-like)
	beams.append({"start": Vector2(160, 0), "end": Vector2(160, 640)})
	beams.append({"start": Vector2(320, 0), "end": Vector2(320, 640)})
	beams.append({"start": Vector2(480, 0), "end": Vector2(480, 640)})
	beams.append({"start": Vector2(0, 320), "end": Vector2(640, 320)})

	# Fewer vents (3 vents)
	vents.append({"position": Vector2(240, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(640, 240), "size": Vector2(32, 64), "orientation": "east"})
	vents.append({"position": Vector2(400, 640), "size": Vector2(64, 32), "orientation": "south"})

	# Pipes
	pipes.append({"position": Vector2(80, 160), "type": "water"})
	pipes.append({"position": Vector2(400, 400), "type": "electrical"})

	# Single elevation
	elevation_zones.append({"rect": layout_bounds, "height": 0.0})

	# Cracks
	cracks.append(Vector2(100, 640))
	cracks.append(Vector2(540, 640))

	# Probe position
	probe_position = Vector2(320, 320)

	# Spawn zones (between beams)
	spawn_zones.append(Rect2(50, 50, 100, 250))
	spawn_zones.append(Rect2(350, 350, 250, 250))

# SPLIT-LEVEL LAYOUT: Multi-elevation zones, drainage challenges
func _generate_split_level_layout():
	# Medium rectangular: 50x35 tiles (800x560 pixels)
	layout_bounds = Rect2(0, 0, 800, 560)

	# Outer walls
	walls.append(PackedVector2Array([
		Vector2(0, 0),
		Vector2(800, 0),
		Vector2(800, 560),
		Vector2(0, 560),
		Vector2(0, 0)
	]))

	# Beams separating elevations
	beams.append({"start": Vector2(400, 0), "end": Vector2(400, 560)})
	beams.append({"start": Vector2(0, 280), "end": Vector2(400, 280)})

	# Vents (4 vents)
	vents.append({"position": Vector2(200, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(600, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(100, 560), "size": Vector2(64, 32), "orientation": "south"})
	vents.append({"position": Vector2(700, 560), "size": Vector2(64, 32), "orientation": "south"})

	# Pipes
	pipes.append({"position": Vector2(150, 150), "type": "water"})
	pipes.append({"position": Vector2(600, 400), "type": "water"})

	# Multiple elevations (key feature!)
	elevation_zones.append({"rect": Rect2(0, 0, 400, 280), "height": 30.0})     # High
	elevation_zones.append({"rect": Rect2(0, 280, 400, 280), "height": 0.0})    # Low
	elevation_zones.append({"rect": Rect2(400, 0, 400, 560), "height": 15.0})   # Medium

	# Many cracks (water flows here)
	cracks.append(Vector2(50, 560))
	cracks.append(Vector2(200, 560))
	cracks.append(Vector2(350, 560))

	# Probe position (medium elevation)
	probe_position = Vector2(600, 280)

	# Spawn zones
	spawn_zones.append(Rect2(50, 50, 300, 200))
	spawn_zones.append(Rect2(450, 50, 300, 450))

# VICTORIAN LAYOUT: Irregular shape, many corners, cramped
func _generate_victorian_layout():
	# Irregular shape: 45x40 tiles (720x640 pixels)
	layout_bounds = Rect2(0, 0, 720, 640)

	# Irregular outer walls with alcoves
	walls.append(PackedVector2Array([
		Vector2(0, 0),
		Vector2(500, 0),
		Vector2(500, 200),
		Vector2(720, 200),
		Vector2(720, 640),
		Vector2(400, 640),
		Vector2(400, 450),
		Vector2(0, 450),
		Vector2(0, 0)
	]))

	# Irregular beam placement
	beams.append({"start": Vector2(250, 0), "end": Vector2(250, 450)})
	beams.append({"start": Vector2(500, 200), "end": Vector2(500, 640)})
	beams.append({"start": Vector2(0, 225), "end": Vector2(400, 225)})

	# Vents (3 vents, irregularly placed)
	vents.append({"position": Vector2(150, 0), "size": Vector2(48, 32), "orientation": "north"})
	vents.append({"position": Vector2(600, 200), "size": Vector2(48, 32), "orientation": "north"})
	vents.append({"position": Vector2(200, 640), "size": Vector2(48, 32), "orientation": "south"})

	# Old pipes
	pipes.append({"position": Vector2(100, 100), "type": "water"})
	pipes.append({"position": Vector2(550, 400), "type": "water"})
	pipes.append({"position": Vector2(300, 300), "type": "electrical"})

	# Single elevation
	elevation_zones.append({"rect": layout_bounds, "height": 0.0})

	# Cracks
	cracks.append(Vector2(100, 450))
	cracks.append(Vector2(550, 640))

	# Probe position (corner alcove)
	probe_position = Vector2(125, 337)

	# Spawn zones (cramped corners)
	spawn_zones.append(Rect2(50, 50, 150, 150))
	spawn_zones.append(Rect2(550, 250, 150, 150))

# COLONIAL LAYOUT: Long rectangular, central beam, symmetrical
func _generate_colonial_layout():
	# Long rectangular: 70x25 tiles (1120x400 pixels)
	layout_bounds = Rect2(0, 0, 1120, 400)

	# Outer walls
	walls.append(PackedVector2Array([
		Vector2(0, 0),
		Vector2(1120, 0),
		Vector2(1120, 400),
		Vector2(0, 400),
		Vector2(0, 0)
	]))

	# Central support beam
	beams.append({"start": Vector2(560, 0), "end": Vector2(560, 400)})

	# Symmetrical vents (5 vents)
	vents.append({"position": Vector2(224, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(560, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(896, 0), "size": Vector2(64, 32), "orientation": "north"})
	vents.append({"position": Vector2(280, 400), "size": Vector2(64, 32), "orientation": "south"})
	vents.append({"position": Vector2(840, 400), "size": Vector2(64, 32), "orientation": "south"})

	# Symmetrical pipes
	pipes.append({"position": Vector2(280, 200), "type": "water"})
	pipes.append({"position": Vector2(840, 200), "type": "water"})

	# Single elevation
	elevation_zones.append({"rect": layout_bounds, "height": 0.0})

	# Symmetrical cracks
	cracks.append(Vector2(200, 400))
	cracks.append(Vector2(920, 400))

	# Probe position (center)
	probe_position = Vector2(560, 200)

	# Spawn zones (symmetrical)
	spawn_zones.append(Rect2(100, 100, 400, 200))
	spawn_zones.append(Rect2(620, 100, 400, 200))

# BUNGALOW LAYOUT: Small and cramped, minimal vents
func _generate_bungalow_layout():
	# Small square: 30x30 tiles (480x480 pixels)
	layout_bounds = Rect2(0, 0, 480, 480)

	# Outer walls
	walls.append(PackedVector2Array([
		Vector2(0, 0),
		Vector2(480, 0),
		Vector2(480, 480),
		Vector2(0, 480),
		Vector2(0, 0)
	]))

	# Beams creating cramped sections
	beams.append({"start": Vector2(160, 0), "end": Vector2(160, 480)})
	beams.append({"start": Vector2(320, 0), "end": Vector2(320, 480)})
	beams.append({"start": Vector2(0, 240), "end": Vector2(480, 240)})

	# Minimal vents (2 vents only!)
	vents.append({"position": Vector2(240, 0), "size": Vector2(48, 24), "orientation": "north"})
	vents.append({"position": Vector2(100, 480), "size": Vector2(48, 24), "orientation": "south"})

	# Single pipe
	pipes.append({"position": Vector2(240, 360), "type": "water"})

	# Single elevation
	elevation_zones.append({"rect": layout_bounds, "height": 0.0})

	# Single crack
	cracks.append(Vector2(400, 480))

	# Probe position (cramped corner)
	probe_position = Vector2(80, 360)

	# Spawn zone (very limited)
	spawn_zones.append(Rect2(50, 50, 100, 150))

# Helper functions
func _get_house_type_from_name(house_name: String) -> HouseType:
	match house_name.to_lower():
		"ranch", "ranch house":
			return HouseType.RANCH
		"two-story", "two story", "two-story house":
			return HouseType.TWO_STORY
		"split-level", "split level", "split-level house":
			return HouseType.SPLIT_LEVEL
		"victorian", "victorian house":
			return HouseType.VICTORIAN
		"colonial", "colonial house":
			return HouseType.COLONIAL
		"bungalow":
			return HouseType.BUNGALOW
		_:
			push_warning("Unknown house type: " + house_name + ", defaulting to Ranch")
			return HouseType.RANCH

# Get all house types for selection UI
func get_all_house_types() -> Array[Dictionary]:
	var house_list: Array[Dictionary] = []
	for house_type in HouseType.values():
		house_list.append({
			"id": house_type,
			"name": HOUSE_NAMES[house_type],
			"description": HOUSE_DESCRIPTIONS[house_type]
		})
	return house_list

# Check if position is in walkable area
func is_position_walkable(pos: Vector2) -> bool:
	if not layout_bounds.has_point(pos):
		return false

	# Check against beam obstacles
	for beam in beams:
		var beam_rect = _get_beam_collision_rect(beam)
		if beam_rect.has_point(pos):
			return false

	return true

func _get_beam_collision_rect(beam: Dictionary) -> Rect2:
	var start = beam["start"]
	var end = beam["end"]
	var thickness = 16.0  # Beam thickness

	if start.x == end.x:  # Vertical beam
		return Rect2(start.x - thickness/2, min(start.y, end.y), thickness, abs(end.y - start.y))
	else:  # Horizontal beam
		return Rect2(min(start.x, end.x), start.y - thickness/2, abs(end.x - start.x), thickness)

# Get elevation at position
func get_elevation_at(pos: Vector2) -> float:
	for zone in elevation_zones:
		if zone["rect"].has_point(pos):
			return zone["height"]
	return 0.0

# Get save data
func get_save_data() -> Dictionary:
	return {
		"house_type": current_house_type,
		"probe_position": {"x": probe_position.x, "y": probe_position.y}
	}

# Load save data
func load_save_data(data: Dictionary):
	if data.has("house_type"):
		current_house_type = data["house_type"]
		# Regenerate layout
		var house_name = HOUSE_NAMES[current_house_type]
		generate_layout(house_name)

	if data.has("probe_position"):
		var pos_data = data["probe_position"]
		probe_position = Vector2(pos_data["x"], pos_data["y"])
