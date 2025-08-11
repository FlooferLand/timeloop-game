extends Node2D

const IntroScene := preload("uid://cjgtv4eflexi6")

@export var navcom_voice: AudioStreamPlayer
@export var music: AudioStreamPlayer
@export var radio_noise: AudioStreamPlayer
@export var anim_player: AnimationPlayer
@export var respond_button: Button

var music_playback: AudioStreamPlaybackInteractive

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	music_playback = music.get_stream_playback() as AudioStreamPlaybackInteractive
	get_tree().create_timer(4.0).timeout.connect(func() -> void:
		navcom_voice.play()
	)
	get_tree().create_timer(2.0).timeout.connect(func() -> void:
		radio_noise.play()
	)
	anim_player.animation_finished.connect(func(anim_name: String) -> void:
		if anim_name == "respond":
			_start_game()
	)

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("skip"):
		_start_game()

func _start_game() -> void:
	GameStorage.reset()
	get_tree().change_scene_to_packed(IntroScene)

func _on_play_game_pressed() -> void:
	anim_player.play("respond")
	respond_button.disabled = true
	music_playback.switch_to_clip(2)

func _on_quit_pressed() -> void:
	get_tree().quit()
