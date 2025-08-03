extends Node2D

@export var managers_desk_target: Marker2D
@export var bridge_door: RoomBridge

@export_group("Local")
@export var walk_comp: PersonWalkComponent

@onready var time_manager: TimeManagerType = TimeManager

func _ready() -> void:
	time_manager.time_advanced.connect(func(new_hour: int):
		if new_hour == TimeTable.MANAGER_GO_TO_DESK:
			walk_comp.target = managers_desk_target
	)

func _process(delta: float) -> void:
	if global_position.x > bridge_door.global_position.x and bridge_door.locked:
		bridge_door.locked = false
