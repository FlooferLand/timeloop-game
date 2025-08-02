class_name PersonWalkComponent extends Node2D

const PAD := 5.0  ## Used to allow error for the position

signal on_arrived(target: Marker2D)

@export var sprite: AnimatedSprite2D
@export var parent: Node2D  ## The node to walk
@export var speed: float = 500.0

var target: Marker2D = null:
	get(): return target
	set(value):
		target = value
		arrived = false
var arrived := false
var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	if target == null or arrived:
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
	# Animation
	if velocity.length() > 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
	sprite.flip_h = (velocity.x < 0)
