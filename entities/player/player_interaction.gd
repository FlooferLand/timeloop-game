extends Area2D

@export var player: Player

@export_group("Local")
@export var collision: CollisionShape2D

var initial_collision_pos: Vector2
var hovering: InteractComponent = null

func _ready() -> void:
	initial_collision_pos = collision.position
	player.change_direction.connect(func(direction: Player.Facing):
		if direction == Player.Facing.Right:
			collision.position = initial_collision_pos
		elif direction == Player.Facing.Left:
			collision.position = Vector2(-initial_collision_pos.x, initial_collision_pos.y)
	)

func _on_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	if parent is InteractComponent:
		hovering = parent
		hovering.start_hover(player)

func _on_area_exited(area: Area2D) -> void:
	var parent := area.get_parent()
	if parent is InteractComponent and parent == hovering:
		hovering.stop_hover(player)
		hovering = null

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and hovering is InteractComponent:
		hovering.player_interact(player)
