class_name WalkingBob extends Node2D

@export_group("Local")
@export var walk_comp: PersonWalkComponent
@export var anim_player: AnimationPlayer
@export var anger_mark: AnimatedSprite2D
@export var prank_detector: Area2D

var desk_self: BobAtDesk

func _ready() -> void:
	position.y = 0  ## Hackiest fix known to alien-kind
	anim_player.play("RESET")
	anim_player.animation_finished.connect(func(anim_name: String):
		if anim_name == "complain":
			anim_player.play("RESET")
			anger_mark.visible = true
			walk_comp.target = desk_self.bob_desk_pos
		elif anim_name == "get_bucketed":  ## After he got bucketed
			await get_tree().create_timer(2.0).timeout
			walk_comp.target = desk_self.bob_desk_pos
			walk_comp.paused = false
	)
	walk_comp.on_arrived.connect(func(target: Marker2D):
		match target:
			desk_self.bob_complain_target:
				# Hehe..
				anim_player.play("complain")
				anger_mark.play()
			desk_self.bob_desk_pos:  ## Arrived back at his desk
				desk_self.bob_sprite.visible = true
				desk_self.bob_sprite.animation = "at_desk_bucketed"
				desk_self.dialog_comp.set_sprite_postfix("bucketed")
				queue_free()
	)
	prank_detector.area_entered.connect(func(area: Area2D):
		if area is BobPrank:
			var prank := area as BobPrank
			prank.too_late = true
			if prank.armed:  ## GET PRANKED BRO!!
				walk_comp.paused = true
				walk_comp.set_sprite_postfix("bucketed")
				anim_player.play("get_bucketed")
				prank.triggered()
	)

func go_complain(target: Marker2D) -> void:
	walk_comp.target = target
