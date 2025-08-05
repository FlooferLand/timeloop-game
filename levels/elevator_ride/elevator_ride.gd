extends Node2D

const EndingScene := preload("uid://bg25346p0d2vh")

@export var camera: Camera2D
@export var anim_player: AnimationPlayer

@export var camera_shake := false

func _ready() -> void:
	camera.make_current()
	anim_player.play("elevator_enter")
	anim_player.animation_finished.connect(func(anim_name: String) -> void:
		if anim_name == "elevator_enter":
			anim_player.play("elevator_ride")
		elif anim_name == "elevator_ride":
			get_tree().change_scene_to_packed(EndingScene)
	)

func _process(delta: float) -> void:
	var target := Vector2.ZERO
	if camera_shake:
		const range := 10.0
		target = Vector2(randf_range(-range, range), randf_range(-range, range))
	camera.offset = camera.offset.lerp(target, 8 * delta)
