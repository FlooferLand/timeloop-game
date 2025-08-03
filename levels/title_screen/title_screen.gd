extends Node2D

@export var navcom_voice: AudioStreamPlayer
@export var radio_noise: AudioStreamPlayer

func _ready():
	get_tree().create_timer(4.0).timeout.connect(func():
		navcom_voice.play()
	)
	get_tree().create_timer(2.0).timeout.connect(func():
		radio_noise.play()
	)

func _on_play_game_pressed() -> void:
	get_tree().change_scene_to_file("uid://cjgtv4eflexi6")

func _on_quit_pressed() -> void:
	get_tree().quit()
