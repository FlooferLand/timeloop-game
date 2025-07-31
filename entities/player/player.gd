extends CharacterBody2D

const SPEED := 400.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_direction := Vector2.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	move_direction = Vector2.RIGHT * Input.get_axis("walk_left", "walk_right")

func _physics_process(delta: float) -> void:
	var motion := Vector2.ZERO
	
	motion += move_direction * SPEED
	if not is_on_floor():
		motion.y += gravity
	
	velocity = motion
	move_and_slide()
