@tool extends Node2D

@export var right: int:
	set(value):
		right = value
		queue_redraw()
@export var top: int:
	set(value):
		top = value
		queue_redraw()

func _enter_tree() -> void:
	queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	draw_line(Vector2(right, 100), Vector2(right, -1300), Color.SKY_BLUE, 5.0, true)
	draw_line(Vector2(0, -top), Vector2(right, -top), Color.LAWN_GREEN, 5.0, true)
