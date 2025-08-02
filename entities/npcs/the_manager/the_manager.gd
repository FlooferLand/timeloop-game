extends Node2D

@export var managers_desk_target: Marker2D

@export_group("Local")
@export var walk_comp: PersonWalkComponent

@onready var time_manager: TimeManagerType = TimeManager

func _ready() -> void:
	time_manager.time_advanced.connect(func(new_hour: int):
		if new_hour == 5:
			walk_comp.target = managers_desk_target
	)

func _process(delta: float) -> void:
	pass
