class_name DialogModifyItemAction extends DialogAction

enum Operation {
	Add,
	Remove
}

@export var item: InventoryItem
@export var operation: Operation
