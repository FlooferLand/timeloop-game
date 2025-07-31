class_name Player extends CharacterBody2D

const SPEED := 600.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var sprite: AnimatedSprite2D
@export var current_room: Room

var move_direction := Vector2.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	move_direction = Vector2.RIGHT * Input.get_axis("walk_left", "walk_right")
	
	# Animations
	if move_direction.length() > 0:
		sprite.play("walk")
	else:
		sprite.animation = "idle"
	
	if move_direction.x < 0:
		sprite.flip_h = true
	elif move_direction.x > 0:
		sprite.flip_h = false

func _physics_process(delta: float) -> void:
	var motion := Vector2.ZERO
	
	motion += move_direction * SPEED
	if not is_on_floor():
		motion.y += gravity
	
	velocity = motion
	move_and_slide()
