class_name Room
extends Node2D

signal entity_entered(entity: CharacterBody2D)
signal entity_exited(entity: CharacterBody2D)

@export_group("Local")
@export var bounds: RoomBounds

var id: String:
	get(): return name

var manager: RoomManager  ## Injected by RoomManager
var initially_active := false
var active: bool:
	get: return manager.active == self
	set(value):
		if value:
			manager.active = self
		else:
			push_error("room.gd:set_active(false) is not implemented")

func _enter_tree() -> void:
	manager = get_parent() as RoomManager
	modulate = Color.WHITE if initially_active else Color.BLACK
	visible = initially_active
	#print("MY NAME IS %s, I MADE THE MIMIC. IT WAS DIFFICULT TO PUT THE ROOMS TOGETHER" % name)
