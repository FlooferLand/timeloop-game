extends CanvasLayer

## TODO: Make it not skip the ENTIRE cutscene

const BuildingScene := preload("uid://douk4eknvrii7")

const TIMES_TO_PRESS: int = 8

@export var skip_feedback: AudioStreamPlayer

var times_pressed: int = 0

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("skip_cutscene"):
		times_pressed += 1
		skip_feedback.play()
		skip_feedback.pitch_scale += 0.1
		skip_feedback.volume_db += 0.1
		if times_pressed >= TIMES_TO_PRESS:
			get_tree().change_scene_to_packed(BuildingScene)
