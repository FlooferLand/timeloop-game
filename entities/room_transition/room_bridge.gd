@tool class_name RoomBridge extends Node2D

signal redraw_lock

@export var room_a: Room
@export var room_b: Room
@export var has_door: bool = true
@export var locked := false:
	get(): return locked
	set(value):
		locked = value
		call_deferred("_update_lock")

@export_group("Local")
@export var area: Area2D
@export var door: AnimatedSprite2D
@export var door_audio_player: AudioStreamPlayer2D
@export var locking_body_collision: CollisionShape2D

var door_audio_playback: AudioStreamPlaybackInteractive
var manager: RoomManager  # Injected by RoomManager
var entities: Dictionary[int, CharacterBody2D] = {}

var anim_await_exit := false

func _ready() -> void:
	set_physics_process(false)
	set_process_input(false)
	set_process(false)
	_update_lock()
	door.animation = "open"
	door.frame = 0
	if Engine.is_editor_hint():
		_editor_ready()
		return
	
	door.visible = false
	area.body_entered.connect(func(body: Node2D) -> void:
		if body is Player or body.is_in_group("living_entity"):
			entities[body.get_instance_id()] = body
			set_process(true)
		if locked:
			redraw_lock.emit()
		else:
			_start_door_anim(body)
	)
	area.area_entered.connect(func(area: Area2D) -> void:
		if area.get_collision_mask_value(4):   # NPCs
			_start_door_anim(area)
	)
	area.body_exited.connect(func(body: Node2D) -> void:
		if body is CharacterBody2D and body in entities.values():
			entities.erase(body.get_instance_id())
			set_process(false)
			
		if locked:
			redraw_lock.emit()
		else:
			anim_await_exit = true
	)
	if has_door:
		door.animation_finished.connect(func() -> void:
			if door.animation == "open" and anim_await_exit:
				door_audio_playback.switch_to_clip_by_name("close")
				door.play_backwards("open")
				anim_await_exit = false
				return
			door.visible = false
		)
	if room_a == null or room_b == null:
		push_error("Room transition item is null (you stoopit)")

## _ready but for the editor
func _editor_ready() -> void:
	door.visible = has_door

func _start_door_anim(entering_body: Node2D) -> void:
	if has_door:
		if not door_audio_player.playing:
			door_audio_player.play()
		door_audio_playback = door_audio_player.get_stream_playback()
		door_audio_playback.switch_to_clip_by_name("open")
		door.visible = true
		door.flip_h = to_local(entering_body.global_position).x > 0
		door.play("open")

## Called while the player is in the transition
func _process(delta: float) -> void:
	if not locked and not entities.is_empty():
		for entity: CharacterBody2D in entities.values():
			if entity is Player:
				var player: Player = entity as Player
				var dir: float = player.move_direction.sign().x
				if dir > 0 and manager.active != room_b:
					manager.change(room_b)
					player.current_room_id = room_b.name
				elif dir < 0 and manager.active != room_a:
					manager.change(room_a)
					player.current_room_id = room_a.name
			else:
				var dir: float = entity.velocity.sign().x
				if not entity.has_meta("current_room"):
					entity.set_meta("current_room", room_a.name)
				
				if dir > 0 and entity.get_meta("current_room") != room_b.name:
					manager.entity_move_room(entity, room_b)
				elif dir < 0 and entity.get_meta("current_room") != room_a.name:
					manager.entity_move_room(entity, room_a)

func _update_lock() -> void:
	locking_body_collision.disabled = not locked
	redraw_lock.emit()
