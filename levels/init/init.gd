extends Node2D

const TitleScreenScene := preload("uid://cu638cpwjak4k")

var waited: float = 0.0

func _ready() -> void:
	# Hacky but it works
	NGTyped.instance.refresh_session()
	NGTyped.instance.on_session_change.connect(func(session: NewgroundsSession) -> void:
		if session == null or session.user == null:
			return
		print("LOGGED IN: %s" % session.user.name)
	)

func _process(delta: float) -> void:
	waited += delta
	if waited > 1.0 or OS.is_debug_build():
		get_tree().change_scene_to_packed(TitleScreenScene)
		waited = 0.0
