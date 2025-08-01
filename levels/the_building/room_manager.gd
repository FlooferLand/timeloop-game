class_name RoomManager extends Node2D

const RoomManagerScene := preload("uid://byw5ec70c2cga")

## Triggered when the room is done changing
signal room_changed(old: Room, new: Room)

@export var default: Room

var _active: Room

var active: Room:
	get: return _active
	set(value): change(value)

func _enter_tree() -> void:
	default.active = true
	for thing in get_children():
		if thing is Room or RoomTransition:
			thing.set("manager", self)
	_active = default

func change(new: Room) -> void:
	var old := _active
	_active = new
	
	var trans_old := create_tween()
	trans_old.tween_property(old, "modulate", Color.BLACK, 0.4)
	trans_old.tween_callback(func():
		old.visible = false
		room_changed.emit(old, new)
		trans_old.kill()
	)
	
	var trans_new := create_tween()
	trans_new.tween_property(new, "modulate", Color.WHITE, 0.2)
	trans_new.tween_callback(func():
		new.visible = true
		trans_new.kill()
	)

## Time loop thingy!!
func time_loop_reset() -> void:
	# Cleanup
	for child in get_children():
		child.queue_free()
	await get_tree().process_frame
	
	# Adding the new stuffs
	var virtual := RoomManagerScene.instantiate()
	default.active = true
	for item in virtual.get_children():
		virtual.remove_child(item)
		add_child(item)
	virtual.queue_free()
