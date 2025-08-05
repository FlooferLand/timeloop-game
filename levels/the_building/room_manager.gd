class_name RoomManager extends Node2D

## Triggered when the room is done changing
signal room_changed(old: Room, new: Room)

@export var default: Room

var _active: Room
var trans_old: Tween = null
var trans_new: Tween = null
var rooms: Array[Room] = []

var active: Room:
	get: return _active
	set(value): change(value)

func _enter_tree() -> void:
	default.initially_active = true
	for thing in get_children():
		if thing is Room:
			rooms.push_back(thing)
			thing.set("manager", self)
		elif thing is RoomBridge:
			thing.set("manager", self)
	_active = default

func change(new: Room) -> void:
	var old := _active
	_active = new
	
	if trans_old != null:
		old.modulate = Color.WHITE
		old.visible = true
		trans_old.kill()
		trans_old = null
	trans_old = old.create_tween()
	trans_old.tween_property(old, "modulate", Color.BLACK, 0.1)
	trans_old.tween_callback(func() -> void:
		old.visible = false
		room_changed.emit(old, new)
		trans_old.kill()
		trans_old = null
	)
	
	if trans_new != null:
		new.modulate = Color.WHITE
		new.visible = true
		trans_new.kill()
		trans_new = null
	trans_new = new.create_tween()
	trans_new.tween_property(new, "modulate", Color.WHITE, 0.3)
	trans_new.tween_callback(func() -> void:
		new.visible = true
		trans_new.kill()
		trans_new = null
	)
