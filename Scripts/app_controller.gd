extends Node

@export var fx_scenes: Array[PackedScene]
@export var fade_duration: float = 0.5

var fade_rect: ColorRect
var current_scene: Node = null
var current_index: int = 0
var next_scene: PackedScene = null

@onready var fx_name_label = $UICanvasLayer/Panel/FxNameLabel


func _ready():
	# Create a ColorRect node for fades
	fade_rect = ColorRect.new()
	fade_rect.color = Color(0, 0, 0, 0)
	fade_rect.anchor_left = 0
	fade_rect.anchor_top = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_bottom = 1
	fade_rect.visible = false
	add_child(fade_rect)
	# Load the initial FX scene
	load_scene_by_index(current_index)

func load_scene_by_index(index: int):	
	current_index = index % fx_scenes.size()
	next_scene = fx_scenes[current_index]
	fx_name_label.text = next_scene.resource_path.get_file().get_basename() 
	# Start fade-out effect?
	fade_out()

func load_next_scene():
	load_scene_by_index(current_index + 1)

func load_previous_scene():
	load_scene_by_index(current_index - 1)

# Fade-out function, then queues the current scene for removal
func fade_out():
	fade_rect.visible = true  # Make sure fade_rect is visible
	fade_rect.color.a = 0  # Ensure start of fade-out is fully transparent
	
	# Create a new tween for the fade-out effect
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, fade_duration)
	
	# Once fade-out is complete, queue the current scene for removal and load the next scene
	tween.tween_callback(self._on_fade_out)

# This function is called after fade-out to handle the scene transition
func _on_fade_out():
	if current_scene:
		current_scene.queue_free()  # Remove the old scene
	
	# Instantiate and add the new scene
	current_scene = next_scene.instantiate()
	add_child(current_scene)
	
	# Start the fade-in effect
	fade_in()

# Fade-in function to gradually show the new scene
func fade_in():
	fade_rect.color.a = 1  # Ensure start of fade-in is fully opaque?
	
	# Create a new tween for the fade-in effect
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, fade_duration)
	
	# Once fade-in completes, hide the fade_rect
	tween.tween_callback(self._on_fade_in_complete)

func _on_fade_in_complete():
	# hide the fade_rect after fade-in completes
	fade_rect.visible = false  # Hide the overlay once fade-in is done
