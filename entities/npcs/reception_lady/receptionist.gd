extends Node2D

@export_group("Local")
@export var interact_comp: InteractComponent
@export var dialog_comp: DialogComponent
@export var ambient: AudioStreamPlayer2D
@export var sprite: AnimatedSprite2D

var speaking := false

func _ready() -> void:
	sprite.play("idle")
	interact_comp.on_player_interact.connect(func(player: Player):
		dialog_comp.start()
		ambient.stop()
	)
	dialog_comp.on_dialog_closed.connect(func():
		ambient.play()
		sprite.play("idle")
	)
	dialog_comp.change_animation.connect(func(anim_name: String):
		if speaking:
			sprite.play(anim_name)
		else:
			sprite.animation = anim_name
			sprite.frame = 0
	)
	dialog_comp.update_speaking.connect(func(speaking: bool):
		self.speaking = speaking
		if not speaking:
			sprite.stop()
			sprite.frame = 1
	)
