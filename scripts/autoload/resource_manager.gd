extends Node
# Manages all game resources: generation, consumption, storage
# Handles idle resource accumulation

# Resource storage
var resources := {
	"energy": 100.0,
	"water": 50.0,
	"materials": 30.0,
	"food": 20.0,
	"research": 0.0
}

# Base generation rates (per second)
var base_generation_rates := {
	"energy": 1.0,
	"water": 0.0,  # Comes from rain/environment
	"materials": 0.5,
	"food": 0.0,  # Comes from agriculture
	"research": 0.1
}

# Current effective rates (modified by tech/population)
var generation_rates := {}

# Resource caps
var resource_caps := {
	"energy": 1000.0,
	"water": 500.0,
	"materials": 800.0,
	"food": 300.0,
	"research": 99999.0  # No practical cap on research
}

# Multipliers from technologies and buildings
var generation_multipliers := {
	"energy": 1.0,
	"water": 1.0,
	"materials": 1.0,
	"food": 1.0,
	"research": 1.0
}

func _ready():
	print("[ResourceManager] Resource manager initialized")
	_initialize_generation_rates()

func _initialize_generation_rates():
	for resource in base_generation_rates:
		generation_rates[resource] = base_generation_rates[resource] * generation_multipliers[resource]

func _process(delta: float):
	# Accumulate resources every frame
	for resource in generation_rates:
		if generation_rates[resource] > 0:
			add_resource(resource, generation_rates[resource] * delta)

# Add resources with cap enforcement
func add_resource(resource_type: String, amount: float) -> float:
	if not resources.has(resource_type):
		push_warning("Unknown resource type: " + resource_type)
		return 0.0

	var old_amount = resources[resource_type]
	resources[resource_type] = min(resources[resource_type] + amount, resource_caps[resource_type])
	var actual_added = resources[resource_type] - old_amount

	if actual_added > 0:
		EventBus.resource_generated.emit(resource_type, actual_added)

	return actual_added

# Consume resources if available
func consume_resource(resource_type: String, amount: float) -> bool:
	if not resources.has(resource_type):
		push_warning("Unknown resource type: " + resource_type)
		return false

	if resources[resource_type] >= amount:
		resources[resource_type] -= amount
		EventBus.resource_consumed.emit(resource_type, amount)

		if resources[resource_type] <= 0:
			EventBus.resource_depleted.emit(resource_type)

		return true

	return false

# Check if resources are available
func has_resources(costs: Dictionary) -> bool:
	for resource_type in costs:
		if not resources.has(resource_type) or resources[resource_type] < costs[resource_type]:
			return false
	return true

# Consume multiple resources at once
func consume_resources(costs: Dictionary) -> bool:
	if not has_resources(costs):
		return false

	for resource_type in costs:
		consume_resource(resource_type, costs[resource_type])

	return true

# Update generation rate multiplier
func set_multiplier(resource_type: String, multiplier: float):
	if not generation_multipliers.has(resource_type):
		push_warning("Unknown resource type: " + resource_type)
		return

	generation_multipliers[resource_type] = multiplier
	_update_generation_rate(resource_type)

# Increase generation rate multiplier additively
func add_multiplier(resource_type: String, bonus: float):
	if not generation_multipliers.has(resource_type):
		push_warning("Unknown resource type: " + resource_type)
		return

	generation_multipliers[resource_type] += bonus
	_update_generation_rate(resource_type)

func _update_generation_rate(resource_type: String):
	generation_rates[resource_type] = base_generation_rates[resource_type] * generation_multipliers[resource_type]

# Get current resource amount
func get_resource(resource_type: String) -> float:
	return resources.get(resource_type, 0.0)

# Set resource amount directly (mainly for loading saves)
func set_resource(resource_type: String, amount: float):
	if resources.has(resource_type):
		resources[resource_type] = clamp(amount, 0.0, resource_caps[resource_type])

# Increase resource cap
func increase_cap(resource_type: String, amount: float):
	if resource_caps.has(resource_type):
		resource_caps[resource_type] += amount

# Get data for saving
func get_save_data() -> Dictionary:
	return {
		"resources": resources.duplicate(),
		"generation_rates": base_generation_rates.duplicate(),
		"multipliers": generation_multipliers.duplicate(),
		"caps": resource_caps.duplicate()
	}

# Load data from save
func load_save_data(data: Dictionary):
	if data.has("resources"):
		resources = data["resources"].duplicate()
	if data.has("generation_rates"):
		base_generation_rates = data["generation_rates"].duplicate()
	if data.has("multipliers"):
		generation_multipliers = data["multipliers"].duplicate()
	if data.has("caps"):
		resource_caps = data["caps"].duplicate()

	_initialize_generation_rates()
