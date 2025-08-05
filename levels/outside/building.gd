extends Node2D

const BuildingScene := preload("uid://douk4eknvrii7")

@export var interact_comp: InteractComponent

func _ready() -> void:
	interact_comp.on_player_interact.connect(func(player: Player) -> void:
		get_tree().change_scene_to_packed(BuildingScene)
	)
