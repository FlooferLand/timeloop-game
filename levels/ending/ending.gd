extends Node2D

@export var anim_player: AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	anim_player.play("ending")
