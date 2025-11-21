extends Node
# Manages society progression, population, and cultural development
# Tracks civilization stages and triggers transitions

# Society stages
enum SocietyStage {
	SCATTERED,      # 0-10 population
	TRIBAL,         # 10-25 population
	SETTLEMENT,     # 25-50 population
	ORGANIZED,      # 50-100 population
	ADVANCED,       # 100-200 population
	TRANSCENDENT    # 200+ population
}

const STAGE_NAMES = {
	SocietyStage.SCATTERED: "Scattered",
	SocietyStage.TRIBAL: "Tribal",
	SocietyStage.SETTLEMENT: "Settlement",
	SocietyStage.ORGANIZED: "Organized",
	SocietyStage.ADVANCED: "Advanced",
	SocietyStage.TRANSCENDENT: "Transcendent"
}

const STAGE_THRESHOLDS = {
	SocietyStage.SCATTERED: 0,
	SocietyStage.TRIBAL: 10,
	SocietyStage.SETTLEMENT: 25,
	SocietyStage.ORGANIZED: 50,
	SocietyStage.ADVANCED: 100,
	SocietyStage.TRANSCENDENT: 200
}

# Current state
var current_stage: SocietyStage = SocietyStage.SCATTERED
var population: int = 5  # Starting population
var max_population: int = 10  # Capacity based on buildings

# Population distribution
var settlements: Array[Dictionary] = []  # {position: Vector2, population: int}

# Cultural traits (influenced by layout and player choices)
var cultural_traits: Array[String] = []

# Buildings
var buildings: Array[Node] = []
var building_count_by_type: Dictionary = {}

# Statistics
var total_births: int = 0
var total_deaths: int = 0
var civilization_age: float = 0.0

func _ready():
	print("[SocietyManager] Society manager initialized")
	_connect_signals()

func _connect_signals():
	EventBus.creature_spawned.connect(_on_creature_spawned)
	EventBus.creature_died.connect(_on_creature_died)
	EventBus.building_completed.connect(_on_building_completed)
	EventBus.building_destroyed.connect(_on_building_destroyed)

func _process(delta: float):
	if GameManager.game_started and not GameManager.is_paused:
		civilization_age += delta
		_check_stage_progression()

# Add population
func add_population(amount: int):
	var old_population = population
	population = min(population + amount, max_population)
	var actual_added = population - old_population

	if actual_added > 0:
		total_births += actual_added
		EventBus.population_changed.emit(population)
		_check_stage_progression()

# Remove population
func remove_population(amount: int):
	population = max(0, population - amount)
	total_deaths += amount
	EventBus.population_changed.emit(population)
	_check_stage_progression()

# Increase maximum population capacity
func increase_max_population(amount: int):
	max_population += amount
	print("[SocietyManager] Max population increased to ", max_population)

# Check if society should progress to next stage
func _check_stage_progression():
	var new_stage = _calculate_stage_from_population()

	if new_stage != current_stage and new_stage > current_stage:
		_advance_to_stage(new_stage)

func _calculate_stage_from_population() -> SocietyStage:
	if population >= STAGE_THRESHOLDS[SocietyStage.TRANSCENDENT]:
		return SocietyStage.TRANSCENDENT
	elif population >= STAGE_THRESHOLDS[SocietyStage.ADVANCED]:
		return SocietyStage.ADVANCED
	elif population >= STAGE_THRESHOLDS[SocietyStage.ORGANIZED]:
		return SocietyStage.ORGANIZED
	elif population >= STAGE_THRESHOLDS[SocietyStage.SETTLEMENT]:
		return SocietyStage.SETTLEMENT
	elif population >= STAGE_THRESHOLDS[SocietyStage.TRIBAL]:
		return SocietyStage.TRIBAL
	else:
		return SocietyStage.SCATTERED

# Advance society to new stage
func _advance_to_stage(new_stage: SocietyStage):
	var old_stage = current_stage
	current_stage = new_stage

	var stage_name = STAGE_NAMES[new_stage]
	print("[SocietyManager] Society advanced to: ", stage_name)

	EventBus.society_stage_changed.emit(new_stage, stage_name)
	EventBus.milestone_reached.emit("Society: " + stage_name)

	# Unlock stage-specific benefits
	_apply_stage_benefits(new_stage)

	# Show notification
	var message = _get_stage_description(new_stage)
	EventBus.show_notification.emit("Society Evolution", stage_name + "\n\n" + message)

func _get_stage_description(stage: SocietyStage) -> String:
	match stage:
		SocietyStage.SCATTERED:
			return "Individuals exploring and surviving independently"
		SocietyStage.TRIBAL:
			return "Creatures begin forming groups and sharing resources"
		SocietyStage.SETTLEMENT:
			return "Permanent structures emerge, roles specialize"
		SocietyStage.ORGANIZED:
			return "Complex society with governance and infrastructure"
		SocietyStage.ADVANCED:
			return "Technology-driven civilization mastering the environment"
		SocietyStage.TRANSCENDENT:
			return "Understanding their origin, ready to transcend"
	return ""

func _apply_stage_benefits(stage: SocietyStage):
	match stage:
		SocietyStage.SCATTERED:
			pass  # No bonuses for scattered stage
		SocietyStage.TRIBAL:
			ResourceManager.add_multiplier("food", 0.2)
		SocietyStage.SETTLEMENT:
			ResourceManager.add_multiplier("materials", 0.3)
			increase_max_population(20)
		SocietyStage.ORGANIZED:
			ResourceManager.add_multiplier("research", 0.5)
			increase_max_population(50)
		SocietyStage.ADVANCED:
			ResourceManager.add_multiplier("energy", 0.5)
			increase_max_population(100)
		SocietyStage.TRANSCENDENT:
			ResourceManager.add_multiplier("research", 1.0)

# Add cultural trait based on environment and actions
func add_cultural_trait(trait_name: String) -> void:
	if trait_name not in cultural_traits:
		cultural_traits.append(trait_name)
		print("[SocietyManager] Cultural trait gained: ", trait_name)

# Register a building
func register_building(building: Node, building_type: String):
	buildings.append(building)

	if not building_count_by_type.has(building_type):
		building_count_by_type[building_type] = 0
	building_count_by_type[building_type] += 1

	# Update population capacity based on building type
	match building_type:
		"shelter":
			increase_max_population(5)
		"housing":
			increase_max_population(10)
		"apartment":
			increase_max_population(20)

# Get current stage name
func get_current_stage_name() -> String:
	return STAGE_NAMES[current_stage]

# Get building count of specific type
func get_building_count(building_type: String) -> int:
	return building_count_by_type.get(building_type, 0)

# Get save data
func get_save_data() -> Dictionary:
	return {
		"current_stage": current_stage,
		"population": population,
		"max_population": max_population,
		"cultural_traits": cultural_traits.duplicate(),
		"building_count_by_type": building_count_by_type.duplicate(),
		"total_births": total_births,
		"total_deaths": total_deaths,
		"civilization_age": civilization_age
	}

# Load save data
func load_save_data(data: Dictionary):
	if data.has("current_stage"):
		current_stage = data["current_stage"]
	if data.has("population"):
		population = data["population"]
	if data.has("max_population"):
		max_population = data["max_population"]
	if data.has("cultural_traits"):
		cultural_traits.clear()
		for trait_item in data["cultural_traits"]:
			cultural_traits.append(trait_item)
	if data.has("building_count_by_type"):
		building_count_by_type = data["building_count_by_type"].duplicate()
	if data.has("total_births"):
		total_births = data["total_births"]
	if data.has("total_deaths"):
		total_deaths = data["total_deaths"]
	if data.has("civilization_age"):
		civilization_age = data["civilization_age"]

# Signal handlers
func _on_creature_spawned(creature: Node2D):
	add_population(1)

func _on_creature_died(creature: Node2D):
	remove_population(1)

func _on_building_completed(building: Node2D):
	# Building registration happens through explicit calls
	pass

func _on_building_destroyed(building: Node2D):
	if building in buildings:
		buildings.erase(building)
