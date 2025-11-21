extends Control
# Simple house selection - no complex layouts

signal house_selected(house_type: String)

var houses = ["Ranch House", "Two-Story House", "Split-Level House", "Victorian House", "Colonial House", "Bungalow"]

func _ready():
	# Create background
	var bg = ColorRect.new()
	bg.color = Color(0.176, 0.106, 0, 1)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Create title
	var title = Label.new()
	title.text = "CRAWLSPACE - SELECT HOUSE TYPE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(20, 20)
	title.size = Vector2(600, 30)
	add_child(title)

	# Create buttons directly
	for i in range(houses.size()):
		var button = Button.new()
		button.text = houses[i]
		button.position = Vector2(70, 70 + (i * 50))
		button.size = Vector2(500, 40)
		button.pressed.connect(_on_button_pressed.bind(houses[i]))
		add_child(button)
		print("Created button: ", houses[i])

func _on_button_pressed(house_name: String):
	print("Selected: ", house_name)
	house_selected.emit(house_name)
