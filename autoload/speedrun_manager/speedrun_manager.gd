class_name SpeedrunManagerType extends Node

## The time in seconds
var time: float = 0.0

## Whenever the counter is running or not
var running: bool = false

func start_timer() -> void:
	running = true
	time = 0.0

func stop_timer() -> void:
	running = false

func _process(delta: float) -> void:
	if running:
		time += delta
