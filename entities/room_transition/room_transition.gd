class_name RoomTransition extends Node2D

@export var room_a: Room
@export var room_b: Room

@export_group("Local")
@export var area: Area2D

var manager: RoomManager  # Injected by RoomManager
var player: Player = null

func _ready() -> void:
	set_physics_process(false)
	set_process(false)
	area.body_entered.connect(func(body):
		if body is Player:
			player = body
			set_process(true)
	)
	area.body_exited.connect(func(body):
		if body is Player:
			player = null
			set_process(false)
	)
	if room_a == null or room_b == null:
		push_error("Room transition item is null (you stoopit)")

## Called while the player is in the transition
func _process(delta: float) -> void:
	var dir = player.move_direction.sign().x
	if dir > 0 and manager.active != room_b:
		manager.change(room_b)
	elif dir < 0 and manager.active != room_a:
		manager.change(room_a)
