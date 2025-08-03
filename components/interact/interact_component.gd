## For player interaction; Handled by the player
@tool class_name InteractComponent extends Node2D

enum Type {
	Interact = 0,
	Talk,
	Unlock,
	PickUp,
	Place
}

signal on_player_interact(player: Player)

@export var size: Vector2i = Vector2.ONE * 100:
	get(): return size
	set(value):
		size = value.max(Vector2.ZERO)
		call_deferred("_update_size")

@export var info_offset: Vector2i = Vector2.ZERO:
	get(): return info_offset
	set(value):
		info_offset = value
		queue_redraw()

@export var type: Type:
	get(): return type
	set(value):
		type = value
		queue_redraw()

@export_group("Local")
@export var collision: CollisionShape2D
@export var comp_draw: InteractComponentDraw

var player_hovering := false
var displaying_info := false
var current_player: Player = null
var can_interact := true:
	get(): return can_interact
	set(value):
		can_interact = value
		queue_redraw()
var _postfix := ""
var interact_condition := func(player: Player) -> bool: return true

func set_postfix(postfix: String = ""):
	_postfix = postfix

## Called by the player when interacting
func player_interact(player: Player):
	if is_visible_in_tree() and can_interact and meets_condition(player):
		on_player_interact.emit(player)
		current_player = player
		queue_redraw()

## Called by the player when they can interact with this component
func player_enter(player: Player):
	if is_visible_in_tree() and can_interact and meets_condition(player):
		player_hovering = true
		displaying_info = true
		current_player = player
		queue_redraw()

## Called by the player when they can no longer interact with this component
func player_leave(player: Player):
	player_hovering = false
	displaying_info = false
	current_player = null
	queue_redraw()

func show_info():
	displaying_info = true
	queue_redraw()

func hide_info():
	displaying_info = false
	queue_redraw()

func meets_condition(player: Player) -> bool:
	return interact_condition.call(player)

func _update_size():
	var shape := (collision.shape as RectangleShape2D)
	shape.size = size

func _draw() -> void:
	comp_draw.queue_redraw()
