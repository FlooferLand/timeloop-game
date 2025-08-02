extends Node2D

@export var dialog_comp: DialogComponent

func _ready() -> void:
	var dialog_manager := DialogManager as DialogManagerType
	dialog_manager.action_event.connect(func(event_name: String):
		if event_name == "give_document" and dialog_comp.active:
			print("PAPERS!")
	)
