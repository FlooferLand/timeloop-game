extends Node2D

const ElevatorRideScene := preload("uid://domjojwwk6q7d")

@export_group("Local")
@export var interact_comp: InteractComponent

func _ready() -> void:
	interact_comp.on_player_interact.connect(func(player: Player) -> void:
		get_tree().change_scene_to_packed(ElevatorRideScene)
	)
