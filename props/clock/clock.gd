@tool extends Node2D

@export_group("Local")
@export var hand_color: Color

var time_manager := TimeManager as TimeManagerType

var current_hour := TimeManager.START_PM

func _ready() -> void:
	queue_redraw()
	if not Engine.is_editor_hint():
		time_manager.time_advanced.connect(func(new_hour: int) -> void:
			current_hour = new_hour
			await get_tree().create_timer(randf() * 0.4).timeout
			queue_redraw()
		)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var hour_hand := (Vector2.UP * 80).rotated(
		remap(current_hour, TimeManager.START_PM, TimeManager.END_PM, PI * 0.1, PI * 1.25)
	)
	draw_line(Vector2.ZERO, hour_hand, hand_color, 5, true)
