class_name InventoryComponent extends Node

signal item_added(item: InventoryItem)
signal item_removed(item: InventoryItem) 

@export var default: Array[InventoryItem] = []

var _inv: Array[InventoryItem] = []

func add_item(item: InventoryItem) -> void:
	_inv.push_back(item)
	item_added.emit(item)

func remove_item(item: InventoryItem) -> void:
	var found_index: int = find_item_index(item.id)
	if found_index != -1:
		item_removed.emit(item)
		print("Removing item of ID '%s', name '%s'" % [item.id, item.name])
		_inv.remove_at(found_index)
	else:
		push_error("Failed to remove item '%s' from inventory" % item.name)

func has_item(id: InventoryItem.Id) -> bool:
	return find_item(id) != null

## Returns null if no item was found
func find_item(id: InventoryItem.Id) -> InventoryItem:
	var found := find_item_index(id)
	if found != -1:
		return _inv[found]
	return null

## Returns -1 if no item was found
func find_item_index(id: InventoryItem.Id) -> int:
	for i in range(_inv.size()):
		if _inv[i].id == id:
			return i
	return -1

func size() -> int:
	return _inv.size()
