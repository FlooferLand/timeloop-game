class_name DialogComponent extends Node2D

signal on_dialog_closed()

@export var dialog_data: DialogData = null

var active := false

func start() -> void:
	DialogManager.present(dialog_data)
	active = true

func _ready() -> void:
	DialogManager.dialog_closed.connect(func():
		if active:
			active = false
			on_dialog_closed.emit()
	)
