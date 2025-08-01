class_name Room
extends Node2D

var manager: RoomManager  # Injected by RoomManager
var active := false

func _enter_tree() -> void:
	manager = get_parent() as RoomManager
	modulate = Color.WHITE if active else Color.BLACK
	visible = active
	#print("MY NAME IS %s, I MADE THE MIMIC. IT WAS DIFFICULT TO PUT THE ROOMS TOGETHER" % name)
