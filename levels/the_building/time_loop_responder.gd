extends Node2D

const RoomManagerScene := preload("uid://byw5ec70c2cga")

func _ready() -> void:
	TimeLoopManager.reset.connect(func():
		await time_loop_reset()
	)

func time_loop_reset() -> void:
	# Cleanup
	for child in get_children():
		child.queue_free()
	await get_tree().process_frame
	
	# Adding the new stuffs
	var room_manager := RoomManagerScene.instantiate()
	add_child(room_manager)
