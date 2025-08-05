extends Node2D

const IntroScene := preload("uid://cjgtv4eflexi6")

@export var navcom_voice: AudioStreamPlayer
@export var radio_noise: AudioStreamPlayer
@export var anim_player: AnimationPlayer
@export var respond_button: Button

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().create_timer(4.0).timeout.connect(func() -> void:
		navcom_voice.play()
	)
	get_tree().create_timer(2.0).timeout.connect(func() -> void:
		radio_noise.play()
	)
	anim_player.animation_finished.connect(func(anim_name: String) -> void:
		if anim_name == "respond":
			get_tree().change_scene_to_packed(IntroScene)
	)

func _on_play_game_pressed() -> void:
	anim_player.play("respond")
	respond_button.disabled = true

func _on_quit_pressed() -> void:
	get_tree().quit()
