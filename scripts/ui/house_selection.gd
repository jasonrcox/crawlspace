extends Control
# House selection screen
# Allows player to choose crawlspace layout

signal house_selected(house_type: String)

@onready var title_label = $MarginContainer/VBoxContainer/TitleLabel
@onready var house_container = $MarginContainer/VBoxContainer/ScrollContainer/HouseGrid

# Simple house list
var houses = [
	"Ranch House",
	"Two-Story House",
	"Split-Level House",
	"Victorian House",
	"Colonial House",
	"Bungalow"
]

func _ready():
	print("[HouseSelection] Starting house selection setup")
	print("[HouseSelection] House container: ", house_container)
	_populate_house_selection()

func _populate_house_selection():
	# Create simple buttons for each house
	for i in range(houses.size()):
		var house_name = houses[i]
		var button = Button.new()
		button.name = "HouseButton" + str(i)
		button.text = house_name
		button.custom_minimum_size = Vector2(560, 40)
		button.pressed.connect(_on_house_button_pressed.bind(house_name))
		house_container.add_child(button)
		print("[HouseSelection] Added button: ", house_name, " at index ", i)

	print("[HouseSelection] Created ", houses.size(), " house buttons")
	print("[HouseSelection] Container has ", house_container.get_child_count(), " children")

func _on_house_button_pressed(house_name: String):
	print("[HouseSelection] Selected: ", house_name)
	house_selected.emit(house_name)
