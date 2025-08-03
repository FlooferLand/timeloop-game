extends Node2D

@export var bob_prank: BobPrank

@export_group("Local")
@export var bnnuy_item: InventoryItem
@export var thank_player_dialog: DialogData
@export var after_dialog: DialogData
@export var dialog_comp: PersonDialogComponent
@export var interact_comp: InteractComponent
@export var ambient: AudioStreamPlayer2D

@onready var dialog_manager := DialogManager as DialogManagerType

var speaking := false
var gave_plushie := false

func _ready() -> void:
	dialog_comp.on_dialog_opened.connect(func():
		ambient.stop()
	)
	dialog_comp.on_dialog_closed.connect(func():
		ambient.play()
		if gave_plushie:
			var dialog := dialog_comp.dialog_comp
			dialog.dialog_data = after_dialog
	)
	bob_prank.dude_got_pranked.connect(func():
		var dialog := dialog_comp.dialog_comp
		dialog.dialog_data = thank_player_dialog
		# TODO: Show exclamation mark here
	)
	dialog_manager.action_event.connect(func(event_name: String):
		if event_name == "give_bnnuy" and dialog_comp.dialog_comp.active:
			interact_comp.current_player.inventory_comp.add_item(bnnuy_item)
			gave_plushie = true
	)	
	
