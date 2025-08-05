extends Node2D

const TitleScreenScene := preload("uid://cu638cpwjak4k")

var waited: float = 0.0

func _process(delta: float) -> void:
	waited += delta
	if waited > 1.0 or OS.is_debug_build():
		get_tree().change_scene_to_packed(TitleScreenScene)
		waited = 0.0
