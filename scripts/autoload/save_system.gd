extends Node
# Handles saving and loading game state
# Calculates offline progress when game is resumed

const SAVE_PATH = "user://crawlspace_save.json"
const PRESTIGE_SAVE_PATH = "user://crawlspace_prestige.json"
const MAX_OFFLINE_HOURS = 24

var save_version = "1.0.0"

func _ready():
	print("[SaveSystem] Save system initialized")
	print("[SaveSystem] Save path: ", ProjectSettings.globalize_path(SAVE_PATH))

# Save the complete game state
func save_game() -> bool:
	var save_data = {
		"version": save_version,
		"timestamp": Time.get_unix_time_from_system(),
		"game_manager": GameManager.get_save_data(),
		"resource_manager": ResourceManager.get_save_data(),
		"society_manager": SocietyManager.get_save_data(),
		"layout": LayoutGenerator.get_save_data()
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data, "\t")
		file.store_string(json_string)
		file.close()
		print("[SaveSystem] Game saved successfully")
		EventBus.save_completed.emit()
		return true
	else:
		var error = "Failed to open save file for writing"
		push_error("[SaveSystem] " + error)
		EventBus.save_failed.emit(error)
		return false

# Load game state
func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		print("[SaveSystem] No save file found")
		return false

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("[SaveSystem] Failed to open save file")
		return false

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)

	if error != OK:
		push_error("[SaveSystem] Failed to parse save file: " + json.get_error_message())
		return false

	var save_data = json.data

	# Verify version compatibility
	if save_data.get("version", "") != save_version:
		print("[SaveSystem] Save file version mismatch, attempting migration...")
		# Could implement version migration here

	# Load data into managers
	if save_data.has("game_manager"):
		GameManager.load_save_data(save_data["game_manager"])

	if save_data.has("resource_manager"):
		ResourceManager.load_save_data(save_data["resource_manager"])

	if save_data.has("society_manager"):
		SocietyManager.load_save_data(save_data["society_manager"])

	if save_data.has("layout"):
		LayoutGenerator.load_save_data(save_data["layout"])

	# Calculate offline progress
	var last_timestamp = save_data.get("timestamp", 0)
	_calculate_offline_progress(last_timestamp)

	print("[SaveSystem] Game loaded successfully")
	return true

# Calculate and apply offline progress
func _calculate_offline_progress(last_timestamp: int):
	var current_time = Time.get_unix_time_from_system()
	var elapsed_seconds = current_time - last_timestamp

	# Cap at MAX_OFFLINE_HOURS
	var max_seconds = MAX_OFFLINE_HOURS * 3600
	elapsed_seconds = min(elapsed_seconds, max_seconds)

	if elapsed_seconds < 60:  # Less than 1 minute, skip
		return

	print("[SaveSystem] Calculating offline progress for ", elapsed_seconds, " seconds")

	# Calculate offline resource generation
	var offline_resources = {}
	for resource in ResourceManager.generation_rates:
		var rate = ResourceManager.generation_rates[resource]
		if rate > 0:
			var gained = rate * elapsed_seconds
			var actual_gained = ResourceManager.add_resource(resource, gained)
			offline_resources[resource] = actual_gained

	# Simulate basic creature activities (simplified)
	var creature_births = int(elapsed_seconds / 300.0)  # One birth every 5 minutes
	SocietyManager.add_population(creature_births)

	# Show welcome back summary
	_show_offline_progress_summary(elapsed_seconds, offline_resources)

# Show offline progress popup
func _show_offline_progress_summary(time_elapsed: int, resources_gained: Dictionary):
	var hours = int(time_elapsed / 3600)
	var minutes = int((time_elapsed % 3600) / 60)

	var message = "Welcome back!\n\n"

	if hours > 0:
		message += "You were away for %d hours, %d minutes\n\n" % [hours, minutes]
	else:
		message += "You were away for %d minutes\n\n" % [minutes]

	message += "Resources gained:\n"
	for resource in resources_gained:
		if resources_gained[resource] > 0:
			message += "  %s: +%.1f\n" % [resource.capitalize(), resources_gained[resource]]

	message += "\nPopulation: " + str(SocietyManager.population)

	EventBus.show_notification.emit("Offline Progress", message)

# Save prestige data separately (persists across resets)
func save_prestige_data() -> bool:
	var prestige_data = {
		"version": save_version,
		"prestige_level": GameManager.prestige_level,
		"prestige_bonuses": GameManager.prestige_bonuses.duplicate()
	}

	var file = FileAccess.open(PRESTIGE_SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(prestige_data, "\t")
		file.store_string(json_string)
		file.close()
		print("[SaveSystem] Prestige data saved")
		return true
	else:
		push_error("[SaveSystem] Failed to save prestige data")
		return false

# Load prestige data
func load_prestige_data() -> bool:
	if not FileAccess.file_exists(PRESTIGE_SAVE_PATH):
		return false

	var file = FileAccess.open(PRESTIGE_SAVE_PATH, FileAccess.READ)
	if not file:
		return false

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)

	if error != OK:
		return false

	var prestige_data = json.data

	if prestige_data.has("prestige_level"):
		GameManager.prestige_level = prestige_data["prestige_level"]

	if prestige_data.has("prestige_bonuses"):
		GameManager.prestige_bonuses = prestige_data["prestige_bonuses"].duplicate()

	print("[SaveSystem] Prestige data loaded: Level ", GameManager.prestige_level)
	return true

# Check if save file exists
func has_save_file() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

# Delete save file
func delete_save() -> bool:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("[SaveSystem] Save file deleted")
		return true
	return false
