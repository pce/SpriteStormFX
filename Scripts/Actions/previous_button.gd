extends Button  

@onready var app_controller = get_tree().root.get_node("AppController")

func _ready():
	connect("pressed", _on_button_pressed, ACTION_MODE_BUTTON_PRESS)
	

func _on_button_pressed():
	if app_controller:
		app_controller.load_previous_scene()
	else:
		push_error("AppController not found. Check if it's correctly set up.")
