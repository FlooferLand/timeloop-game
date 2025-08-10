class_name PersonWalkComponent extends Node2D

const PAD := 5.0  ## Used to allow error for the position

signal on_arrived(target: Marker2D)

@export var sprite: AnimatedSprite2D
@export var parent: CharacterBody2D  ## The node to walk
@export var speed: float = 500.0
@export var sprite_flip_h: bool = false

var target: Marker2D = null:
	get(): return target
	set(value):
		target = value
		arrived = false
var arrived := false
var paused := false
var velocity := Vector2.ZERO
var _sprite_postfix := ""

func _enter_tree() -> void:
	if parent.get_collision_mask_value(1) or parent.get_collision_layer_value(1):
		push_warning("World bit value enabled for NPC '%s'!" % parent.name)
		parent.set_collision_layer_value(1, false)
		parent.set_collision_mask_value(1, false)
	
	if parent.collision_mask != 0:
		push_warning("A collision layer is set for NPC '%s'! They should not collide with each other" % parent.name)
	
	if not parent.get_collision_mask_value(4) or not parent.get_collision_layer_value(4):
		push_warning("NPC bit value disabled for NPC '%s'!" % parent.name)
		parent.set_collision_layer_value(4, true)
		parent.set_collision_mask_value(4, false)
	
	if not parent.is_in_group("living_entity"):
		push_warning("Group 'living_entity' not set for NPC '%s'!" % parent.name)
		parent.is_in_group("living_entity")

func _physics_process(delta: float) -> void:
	if target == null or arrived or paused:
		return
	var target_pos := target.global_position
	
	# Calculating movement
	velocity = Vector2.ZERO
	if parent.global_position.x - PAD > target_pos.x:
		velocity.x -= speed
	elif parent.global_position.x + PAD < target_pos.x:
		velocity.x += speed
	else:
		arrived = true
		on_arrived.emit(target)
	
	# Applying movement
	parent.velocity = velocity
	parent.move_and_slide()

func _process(delta: float) -> void:
	if sprite == null or paused:
		return
	
	# Animation
	var anim_name := ""
	if velocity.length() > 0 and not paused:
		anim_name = "walk"
	else:
		anim_name = "idle"
	
	var postfix: String = (("_%s" % _sprite_postfix) if not _sprite_postfix.is_empty() else "")
	sprite.play(anim_name + postfix)
	sprite.flip_h = (velocity.x > 0) if sprite_flip_h else (velocity.x < 0)

func set_sprite_postfix(postfix: String) -> void:
	_sprite_postfix = postfix
