extends Node2D

@export var room_manager: RoomManager

## In seconds, once it reaches a certain number it revalidates entity visibility
var timer := 0.0

func _process(delta: float) -> void:
	timer += delta
	if timer > 0.1:
		for child: Node in get_children():
			if child is not Node2D:
				continue
			var node: Node2D = child as Node2D
			
			## Changes the visibility of entities for the room
			## Not the best performance wise, but it's also not bad
			for room: Room in room_manager.rooms:
				if node.global_position.x < room.global_position.x:
					continue
				elif node.global_position.x > room.global_position.x + room.bounds.right:
					continue
				node.modulate = node.modulate.lerp(room.modulate, 8 * delta)
