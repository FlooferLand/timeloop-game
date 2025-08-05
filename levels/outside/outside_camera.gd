@tool extends Camera2D

@export var target: Marker2D = null

var precise_follow_time := 0.5

func _ready() -> void:
	if target != null:
		global_position = target.global_position
	if not Engine.is_editor_hint():
		make_current()

func _physics_process(delta: float) -> void:
	if target == null: return
	if precise_follow_time > 0.0:
		global_position = target.global_position
		precise_follow_time -= delta
	global_position = global_position.lerp(target.global_position, 4.0 * delta)
