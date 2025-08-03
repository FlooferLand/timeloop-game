extends AnimatedSprite2D

@export var child: AnimatedSprite2D

func _ready() -> void:
	play("idle")
	child.play("idle")

func _process(delta: float) -> void:
	const val := 300.0
	child.position = child.position.lerp(
		Vector2(randf_range(-val, val), randf_range(-val, val)),
		1.1 * delta
	)
	var alpha: float = max(0.1, sin(Time.get_ticks_msec() * 0.01) * 0.8)
	self_modulate = Color(1.0, 1.0, 1.0, alpha)
