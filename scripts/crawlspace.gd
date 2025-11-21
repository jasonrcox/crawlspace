extends Node2D
## Main crawlspace gameplay scene
## Handles environment rendering, creature spawning, and gameplay

@onready var camera = $Camera2D
@onready var environment_layer = $EnvironmentLayer
@onready var creature_layer = $CreatureLayer
@onready var building_layer = $BuildingLayer
@onready var effects_layer = $EffectsLayer
@onready var ui_layer = $UILayer

# Creature scene (will be created later, using conditional loading for now)
# var creature_scene = preload("res://scenes/creatures/creature_base.tscn")

# Current state
var initialized: bool = false
var current_house_type: String = ""

func _ready():
	print("[Crawlspace] Crawlspace scene ready")

func initialize(house_type: String):
	print("[Crawlspace] Initializing with house type: ", house_type)
	current_house_type = house_type

	# Generate layout if not already done
	if LayoutGenerator.current_house_type == null or LayoutGenerator.HOUSE_NAMES.get(LayoutGenerator.current_house_type, "") != house_type:
		LayoutGenerator.generate_layout(house_type)

	# Render environment
	_render_environment()

	# Position camera
	_setup_camera()

	# Spawn probe
	_spawn_probe()

	# Spawn initial creatures
	_spawn_initial_creatures()

	initialized = true

func _render_environment():
	print("[Crawlspace] Rendering environment")

	# Clear existing environment
	for child in environment_layer.get_children():
		child.queue_free()

	# Render layout bounds as background
	var background = ColorRect.new()
	background.color = Color(0.176, 0.106, 0, 1)  # Dark brown
	background.size = LayoutGenerator.layout_bounds.size
	background.position = LayoutGenerator.layout_bounds.position
	environment_layer.add_child(background)

	# Render walls
	for wall_points in LayoutGenerator.walls:
		_render_wall(wall_points)

	# Render beams
	for beam in LayoutGenerator.beams:
		_render_beam(beam)

	# Render vents (light sources)
	for vent in LayoutGenerator.vents:
		_render_vent(vent)

	# Render pipes
	for pipe in LayoutGenerator.pipes:
		_render_pipe(pipe)

	# Render foundation cracks
	for crack in LayoutGenerator.cracks:
		_render_crack(crack)

func _render_wall(wall_points: PackedVector2Array):
	var line = Line2D.new()
	line.points = wall_points
	line.width = 4.0
	line.default_color = Color(0.2, 0.2, 0.2, 1)  # Dark gray
	environment_layer.add_child(line)

func _render_beam(beam: Dictionary):
	var line = Line2D.new()
	line.add_point(beam["start"])
	line.add_point(beam["end"])
	line.width = 16.0
	line.default_color = Color(0.3, 0.25, 0.2, 1)  # Brown-gray
	environment_layer.add_child(line)

	# Add collision for beam
	var static_body = StaticBody2D.new()
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()

	var start = beam["start"]
	var end = beam["end"]

	if start.x == end.x:  # Vertical beam
		shape.size = Vector2(16, abs(end.y - start.y))
		static_body.position = Vector2(start.x, (start.y + end.y) / 2)
	else:  # Horizontal beam
		shape.size = Vector2(abs(end.x - start.x), 16)
		static_body.position = Vector2((start.x + end.x) / 2, start.y)

	collision.shape = shape
	static_body.add_child(collision)
	environment_layer.add_child(static_body)

func _render_vent(vent: Dictionary):
	# Vent as colored rectangle (placeholder for light source)
	var vent_rect = ColorRect.new()
	vent_rect.color = Color(1.0, 0.95, 0.5, 0.3)  # Warm yellow light
	vent_rect.size = vent["size"]
	vent_rect.position = vent["position"]
	environment_layer.add_child(vent_rect)

	# Add point light
	var light = PointLight2D.new()
	light.position = vent["position"] + vent["size"] / 2
	light.energy = 1.5
	light.texture_scale = 3.0
	light.color = Color(1.0, 0.9, 0.6, 1)  # Warm light
	environment_layer.add_child(light)

func _render_pipe(pipe: Dictionary):
	# Pipe as small colored circle (placeholder)
	var pipe_marker = ColorRect.new()
	pipe_marker.size = Vector2(16, 16)
	pipe_marker.position = pipe["position"]

	match pipe["type"]:
		"water":
			pipe_marker.color = Color(0.3, 0.5, 0.8, 1)  # Blue
		"electrical":
			pipe_marker.color = Color(0.8, 0.7, 0.2, 1)  # Yellow
		_:
			pipe_marker.color = Color(0.5, 0.5, 0.5, 1)  # Gray

	environment_layer.add_child(pipe_marker)

func _render_crack(crack: Vector2):
	# Crack as small marker (placeholder)
	var crack_marker = ColorRect.new()
	crack_marker.size = Vector2(8, 8)
	crack_marker.position = crack
	crack_marker.color = Color(0.1, 0.1, 0.1, 1)  # Dark
	environment_layer.add_child(crack_marker)

func _setup_camera():
	# Center camera on layout
	var center = LayoutGenerator.layout_bounds.get_center()
	camera.position = center

	# Adjust zoom based on layout size
	var layout_size = LayoutGenerator.layout_bounds.size
	var max_dimension = max(layout_size.x, layout_size.y)

	# Calculate zoom to fit layout in viewport
	var viewport_size = get_viewport_rect().size
	var zoom_x = viewport_size.x / max_dimension
	var zoom_y = viewport_size.y / max_dimension
	var zoom_level = min(zoom_x, zoom_y) * 0.8  # 0.8 for margin

	camera.zoom = Vector2(zoom_level, zoom_level)

	print("[Crawlspace] Camera positioned at ", center, " with zoom ", zoom_level)

func _spawn_probe():
	# Spawn the AI probe at designated position
	var probe = ColorRect.new()  # Placeholder
	probe.size = Vector2(32, 32)
	probe.position = LayoutGenerator.probe_position - probe.size / 2
	probe.color = Color(0.3, 0.83, 1.0, 0.8)  # Cyan glow

	# Add glow effect
	var probe_light = PointLight2D.new()
	probe_light.position = LayoutGenerator.probe_position
	probe_light.energy = 2.0
	probe_light.texture_scale = 2.0
	probe_light.color = Color(0.3, 0.83, 1.0, 1)

	environment_layer.add_child(probe)
	effects_layer.add_child(probe_light)

	print("[Crawlspace] Probe spawned at ", LayoutGenerator.probe_position)

func _spawn_initial_creatures():
	# Spawn starting population near probe
	var start_pop = 5

	for i in range(start_pop):
		_spawn_creature_near_probe()

func _spawn_creature_near_probe():
	# Check if creature scene exists
	if not ResourceLoader.exists("res://scenes/creatures/creature_base.tscn"):
		print("[Crawlspace] Creature scene not found, creating placeholder")
		_spawn_placeholder_creature()
		return

	var creature_scene = load("res://scenes/creatures/creature_base.tscn")
	var creature = creature_scene.instantiate()
	var spawn_pos = LayoutGenerator.probe_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	creature.position = spawn_pos
	creature_layer.add_child(creature)

func _spawn_placeholder_creature():
	# Temporary placeholder until we create creature scene
	var creature = ColorRect.new()
	creature.size = Vector2(8, 8)
	var spawn_pos = LayoutGenerator.probe_position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	creature.position = spawn_pos
	creature.color = Color(0.6, 0.8, 0.6, 1)  # Green
	creature_layer.add_child(creature)

	# Add simple movement
	var tween = create_tween()
	tween.set_loops()
	var target = spawn_pos + Vector2(randf_range(-100, 100), randf_range(-100, 100))
	tween.tween_property(creature, "position", target, randf_range(3, 6))
	tween.tween_property(creature, "position", spawn_pos, randf_range(3, 6))

func _input(event):
	# Camera controls for testing
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom *= 1.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom *= 0.9

	# Pan camera with middle mouse or arrow keys
	var pan_speed = 5.0 / camera.zoom.x
	if Input.is_action_pressed("ui_left"):
		camera.position.x -= pan_speed
	if Input.is_action_pressed("ui_right"):
		camera.position.x += pan_speed
	if Input.is_action_pressed("ui_up"):
		camera.position.y -= pan_speed
	if Input.is_action_pressed("ui_down"):
		camera.position.y += pan_speed
