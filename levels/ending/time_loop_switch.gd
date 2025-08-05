extends Area2D

const TitleScreenScene := preload("uid://cu638cpwjak4k")

@export var anim_player: AnimationPlayer
@export var sprite: AnimatedSprite2D

@export var ending_sound_player: AudioStreamPlayer
@export var black_screen: CanvasLayer

func _enter_tree() -> void:
	black_screen.visible = false
	sprite.animation = "idle"
	sprite.frame = 0
	sprite.animation_finished.connect(func() -> void:
		if sprite.animation == "turn_off":
			ending_sound_player.play()
			black_screen.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	)
	ending_sound_player.finished.connect(func() -> void:
		get_tree().change_scene_to_packed(TitleScreenScene)
	)
	anim_player.animation_finished.connect(func(anim_name: String) -> void:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	)

func _input(event: InputEvent) -> void:
	if anim_player.is_playing():
		return
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.pressed:
			sprite.play("turn_off")
	elif event is InputEventJoypadButton:
		var button := event as InputEventJoypadButton
		if button.pressed:
			sprite.play("turn_off")
