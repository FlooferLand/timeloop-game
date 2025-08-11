## Manages the time loop world.
## Not affected by the time loop itself, but its used to allow communication
## with the outside world (the one not affected by the time loop).
## It can also be used to persist data between loops
class_name TimeLoopContainer extends Node2D

const TimeLoopContainerScene := preload("uid://dhy8a74fxl1iw")

## Reference is persistent across loops
@export var player: Player

@export_group("Local")  ## Must be re-set inside time_loop_reset
@export var room_manager: RoomManager

func _ready() -> void:
	TimeManager.start()
	TimeManager.reset.connect(func() -> void:
		var old_room := player.current_room_id
		
		## Reset everything.
		await time_loop_reset()

		var room := room_manager.get_node_or_null(str(old_room))
		if room != null:
			room_manager.default = room
			room_manager.active = room
		else:
			push_warning("Room with name %s not found while resetting." % str(old_room))
	)

## Resets all of its contents
func time_loop_reset() -> void:
	# Cleanup
	for child in get_children():
		child.queue_free()
	await get_tree().process_frame
	
	# Adding the new stuffs
	var virtual: TimeLoopContainer = TimeLoopContainerScene.instantiate()
	for child in virtual.get_children():
		virtual.remove_child(child)
		child.owner = null
		add_child(child)
		if child is RoomManager:
			room_manager = child
	virtual.queue_free()
