extends AnimatedSprite2D

@export var child: AnimatedSprite2D

func _ready() -> void:
	play("idle")
	child.play("idle")

func _process(delta: float) -> void:
	const range := 300.0
	child.position = child.position.lerp(
		Vector2(randf_range(-range, range), randf_range(-range, range)),
		1.1 * delta
	)
	self_modulate = Color(1.0, 1.0, 1.0, max(0.1, sin(Time.get_ticks_msec() * 0.01) * 0.8))
