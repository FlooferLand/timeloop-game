extends Node2D

const ElevatorRideScene := preload("res://levels/elevator_ride/elevator_ride.tscn")

@export_group("Local")
@export var interact_comp: InteractComponent

func _ready() -> void:
	interact_comp.on_player_interact.connect(func(player: Player) -> void:
		GameStorage.will_have_bnnuy_in_elevator = (player.inventory_comp.has_item(InventoryItem.Id.ManagersPlushie))
		get_tree().change_scene_to_packed(ElevatorRideScene)
	)
