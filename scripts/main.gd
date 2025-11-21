extends Node2D
## Main game scene controller
## Manages scene transitions and overall game flow

@onready var house_selection_scene = preload("res://scenes/main/house_selection.tscn")
@onready var crawlspace_scene = preload("res://scenes/environment/crawlspace.tscn")

var current_scene: Node = null

func _ready():
	print("[Main] Game starting")
	_show_main_menu()

func _show_main_menu():
	# Check if save file exists
	if SaveSystem.has_save_file():
		_show_continue_or_new_game()
	else:
		_show_house_selection()

func _show_continue_or_new_game():
	# For now, just load the game
	# TODO: Create proper menu UI
	if SaveSystem.load_game():
		_start_game(GameManager.current_house_type)
	else:
		_show_house_selection()

func _show_house_selection():
	print("[Main] Showing house selection")
	if current_scene:
		current_scene.queue_free()

	current_scene = house_selection_scene.instantiate()
	add_child(current_scene)

	# Connect house selection signal
	if current_scene.has_signal("house_selected"):
		current_scene.house_selected.connect(_on_house_selected)

func _on_house_selected(house_type: String):
	print("[Main] House selected: ", house_type)
	GameManager.start_new_game(house_type)
	_start_game(house_type)

func _start_game(house_type: String):
	print("[Main] Starting game with house type: ", house_type)

	if current_scene:
		current_scene.queue_free()

	current_scene = crawlspace_scene.instantiate()
	add_child(current_scene)

	# Initialize the crawlspace
	if current_scene.has_method("initialize"):
		current_scene.initialize(house_type)

func _input(event):
	# Quick save/load for testing
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F5:
			print("[Main] Quick save")
			SaveSystem.save_game()
		elif event.keycode == KEY_F9:
			print("[Main] Quick load")
			if SaveSystem.load_game():
				_start_game(GameManager.current_house_type)
		elif event.keycode == KEY_ESCAPE:
			GameManager.toggle_pause()
