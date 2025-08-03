extends Node2D

@export var interact_comp: InteractComponent

func _ready() -> void:
	interact_comp.on_player_interact.connect(func(player: Player):
		get_tree().change_scene_to_file("uid://douk4eknvrii7")  ## The building level
	)
