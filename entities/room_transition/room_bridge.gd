@tool class_name RoomBridge extends Node2D

@export var room_a: Room
@export var room_b: Room
@export var has_door: bool = true

@export_group("Local")
@export var area: Area2D
@export var door: AnimatedSprite2D
@export var door_audio_player: AudioStreamPlayer2D

var door_audio_playback: AudioStreamPlaybackInteractive
var manager: RoomManager  # Injected by RoomManager
var player: Player = null

var anim_await_exit := false

func _ready() -> void:
	set_physics_process(false)
	set_process(false)
	door.animation = "open"
	door.frame = 0
	if Engine.is_editor_hint():
		_editor_ready()
		return
	
	door.visible = false
	area.body_entered.connect(func(body):
		if body is Player:
			player = body
			if has_door:
				if not door_audio_player.playing:
					door_audio_player.play()
				door_audio_playback = door_audio_player.get_stream_playback()
				door_audio_playback.switch_to_clip_by_name("open")
				door.visible = true
				door.flip_h = to_local(player.global_position).x > 0
				door.play("open")
			set_process(true)
	)
	area.body_exited.connect(func(body):
		if body is Player:
			anim_await_exit = true
			player = null
			set_process(false)
	)
	if has_door:
		door.animation_finished.connect(func():
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
func _editor_ready():
	door.visible = has_door

## Called while the player is in the transition
func _process(delta: float) -> void:
	var dir = player.move_direction.sign().x
	if dir > 0 and manager.active != room_b:
		manager.change(room_b)
	elif dir < 0 and manager.active != room_a:
		manager.change(room_a)
