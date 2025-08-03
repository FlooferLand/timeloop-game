extends Node2D

@export var anim_player: AnimationPlayer

func _ready() -> void:
	anim_player.play("ending")
