## For player interaction; Handled by the player
@tool class_name InteractComponent extends Node2D

enum Type {
	Interact = 0,
	Talk,
	Unlock,
	PickUp,
	Place,
	Give,
	Enter
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
		update_label()

@export var type: Type:
	get(): return type
	set(value):
		type = value
		update_label()

@export_group("Local")
@export var collision: CollisionShape2D
@export var label: Label

var player_hovering := false
var displaying_info := false
var current_player: Player = null
var can_interact := true:
	get(): return can_interact
	set(value):
		can_interact = value
		update_label()
var _postfix := ""
var interact_condition := func(player: Player) -> bool: return true

func set_postfix(postfix: String = "") -> void:
	_postfix = postfix

## Called by the player when interacting
func player_interact(player: Player) -> void:
	if is_visible_in_tree() and can_interact and meets_condition(player):
		on_player_interact.emit(player)
		current_player = player
		update_label()

## Called by the player when they can interact with this component
func player_enter(player: Player) -> void:
	if is_visible_in_tree() and can_interact and meets_condition(player):
		player_hovering = true
		displaying_info = true
		current_player = player
		update_label()

## Called by the player when they can no longer interact with this component
func player_leave(player: Player) -> void:
	player_hovering = false
	displaying_info = false
	current_player = null
	update_label()

func show_info() -> void:
	displaying_info = true
	update_label()

func hide_info() -> void:
	displaying_info = false
	update_label()

func meets_condition(player: Player) -> bool:
	if interact_condition == null or player == null:
		push_error("Interact condition (or player) was null, for some reason (player=%s, interact_condition=%s)" % [player, interact_condition])
		return true
	return interact_condition.call(player)

func _update_size() -> void:
	var shape := (collision.shape as RectangleShape2D)
	shape.size = size

## FIXME: There's a bug where after an interaction the label might not update properly
##        This fixes it, but is annoying for performance
func _process(delta: float) -> void:
	update_label()

func update_label() -> void:
	if not is_inside_tree():
		await tree_entered
	await get_tree().process_frame
	
	var should_draw := ((displaying_info and can_interact) or Engine.is_editor_hint()) and (current_player != null and meets_condition(current_player))
	if not should_draw:
		label.visible = false
		return
	
	var text: String
	match type:
		InteractComponent.Type.Interact:
			text = "Interact"
		InteractComponent.Type.Talk:
			text = "Talk"
		InteractComponent.Type.Unlock:
			text = "Unlock"
		InteractComponent.Type.PickUp:
			text = "Pick up"
		InteractComponent.Type.Place:
			text = "Place"
		InteractComponent.Type.Give:
			text = "Give"
		InteractComponent.Type.Enter:
			text = "Enter"
	if not _postfix.is_empty():
		text = "%s %s" % [text, _postfix]
	label.position = Vector2(info_offset) - Vector2(label.size.x / 2, label.size.y - 30)
	label.text = text
	label.visible = true
