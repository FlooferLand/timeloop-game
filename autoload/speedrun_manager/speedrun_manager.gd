class_name SpeedrunManagerType extends Node

var time: float = 0.0
var running: bool = false

func start_timer() -> void:
	running = true

func stop_timer() -> void:
	running = false
	time = 0.0

func _process(delta: float) -> void:
	if running:
		time += delta
