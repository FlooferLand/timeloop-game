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
	sprite.animation_finished.connect(func():
		if sprite.animation == "turn_off":
			ending_sound_player.play()
			black_screen.visible = true
	)
	ending_sound_player.finished.connect(func():
		get_tree().change_scene_to_packed(TitleScreenScene)
	)

func _input(event: InputEvent) -> void:
	if anim_player.is_playing():
		return
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.pressed:
			sprite.play("turn_off")
