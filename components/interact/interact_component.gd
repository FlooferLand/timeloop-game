## For player interaction; Handled by the player
@tool class_name InteractComponent extends Node2D

signal on_player_interact(player: Player)

@onready var collision: CollisionShape2D = $Area2D/Collision

@export var size: Vector2i = Vector2.ONE * 100:
	get(): return size
	set(value):
		size = value.max(Vector2.ZERO)
		await ready
		var shape := (collision.shape as RectangleShape2D)
		shape.size = size

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

func _draw() -> void:
	if player_hovering:
		const font_size := 48
		const text := "Interact"
		var font := ThemeDB.fallback_font
		var total_size_w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size).x
		draw_string(
			font, Vector2.ZERO - Vector2(total_size_w/2, 0.0), text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
