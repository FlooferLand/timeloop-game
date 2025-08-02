class_name InventoryItemSlot extends Control

@export_group("Local")
@export var texture_rect: TextureRect

var item: InventoryItem = null

func set_item(item: InventoryItem) -> void:
	texture_rect.texture = item.image
	self.item = item

func is_item(item: InventoryItem) -> bool:
	return item.id == item.id
