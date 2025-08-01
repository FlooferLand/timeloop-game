extends AnimationPlayer

@export var player: Player
@export var outside_camera: Camera2D
@export var cutscene_target: Marker2D

var following_player := false

func _ready() -> void:
	player.can_move = false
	play("intro_cutscene")

func _physics_process(delta: float) -> void:
	if following_player:
		cutscene_target.global_position = player.global_position - (Vector2.DOWN * (get_viewport().get_visible_rect().size.y / 2))

func switch_to_player() -> void:
	player.can_move = true

func switch_camera_to_player() -> void:
	following_player = true
