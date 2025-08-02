extends Node2D

@export_group("Local")
@export var dialog_comp: DialogComponent
@export var interact_comp: InteractComponent
@export var paper_item: InventoryItem

func _ready() -> void:
	var dialog_manager := DialogManager as DialogManagerType
	dialog_manager.action_event.connect(func(event_name: String):
		if event_name == "give_document" and dialog_comp.active:
			interact_comp.current_player.inventory_comp.add_item(paper_item)
	)
