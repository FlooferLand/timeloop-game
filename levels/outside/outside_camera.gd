@tool extends Camera2D

@export var target: Marker2D = null

func _enter_tree() -> void:
	if target != null:
		global_position = target.global_position
	if not Engine.is_editor_hint():
		make_current()

func _process(delta: float) -> void:
	if target == null: return
	global_position = global_position.lerp(target.global_position, 4.0 * delta)
