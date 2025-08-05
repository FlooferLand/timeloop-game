extends Node

@export var color := Color.BLACK

@export_group("Local")
@export var canvas_layer: CanvasLayer
@export var color_rect: ColorRect

func _enter_tree() -> void:
	color_rect.color = color
	canvas_layer.visible = true
