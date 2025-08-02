class_name InventoryComponent extends Node

signal item_added(item: InventoryItem)
signal item_removed(item: InventoryItem) 

@export var default: Array[InventoryItem] = []

var _inv: Array[InventoryItem] = []

func add_item(item: InventoryItem) -> void:
	_inv.push_back(item)
	item_added.emit(item)

func remove_item(item: InventoryItem) -> void:
	var found_index: int = -1
	for i in len(_inv):
		if _inv[i].id == item.id:
			found_index = i
			break
	if found_index != -1:
		item_removed.emit(item)
		_inv.remove_at(found_index)
	else:
		push_error("Failed to remove item '%s' from inventory" % item.name)

func size() -> int:
	return _inv.size()
