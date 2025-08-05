class_name PropComputer extends Node2D

@export_group("Local")
@export var light: Light2D
@export var random_energy_timer: Timer

var _initial_energy: float
var next_random_energy := 1.0

func _ready() -> void:
	_initial_energy = light.energy
	random_energy_timer.timeout.connect(func() -> void:
		next_random_energy = randf_range(_initial_energy - 0.1, _initial_energy + 0.15)
	)

func _process(delta: float) -> void:
	light.energy = lerp(light.energy, next_random_energy, 4.0 * delta)

func turn_on() -> void:
	await get_tree().create_timer(0.35).timeout
	light.visible = true

func turn_off() -> void:
	light.visible = false
