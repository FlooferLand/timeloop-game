class_name Room
extends Node2D

@export_group("Local")
@export var bounds: RoomBounds

var manager: RoomManager  ## Injected by RoomManager
var initially_active := false

func _enter_tree() -> void:
	manager = get_parent() as RoomManager
	modulate = Color.WHITE if initially_active else Color.BLACK
	visible = initially_active
	#print("MY NAME IS %s, I MADE THE MIMIC. IT WAS DIFFICULT TO PUT THE ROOMS TOGETHER" % name)
