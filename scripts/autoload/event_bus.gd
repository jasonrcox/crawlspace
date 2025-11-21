extends Node
# Global event bus for decoupled communication between systems
# Use signals to broadcast events without tight coupling

# Creature events
signal creature_spawned(creature: Node2D)
signal creature_died(creature: Node2D)
signal population_changed(new_count: int)

# Resource events
signal resource_generated(resource_type: String, amount: float)
signal resource_consumed(resource_type: String, amount: float)
signal resource_depleted(resource_type: String)

# Building events
signal building_placed(building: Node2D, location: Vector2)
signal building_completed(building: Node2D)
signal building_destroyed(building: Node2D)

# Society events
signal society_stage_changed(new_stage: int, stage_name: String)
signal technology_unlocked(tech_id: String)
signal milestone_reached(milestone_name: String)

# Environment events
signal weather_changed(weather_type: String)
signal storm_started()
signal storm_ended()
signal flood_warning(severity: float)
signal vent_light_changed(vent_id: int, intensity: float)

# UI events
signal terminal_opened()
signal terminal_closed()
signal blueprint_created(blueprint_name: String)
signal show_notification(title: String, message: String)

# Game state events
signal game_paused()
signal game_resumed()
signal save_completed()
signal save_failed(error: String)

func _ready():
	print("[EventBus] Event bus initialized")
