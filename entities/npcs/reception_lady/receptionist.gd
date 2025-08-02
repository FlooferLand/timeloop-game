extends Node2D

@export_group("Local")
@export var dialog: PersonDialogComponent
@export var ambient: AudioStreamPlayer2D

var speaking := false

func _ready() -> void:
	dialog.on_dialog_opened.connect(func():
		ambient.stop()
	)
	dialog.on_dialog_closed.connect(func():
		ambient.stop()
	)
