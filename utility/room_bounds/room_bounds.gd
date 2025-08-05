@tool class_name RoomBounds extends Node2D

@export var right: int:
	set(value):
		right = value
		queue_redraw()
@export var top: int:
	set(value):
		top = value
		queue_redraw()

@export_group("Local")
@export var screen_notifier: VisibleOnScreenNotifier2D

@onready var room: Room = get_parent()

func _enter_tree() -> void:
	queue_redraw()
	screen_notifier.rect = Rect2(
		0, -top,
		right, top
	)

func _ready() -> void:
	screen_notifier.screen_entered.connect(func() -> void:
		room.visible = (room.manager.active == room)
	)
	screen_notifier.screen_exited.connect(func() -> void:
		room.visible = (room.manager.active == room)
	)

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	draw_line(Vector2(right, 100), Vector2(right, -1300), Color.SKY_BLUE, 5.0, true)
	draw_line(Vector2(0, -top), Vector2(right, -top), Color.LAWN_GREEN, 5.0, true)
