extends Node2D

const IntroScene := preload("uid://cjgtv4eflexi6")

@export var navcom_voice: AudioStreamPlayer
@export var music: AudioStreamPlayer
@export var radio_noise: AudioStreamPlayer
@export var anim_player: AnimationPlayer
@export var respond_button: Button
@export var title_label: Label
@export var version_label: Label
@export var background: TextureRect

var music_playback: AudioStreamPlaybackInteractive

func _ready() -> void:
	version_label.text = "v%s" % ProjectSettings.get_setting("application/config/version")
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

func _process(delta: float) -> void:
	# This crashes Godot on web lmao
	if not OS.has_feature("web"):
		var font := (title_label.label_settings.font as FontVariation)
		font.variation_embolden = 0.85 + (sin(Time.get_ticks_msec() * 0.003) * 0.3)
	
	var bg_scale := 1.03 + (sin(Time.get_ticks_msec() * 0.001) * 0.02)
	var bg_rotation := sin(Time.get_ticks_msec() * 0.002) * 0.1
	background.scale = Vector2(bg_scale, bg_scale)
	background.rotation_degrees = bg_rotation * 5

func _input(event: InputEvent) -> void:
	if EnvManager.can_debug() and event.is_action_pressed("skip"):
		_start_game()

func _start_game() -> void:
	GameStorage.reset()
	SessionStorage.times_played += 1
	if SessionStorage.times_played > 1:
		NGTyped.instance.event_log("played_again_same_session")
		for medal in await NGTyped.instance.medal_get_list():
			if medal.id == NewgroundsIds.MedalId.BeatTheGame and medal.unlocked:
				NGTyped.instance.event_log("played_again")
	NGTyped.instance.event_log("times_played")
	get_tree().change_scene_to_packed(IntroScene)

func _on_play_game_pressed() -> void:
	anim_player.play("respond")
	respond_button.disabled = true
	music_playback.switch_to_clip(2)

func _on_quit_pressed() -> void:
	if not OS.has_feature("web"):
		get_tree().quit()
