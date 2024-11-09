class_name ConfigSettings
extends Object

const CONFIG_PATH = "user://settings.cfg"


# properties with default values
var show_ui: bool = true
var fullscreen: bool = false
var music_on: bool = true


func load():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err == OK:
		show_ui = config.get_value("Display", "ShowUI", show_ui)
		fullscreen = config.get_value("Display", "Fullscreen", fullscreen)
		music_on = config.get_value("Audio", "Music", music_on)
	else:
		print("Config file not found, using default settings.")


func save():
	var config = ConfigFile.new()
	config.set_value("Display", "ShowUI", show_ui)
	config.set_value("Display", "Fullscreen", fullscreen)
	config.set_value("Audio", "Music", music_on)
	
	var err = config.save(CONFIG_PATH)
	if err != OK:
		print("Failed to save settings!")
	else:
		print("Settings saved successfully.")
