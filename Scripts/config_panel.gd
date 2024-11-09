# ConfigPanel.gd
extends Panel

var config_settings: ConfigSettings  # Regular variable, not exported
@onready var vbox_container = $VBoxContainer  # Container for generated UI elements

# Dictionary to keep track of each setting's UI control
var setting_controls: Dictionary = {}

# Called to initialize the UI, with ConfigSettings passed in
func set_config_settings(config_instance: ConfigSettings):
	config_settings = config_instance
	generate_ui_for_settings()

# Generate UI elements for each setting in ConfigSettings
func generate_ui_for_settings():
	for setting_name in ["show_ui", "fullscreen", "music_on"]:
		var setting_value = config_settings.get(setting_name)

		var checkbox = CheckBox.new()
		checkbox.text = setting_name.capitalize().replace("_", " ")  # Display name with formatting
		checkbox.button_pressed = setting_value  # Set initial value based on current config

		setting_controls[setting_name] = checkbox
		
		# Connect the checkbox's toggled signal using Callable.bind() to pass `setting_name`
		checkbox.connect("toggled", Callable(self, "_on_checkbox_toggled").bind(setting_name))

		vbox_container.add_child(checkbox)

# Called whenever a checkbox is toggled
func _on_checkbox_toggled(pressed: bool, setting_name: String):
	# Update the config setting in memory
	config_settings.set(setting_name, pressed)

# Save button pressed handler
func _on_save_button_pressed():
	# Save the updated settings
	config_settings.save()
	print("Settings saved!")
