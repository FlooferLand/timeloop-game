class_name FootstepComponent
extends Node2D

@export var is_local := false
@export var sounds: AudioStreamRandomizer:
	set(value):
		sounds = value
		if audio_player != null:
			audio_player.stream = sounds

@export_group("Local")
@export var audio_player: AudioStreamPlayer2D
@export var timer: Timer
@export var particles: GPUParticles2D

var _playing := false
var _initial_wait_time: float

func _ready() -> void:
	_initial_wait_time = timer.wait_time
	audio_player.stream = sounds
	timer.timeout.connect(func() -> void:
		audio_player.play()
		particles.restart()
	)
	if is_local:
		audio_player.panning_strength = 0

func play() -> void:
	audio_player.play()
	timer.start()
	_playing = true

func stop() -> void:
	timer.stop()
	_playing = false

func is_playing() -> bool:
	return _playing

# NOTE: This gets called constantly. Probably not good for performance-
func set_speed(speed: float) -> void:
	particles.modulate = (Color.WHITE.lerp(Color.TRANSPARENT, 0.85 - ((speed-1) * 0.6)))
	timer.wait_time = _initial_wait_time / max(speed, 0.0)
