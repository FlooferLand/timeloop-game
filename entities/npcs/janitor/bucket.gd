extends Node2D

@export var janitor: Janitor

@export_group("Local")
@export var item: InventoryItem
@export var interact_comp: InteractComponent
@export var dialog_comp: DialogComponent

func _ready() -> void:
	interact_comp.on_player_interact.connect(func(player: Player) -> void:
		if janitor.eeping:
			player.inventory_comp.add_item(item)
			queue_free()
		else:
			dialog_comp.start()
	)
