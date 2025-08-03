extends Node2D

const TimeLoopContainer := preload("uid://dhy8a74fxl1iw")

func _ready() -> void:
	TimeManager.start()
	TimeManager.reset.connect(func():
		await time_loop_reset()
	)

func time_loop_reset() -> void:
	# Cleanup
	for child in get_children():
		child.queue_free()
	await get_tree().process_frame
	
	# Adding the new stuffs
	var virtual := TimeLoopContainer.instantiate()
	for child in virtual.get_children():
		virtual.remove_child(child)
		add_child(child)
	virtual.queue_free()
