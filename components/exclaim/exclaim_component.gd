class_name ExclaimComponent extends Node2D

func _enter_tree() -> void:
	visible = false

func enable() -> void:
	visible = true

func disable() -> void:
	visible = false
