class_name Player extends CharacterBody2D
enum Facing { Left, Right }

signal change_direction(facing: Facing)

const SPEED := 600.0
const SPRINT_MULTIPLIER := 1.6
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_group("Local")
@export var sprite: AnimatedSprite2D
@export var footstep_comp: FootstepComponent

var _initial_position: Vector2

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
var walking := false  ## True even when sprinting
var sprinting := false

func _ready() -> void:
	(DialogManager as DialogManagerType).player_ref = self
	_initial_position = global_position
	mouse_locked = true
	change_direction.connect(func(facing: Facing):
		sprite.flip_h = (facing == Facing.Left)
	)
	TimeLoopManager.reset.connect(func():
		global_position = _initial_position
	)

func _process(delta: float) -> void:
	move_direction = Vector2.ZERO
	if can_move:
		move_direction = Vector2.RIGHT * Input.get_axis("walk_left", "walk_right")
		sprinting = Input.is_action_pressed("sprint")
	walking = (move_direction.length() > 0 and velocity.length() > 0)
	
	# Footsteps
	if walking and not footstep_comp.is_playing():
		footstep_comp.play()
	elif not walking:
		footstep_comp.stop()
	footstep_comp.set_speed(SPRINT_MULTIPLIER if sprinting else 1.0)
	
	# Animations
	if walking:
		sprite.play("walk", SPRINT_MULTIPLIER if sprinting else 1.0)
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
	
	# Body tilt
	var body_tilt_amount := 0.03 if not sprinting else 0.05
	var body_tilt := (PI * body_tilt_amount if walking else 0.0) * (1.0 if facing == Facing.Right else -1.0)
	sprite.rotation = lerp(sprite.rotation, body_tilt, (4.0 if walking else 20.0) * delta)

func _physics_process(delta: float) -> void:
	var motion := Vector2.ZERO
	var speed := (SPEED * SPRINT_MULTIPLIER if sprinting else SPEED)
	
	motion += move_direction * speed
	if not is_on_floor():
		motion.y += gravity
	
	velocity = motion
	move_and_slide()
