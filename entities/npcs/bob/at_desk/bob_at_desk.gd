class_name BobAtDesk extends Node2D

@export var bob_complain_target: Marker2D
@export var bob_container: Node2D

@export_group("Local")
@export var bob_sprite: AnimatedSprite2D
@export var bob_desk_pos: Marker2D

const WalkingBobScene := preload("uid://bf7rxnp4ms8us")

var walking_bob: WalkingBob = null

func _ready() -> void:
	TimeManager.time_advanced.connect(func(new_hour: int):
		match new_hour:
			4:
				walking_bob = WalkingBobScene.instantiate()
				walking_bob.global_position = bob_desk_pos.global_position
				walking_bob.desk_self = self
				walking_bob.go_complain(bob_complain_target)
				bob_container.add_child(walking_bob)
				bob_sprite.visible = false
	)
