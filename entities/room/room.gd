class_name Room
extends Node2D

const PositionCurve := preload("uid://cxgljmlopvk7")

@onready var autoroom: AutoRoom = $AutoRoom
@onready var camera: Camera2D = autoroom.camera

var manager: RoomManager  # Injected by RoomManager
var _initial_cam_pos: Vector2

func _enter_tree() -> void:
	manager = get_parent() as RoomManager
	modulate = Color.WHITE if manager.active == self else Color.BLACK
	visible = manager.active == self
	#print("MY NAME IS %s, I MADE THE MIMIC. IT WAS DIFFICULT TO PUT THE ROOMS TOGETHER" % name)

func _ready() -> void:
	_initial_cam_pos = camera.position

func _process(delta: float) -> void:
	if manager.active != self:
		return
	var player_local := to_local(manager.player.global_position)
	var ratio := (player_local.x / autoroom.bounds.right)
	
	var target := _initial_cam_pos.lerp(
		Vector2(lerp(player_local.x, _initial_cam_pos.x, PositionCurve.sample(ratio) * 0.3), _initial_cam_pos.y),
		0.5
	)
	camera.position = camera.position.lerp(target, 8 * delta)
