class_name BobPrank extends Area2D

signal dude_got_pranked

@export_group("Local")
@export var item: InventoryItem
@export var interact_comp: InteractComponent
@export var dialog_comp: DialogComponent
@export var content: Node2D

var armed := false
var too_late := false

func _enter_tree() -> void:
	content.visible = false
	interact_comp.set_postfix(item.name)
	interact_comp.interact_condition = func(player: Player) -> bool:
		return player.inventory_comp.has_item(item.id) and not armed
	interact_comp.on_player_interact.connect(func(player: Player):
		if not too_late:
			player.inventory_comp.remove_item(item)
			content.visible = true
			interact_comp.hide_info()
			armed = true
		else:
			dialog_comp.start()
	)

## Called by Bob when the prank is triggered
func triggered() -> void:
	content.visible = false
	dude_got_pranked.emit()
