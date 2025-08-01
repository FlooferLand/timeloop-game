@tool extends Node

const wall_closed_tex := preload("uid://ckp6mlimrl7qn")
const wall_tex := preload("uid://3w4s4tny4h66")

@export var bounds: RoomBounds

@onready var background: TileableSprite2D = $Background
@onready var ceiling: TileableSprite2D = $Ceiling
@onready var floor: TileableSprite2D = $Floor

@onready var left_wall_shape: CollisionShape2D = $LeftWall/Collision
@onready var right_wall_shape: CollisionShape2D = $RightWall/Collision
@onready var left_wall_spr: Sprite2D = $LeftWall/Sprite
@onready var right_wall_spr: Sprite2D = $RightWall/Sprite

@export_storage var size: Vector2
@export var closed_left := true:
	get(): return closed_left
	set(value):
		closed_left = value
		if is_inside_tree():
			left_wall_spr.texture = wall_closed_tex if closed_left else wall_tex
@export var closed_right := true:
	get(): return closed_right
	set(value):
		closed_right = value
		if is_inside_tree():
			right_wall_spr.texture = wall_closed_tex if closed_right else wall_tex

func _enter_tree() -> void:
	set_physics_process(false)
	if not Engine.is_editor_hint():
		set_process(false)

## Only called in the editor
func _process(delta: float) -> void:
	recalculate()

func recalculate() -> void:
	if bounds == null: return
	size = Vector2(bounds.right, bounds.top)
	
	# Ceiling
	var ceil_tex_size := ceiling.texture.get_size()
	ceiling.position = Vector2(0, -size.y)
	ceiling.scale = Vector2(size.x / ceil_tex_size.x, 1.0)
	
	# Floor
	var floor_height := 1.0
	var floor_tex_size := ceiling.texture.get_size()
	floor.position = Vector2(0, -(floor_tex_size.y * (floor_height - 0.05)))
	floor.scale = Vector2(size.x / floor_tex_size.x, floor_height)
	
	# Background
	var bg_tex_size := background.texture.get_size()
	background.position = Vector2(0, -size.y)
	background.scale = Vector2(size.x / bg_tex_size.x, size.y / bg_tex_size.y)
	
	#region Walls
	var wall_tex_size := wall_closed_tex.get_size()
	var wall_side_size := Vector2(wall_tex_size.x / 2, wall_tex_size.y)
	
	# Left wall
	var left_wall_rect = (left_wall_shape.shape as RectangleShape2D)
	left_wall_spr.position = Vector2(0, -size.y)
	if closed_left:
		left_wall_rect.size = wall_side_size
		left_wall_shape.position = left_wall_spr.position + Vector2(wall_side_size.x / 2, wall_side_size.y / 2.0)
	else:
		left_wall_rect.size = Vector2(wall_side_size.x, wall_side_size.y * 0.55)
		left_wall_shape.position = left_wall_spr.position + Vector2(wall_side_size.x / 2, left_wall_rect.size.y / 2)
	
	# Right wall
	var right_wall_rect = (right_wall_shape.shape as RectangleShape2D)
	right_wall_spr.position = Vector2(size.x - (wall_tex_size.x / 2), -size.y)
	if closed_right:
		right_wall_rect.size = wall_side_size
		right_wall_shape.position = right_wall_spr.position + Vector2(wall_side_size.x / 2, wall_side_size.y / 2.0)
	else:
		right_wall_rect.size = Vector2(wall_side_size.x, wall_side_size.y * 0.55)
		right_wall_shape.position = right_wall_spr.position + Vector2(wall_side_size.x / 2, right_wall_rect.size.y / 2)
	#endregion
