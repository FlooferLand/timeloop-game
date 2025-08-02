extends CanvasLayer

# TODO: Move time loop management away from this

@export_group("Local")
@export var music: AudioStreamPlayer
@export var reset_layer: CanvasLayer
@export var reset_anim: AnimationPlayer
@export var counter_label: Label

var music_stream: AudioStreamInteractive
var music_playback: AudioStreamPlaybackInteractive
var music_stages := 0.0

func _ready() -> void:
	music.play()
	music_stream = music.stream
	music_playback = music.get_stream_playback()
	music_playback.switch_to_clip(0)
	music_stages = music_stream.clip_count
	reset_layer.visible = false
	(TimeManager as TimeManagerType).prereset.connect(func():
		reset_anim.play("time_loop_prereset")
	)
	(TimeManager as TimeManagerType).reset.connect(func():
		reset_anim.play("time_loop_reset")
	)

func _process(delta: float) -> void:
	var stage: int = remap(TimeManager.counter, 0, TimeManager.MAX_TIME, 0, music_stages)
	if stage >= music_stages:
		return
	if music_playback.get_current_clip_index() != stage:
		music_playback.switch_to_clip(stage)
	counter_label.text = "%s PM" % TimeManager.time
