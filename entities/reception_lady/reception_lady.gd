extends Node2D

@export_group("Local")
@export var interact_comp: InteractComponent
@export var dialog_comp: DialogComponent
@export var ambient: AudioStreamPlayer2D

func _ready() -> void:
	interact_comp.on_player_interact.connect(func(player: Player):
		dialog_comp.start()
		ambient.stop()
	)
	dialog_comp.on_dialog_closed.connect(func():
		ambient.play()
	)
