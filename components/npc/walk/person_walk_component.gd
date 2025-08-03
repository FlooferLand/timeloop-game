class_name PersonWalkComponent extends Node2D

const PAD := 5.0  ## Used to allow error for the position

signal on_arrived(target: Marker2D)

@export var sprite: AnimatedSprite2D
@export var parent: Node2D  ## The node to walk
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

func _physics_process(delta: float) -> void:
	if target == null or arrived or paused:
		return
	var target_pos := target.global_position
	
	# Calculating movement
	velocity = Vector2.ZERO
	if parent.global_position.x - PAD > target_pos.x:
		velocity.x -= speed * delta
	elif parent.global_position.x + PAD < target_pos.x:
		velocity.x += speed * delta
	else:
		arrived = true
		on_arrived.emit(target)
	
	# Applying movement
	parent.global_position += velocity

func _process(delta: float) -> void:
	if sprite == null or paused:
		return
	
	# Animation
	var anim_name := ""
	if velocity.length() > 0:
		anim_name = "walk"
	else:
		anim_name = "idle"
	
	var postfix: String = (("_%s" % _sprite_postfix) if not _sprite_postfix.is_empty() else "")
	sprite.play(anim_name + postfix)
	sprite.flip_h = (velocity.x > 0) if sprite_flip_h else (velocity.x < 0)

func set_sprite_postfix(postfix: String) -> void:
	_sprite_postfix = postfix
