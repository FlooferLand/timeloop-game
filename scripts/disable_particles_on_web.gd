extends GPUParticles2D

func _enter_tree() -> void:
	if OS.has_feature("web"):
		emitting = false
		queue_free()
