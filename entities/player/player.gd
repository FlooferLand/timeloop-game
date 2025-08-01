class_name Player extends CharacterBody2D
enum Facing { Left, Right }

signal change_direction(facing: Facing)

const SPEED := 600.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var sprite: AnimatedSprite2D
@export var current_room: Room

var move_direction := Vector2.ZERO
var facing := Facing.Right
var can_move := true
var is_looking := false
var mouse_locked := true:
	get(): return mouse_locked
	set(value):
		mouse_locked = value
		if mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		else:
			Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE

func _ready() -> void:
	(DialogManager as DialogManagerType).player_ref = self
	mouse_locked = true
	change_direction.connect(func(facing: Facing):
		sprite.flip_h = (facing == Facing.Left)
	)

func _process(delta: float) -> void:
	move_direction = Vector2.ZERO
	if can_move:
		move_direction = Vector2.RIGHT * Input.get_axis("walk_left", "walk_right")
	
	# Animations
	if move_direction.length() > 0:
		sprite.play("walk")
	elif is_looking:
		sprite.animation = "look"
	else:
		sprite.animation = "idle"
	
	if move_direction.x < 0 and facing == Facing.Right:
		facing = Facing.Left
		change_direction.emit(facing)
	elif move_direction.x > 0 and facing == Facing.Left:
		facing = Facing.Right
		change_direction.emit(facing)

func _physics_process(delta: float) -> void:
	var motion := Vector2.ZERO
	
	motion += move_direction * SPEED
	if not is_on_floor():
		motion.y += gravity
	
	velocity = motion
	move_and_slide()
