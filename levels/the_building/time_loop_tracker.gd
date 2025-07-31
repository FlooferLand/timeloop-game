extends CanvasLayer

# TODO: Move time loop management away from this

@export_group("Local")
@export var music: AudioStreamPlayer
@export var counter_label: Label

const MAX_TIME := 60

var music_stream: AudioStreamInteractive
var music_playback: AudioStreamPlaybackInteractive
var music_stages := 0.0
var counter := 0.0

func _ready() -> void:
	music.play()
	music_stream = music.stream
	music_playback = music.get_stream_playback()
	music_playback.switch_to_clip(0)
	music_stages = music_stream.clip_count

func _process(delta: float) -> void:
	counter += delta
	var stage: int = remap(counter, 0, MAX_TIME, 0, music_stages)
	if stage > music_stages:
		stage = 0
		counter = MAX_TIME
		print("TIME LOOP!")
	if stage > music_playback.get_current_clip_index():
		music_playback.switch_to_clip(stage)
	counter_label.text = "Time left: %s" % (MAX_TIME - counter)
