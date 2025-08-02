@tool extends Node2D

@export var bridge: RoomBridge
@export var unlock_item: InventoryItem

@onready var interact_comp: InteractComponent = $InteractComponent

func _enter_tree() -> void:
	bridge.locked = true

func _exit_tree() -> void:
	bridge.locked = false

func _process(delta: float) -> void:
	pass
