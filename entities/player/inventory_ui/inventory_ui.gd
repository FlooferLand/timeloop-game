extends CanvasLayer

const ItemSlotScene := preload("uid://djfmkk5rkgrq1")

@onready var dialog_manager := DialogManager as DialogManagerType

@export var inventory_comp: InventoryComponent
@export var slot_container: BoxContainer

var in_dialog := false

func _ready() -> void:
	visible = inventory_comp.default.size() > 0
	inventory_comp.item_added.connect(func(item: InventoryItem):
		_rebuild_slots()
	)
	inventory_comp.item_removed.connect(func(item: InventoryItem):
		_rebuild_slots()
	)
	dialog_manager.dialog_opened.connect(func():
		in_dialog = true
		_update_visibility()
	)
	dialog_manager.dialog_closed.connect(func():
		in_dialog = false
		_update_visibility()
	)

func _rebuild_slots() -> void:
	_update_visibility()
	
	# Cleanup
	for child in slot_container.get_children():
		child.queue_free()
	await get_tree().process_frame
	
	# Adding slots
	for item in inventory_comp.inner:
		var slot: InventoryItemSlot = ItemSlotScene.instantiate()
		slot.set_item(item)
		slot_container.add_child(slot)
		visible = true

## Hide the inventory when unneeded / could be disrupting things
func _update_visibility() -> void:
	visible = inventory_comp.size() > 0 and not in_dialog
