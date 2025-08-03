class_name DialogComponent extends Node2D

signal on_dialog_closed()
signal update_speaking(speaking: bool)
signal change_animation(anim_name: String)

@export var dialog_data: DialogData = null

var active := false
var speaking := false

func start() -> void:
	(DialogManager as DialogManagerType).present(dialog_data)
	active = true

func stop() -> void:
	(DialogManager as DialogManagerType).close()
	active = false

func _ready() -> void:
	var diag_manager := (DialogManager as DialogManagerType)
	diag_manager.dialog_closed.connect(func():
		if active:
			active = false
			on_dialog_closed.emit()
	)
	diag_manager.update_speaking.connect(func(speaking: bool):
		update_speaking.emit(speaking)
	)
	diag_manager.action_change_animation.connect(func(anim_name: String):
		change_animation.emit(anim_name)
	)
