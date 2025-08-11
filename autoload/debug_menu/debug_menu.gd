class_name DebugMenuType extends CanvasLayer

@export var to_game_level_button: Button

var player_ref: Player = null

func _ready() -> void:
	visible = false
	to_game_level_button.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://levels/the_building/the_building.tscn")
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_menu") and EnvManager.can_debug():
		visible = not visible
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
