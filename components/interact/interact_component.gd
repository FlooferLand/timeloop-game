## For player interaction
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

## Called by the player when interacting
func player_interact(player: Player):
	on_player_interact.emit(player)
