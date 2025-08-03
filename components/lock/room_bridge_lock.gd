extends Node2D

@export var unlock_item: InventoryItem = null

@export_group("Local")
@export var interact_comp: InteractComponent

var bridge: RoomBridge

func _enter_tree() -> void:
	set_process(false)
	set_process_input(false)
	bridge = get_parent() as RoomBridge
	bridge.locked = true
	interact_comp.on_player_interact.connect(func(player: Player):
		if player.inventory_comp.has_item(unlock_item.id):
			bridge.locked = false
			player.inventory_comp.remove_item(unlock_item)
			queue_free()
	)
	bridge.redraw_lock.connect(_update_lock_display)
	_update_lock_display()

func _exit_tree() -> void:
	bridge.locked = false

func _update_lock_display() -> void:
	if unlock_item == null:
		return
	interact_comp.set_postfix("(Requires %s)" % unlock_item.name)
