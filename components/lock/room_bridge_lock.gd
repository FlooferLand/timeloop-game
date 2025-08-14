class_name RoomBridgeLock extends Node2D

@export var enabled := true:
	get(): return enabled
	set(value):
		bridge.locked = value
@export var unlock_item: InventoryItem = null

@export_group("Local")
@export var interact_comp: InteractComponent

var bridge: RoomBridge

func _enter_tree() -> void:
	set_process(false)
	set_process_input(false)
	bridge = get_parent() as RoomBridge
	bridge.locked = true
	interact_comp.interact_condition = func(player: Player) -> bool:
		return enabled
	interact_comp.on_player_interact.connect(func(player: Player) -> void:
		if player.inventory_comp.has_item(unlock_item.id):
			bridge.locked = false
			player.inventory_comp.remove_item(unlock_item)
			queue_free()
	)
	bridge.redraw_lock.connect(_update_lock_display)
	_update_lock_display()

func _exit_tree() -> void:
	push_warning("Room bridge lock was deleted. This is deprecated behaviour and will be removed soon, set \"enabled\" to false!")
	enabled = false

func _update_lock_display() -> void:
	if not enabled:
		return
	if unlock_item == null:
		interact_comp.type = InteractComponent.Type.Locked
		return
	interact_comp.type = InteractComponent.Type.Unlock
	interact_comp.set_postfix("(Requires %s)" % unlock_item.name)
