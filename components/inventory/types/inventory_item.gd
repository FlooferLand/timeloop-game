class_name InventoryItem extends Resource

enum Id {
	None,
	PipersDocument,
	WaterBucket
}

@export var id: Id
@export var name: String
@export var image: Texture2D
