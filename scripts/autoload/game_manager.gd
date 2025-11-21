extends Node
# Central game state manager
# Handles game flow, progression, and high-level state

# Game state
enum GameState {
	MENU,
	HOUSE_SELECTION,
	PLAYING,
	PAUSED,
	TERMINAL
}

var current_state: GameState = GameState.MENU
var is_paused: bool = false

# Progression
var total_playtime: float = 0.0
var current_session_time: float = 0.0
var last_save_time: float = 0.0

# Technologies
var unlocked_technologies: Array[String] = []
var available_technologies: Array[String] = []

# Achievements
var unlocked_achievements: Array[String] = []

# Prestige
var prestige_level: int = 0
var prestige_bonuses := {
	"resource_multiplier": 1.0,
	"research_speed": 1.0,
	"starting_resources": {}
}

# Current game session
var current_house_type: String = ""
var game_started: bool = false

# Auto-save timer
var auto_save_interval: float = 60.0  # Save every 60 seconds
var time_since_last_save: float = 0.0

func _ready():
	print("[GameManager] Game manager initialized")
	_connect_signals()

func _connect_signals():
	EventBus.technology_unlocked.connect(_on_technology_unlocked)
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_resumed.connect(_on_game_resumed)

func _process(delta: float):
	if current_state == GameState.PLAYING and not is_paused:
		total_playtime += delta
		current_session_time += delta
		time_since_last_save += delta

		# Auto-save check
		if time_since_last_save >= auto_save_interval:
			SaveSystem.save_game()
			time_since_last_save = 0.0

# Start a new game with selected house type
func start_new_game(house_type: String):
	print("[GameManager] Starting new game with house type: ", house_type)
	current_house_type = house_type
	current_state = GameState.PLAYING
	game_started = true
	current_session_time = 0.0

	# Apply prestige bonuses
	_apply_prestige_bonuses()

	# Initialize systems
	LayoutGenerator.generate_layout(house_type)

	EventBus.show_notification.emit("Probe Activated", "Life germination sequence initiated...")

# Continue existing game
func continue_game():
	if SaveSystem.load_game():
		current_state = GameState.PLAYING
		game_started = true
		print("[GameManager] Game loaded successfully")
	else:
		push_warning("Failed to load game")

# Pause the game
func pause_game():
	is_paused = true
	get_tree().paused = true
	EventBus.game_paused.emit()

# Resume the game
func resume_game():
	is_paused = false
	get_tree().paused = false
	EventBus.game_resumed.emit()

# Toggle pause
func toggle_pause():
	if is_paused:
		resume_game()
	else:
		pause_game()

# Unlock a technology
func unlock_technology(tech_id: String):
	if tech_id not in unlocked_technologies:
		unlocked_technologies.append(tech_id)
		EventBus.technology_unlocked.emit(tech_id)
		print("[GameManager] Technology unlocked: ", tech_id)

# Check if technology is unlocked
func is_technology_unlocked(tech_id: String) -> bool:
	return tech_id in unlocked_technologies

# Unlock achievement
func unlock_achievement(achievement_id: String):
	if achievement_id not in unlocked_achievements:
		unlocked_achievements.append(achievement_id)
		EventBus.show_notification.emit("Achievement", "Unlocked: " + achievement_id)

# Prestige (restart with bonuses)
func prestige():
	prestige_level += 1

	# Calculate prestige bonuses
	prestige_bonuses["resource_multiplier"] = 1.0 + (prestige_level * 0.1)
	prestige_bonuses["research_speed"] = 1.0 + (prestige_level * 0.15)

	# Save prestige data before reset
	SaveSystem.save_prestige_data()

	# Reset game state
	_reset_game_state()

	print("[GameManager] Prestige level: ", prestige_level)
	EventBus.show_notification.emit("New Simulation", "Prestige level " + str(prestige_level) + " activated")

func _reset_game_state():
	total_playtime = 0.0
	current_session_time = 0.0
	unlocked_technologies.clear()
	current_house_type = ""
	game_started = false

	# Reset other managers
	ResourceManager.resources = {
		"energy": 100.0 * prestige_bonuses["resource_multiplier"],
		"water": 50.0 * prestige_bonuses["resource_multiplier"],
		"materials": 30.0 * prestige_bonuses["resource_multiplier"],
		"food": 20.0 * prestige_bonuses["resource_multiplier"],
		"research": 0.0
	}

func _apply_prestige_bonuses():
	# Apply resource multiplier
	ResourceManager.set_multiplier("energy", prestige_bonuses["resource_multiplier"])
	ResourceManager.set_multiplier("water", prestige_bonuses["resource_multiplier"])
	ResourceManager.set_multiplier("materials", prestige_bonuses["resource_multiplier"])
	ResourceManager.set_multiplier("food", prestige_bonuses["resource_multiplier"])
	ResourceManager.set_multiplier("research", prestige_bonuses["research_speed"])

# Get save data
func get_save_data() -> Dictionary:
	return {
		"total_playtime": total_playtime,
		"current_house_type": current_house_type,
		"unlocked_technologies": unlocked_technologies.duplicate(),
		"unlocked_achievements": unlocked_achievements.duplicate(),
		"prestige_level": prestige_level,
		"prestige_bonuses": prestige_bonuses.duplicate()
	}

# Load save data
func load_save_data(data: Dictionary):
	if data.has("total_playtime"):
		total_playtime = data["total_playtime"]
	if data.has("current_house_type"):
		current_house_type = data["current_house_type"]
	if data.has("unlocked_technologies"):
		unlocked_technologies.clear()
		for tech in data["unlocked_technologies"]:
			unlocked_technologies.append(tech)
	if data.has("unlocked_achievements"):
		unlocked_achievements.clear()
		for achievement in data["unlocked_achievements"]:
			unlocked_achievements.append(achievement)
	if data.has("prestige_level"):
		prestige_level = data["prestige_level"]
	if data.has("prestige_bonuses"):
		prestige_bonuses = data["prestige_bonuses"].duplicate()

func _on_technology_unlocked(tech_id: String):
	# Handle any immediate effects of tech unlock
	pass

func _on_game_paused():
	print("[GameManager] Game paused")

func _on_game_resumed():
	print("[GameManager] Game resumed")
