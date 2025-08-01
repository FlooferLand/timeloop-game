## For player interaction; Handled by the player
@tool class_name InteractComponent extends Node2D

enum Type {
	Interact = 0,
	Talk
}

signal on_player_interact(player: Player)

@onready var collision: CollisionShape2D = $Area2D/Collision

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

var player_hovering := false

## Called by the player when interacting
func player_interact(player: Player):
	on_player_interact.emit(player)
	player_hovering = false
	queue_redraw()

## Called by the player when they can interact with this component
func start_hover(player: Player):
	player_hovering = true
	queue_redraw()

## Called by the player when they can no longer interact with this component
func stop_hover(player: Player):
	player_hovering = false
	queue_redraw()

func _update_size():
	var shape := (collision.shape as RectangleShape2D)
	shape.size = size

func _draw() -> void:
	if player_hovering or Engine.is_editor_hint():
		const font_size := 48
		var font := ThemeDB.fallback_font
		var text: String
		match type:
			Type.Interact:
				text = "Interact"
			Type.Talk:
				text = "Talk"
		
		var total_size_w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size).x
		var pos := info_offset - Vector2i(total_size_w/2, 0.0)
		
		draw_string(font, pos + Vector2i(2,2), text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color.BLACK)
		draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color.WHITE)
