extends CanvasLayer

const ItemSlotScene := preload("uid://djfmkk5rkgrq1")

@export var inventory_comp: InventoryComponent
@export var slot_container: BoxContainer

func _enter_tree() -> void:
	visible = inventory_comp.default.size() > 0
	inventory_comp.item_added.connect(func(item: InventoryItem):
		var slot: InventoryItemSlot = ItemSlotScene.instantiate()
		slot.set_item(item)
		slot_container.add_child(slot)
		visible = true
	)
	inventory_comp.item_removed.connect(func(item: InventoryItem):
		for slot: InventoryItemSlot in slot_container.get_children():
			if slot.is_item(item):
				slot.queue_free()
				break
		visible = inventory_comp.size() > 0
	)

func _process(delta: float) -> void:
	pass
