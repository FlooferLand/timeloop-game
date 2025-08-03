extends CanvasLayer

# TODO: Move time loop management away from this

@export_group("Local")
@export var music: AudioStreamPlayer
@export var reset_layer: CanvasLayer
@export var reset_anim: AnimationPlayer
@export var counter_label: Label
@export var chime_audio_player: AudioStreamPlayer
@export var dev_time_speedup: Label

var music_stream: AudioStreamInteractive
var music_playback: AudioStreamPlaybackInteractive
var music_stages := 0.0
var time_manager: TimeManagerType

func _ready() -> void:
	music.play()
	music_stream = music.stream
	music_playback = music.get_stream_playback()
	music_playback.switch_to_clip(0)
	music_stages = music_stream.clip_count
	reset_layer.visible = false
	dev_time_speedup.visible = false
	time_manager = (TimeManager as TimeManagerType)
	time_manager.prereset.connect(func():
		reset_anim.play("time_loop_prereset")
	)
	time_manager.reset.connect(func():
		reset_anim.play("time_loop_reset")
	)
	time_manager.time_advanced.connect(func(new_hour: int):
		if new_hour == time_manager.START_PM:
			return
		chime_audio_player.volume_linear = remap(new_hour, time_manager.START_PM+1, time_manager.END_PM, 0.15, 1.0)
		chime_audio_player.play()
	)
	time_manager.dev_time_speedup.connect(func(enabled: bool):
		dev_time_speedup.visible = enabled
	)

func _process(delta: float) -> void:
	var stage: int = remap(TimeManager.counter, 0, TimeManager.MAX_TIME, 0, music_stages)
	if stage >= music_stages:
		return
	if music_playback.get_current_clip_index() != stage:
		music_playback.switch_to_clip(stage)
	counter_label.text = "%s PM" % TimeManager.time
