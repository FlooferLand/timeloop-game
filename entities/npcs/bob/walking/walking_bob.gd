class_name WalkingBob extends Node2D

@export_group("Local")
@export var walk_comp: PersonWalkComponent
@export var anim_player: AnimationPlayer
@export var anger_mark: AnimatedSprite2D

var desk_self: BobAtDesk

func go_complain(target: Marker2D) -> void:
	walk_comp.target = target

func _ready() -> void:
	anim_player.play("RESET")
	anim_player.animation_finished.connect(func(anim_name: String):
		if anim_name == "complain":
			anim_player.play("RESET")
			anger_mark.visible = true
			walk_comp.target = desk_self.bob_desk_pos
	)
	walk_comp.on_arrived.connect(func(target: Marker2D):
		match target:
			desk_self.bob_complain_target:
				# Hehe..
				anim_player.play("complain")
				anger_mark.play()
			desk_self.bob_desk_pos:
				desk_self.bob_sprite.visible = true
				queue_free()
	)
