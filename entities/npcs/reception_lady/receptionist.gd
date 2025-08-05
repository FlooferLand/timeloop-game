extends Node2D

@export var bob_prank: BobPrank

@export_group("Local")
@export var bnnuy_item: InventoryItem
@export var thank_player_dialog: DialogData
@export var after_happy_dialog: DialogData
@export var sad_dialog: DialogData
@export var dialog_comp: PersonDialogComponent
@export var interact_comp: InteractComponent
@export var ambient: AudioStreamPlayer2D
@export var exclaim: ExclaimComponent

@onready var time_manager := TimeManager as TimeManagerType
@onready var dialog_manager := DialogManager as DialogManagerType

var speaking := false

var awaiting_gift := false
var gave_plushie := false

func _ready() -> void:
	dialog_comp.on_dialog_opened.connect(func() -> void:
		ambient.stop()
		if awaiting_gift:
			exclaim.disable()
	)
	dialog_comp.on_dialog_closed.connect(func() -> void:
		ambient.play()
		if gave_plushie:
			dialog_comp.set_dialog_data(after_happy_dialog)
	)
	bob_prank.dude_got_pranked.connect(func() -> void:
		dialog_comp.set_dialog_data(thank_player_dialog)
		awaiting_gift = true
		exclaim.enable()
	)
	dialog_manager.action_event.connect(func(event_name: String) -> void:
		if event_name == "give_bnnuy" and dialog_comp.dialog_comp.active:
			interact_comp.current_player.inventory_comp.add_item(bnnuy_item)
			gave_plushie = true
			awaiting_gift = false
	)
	time_manager.time_advanced.connect(func(new_hour: int) -> void:
		if new_hour == TimeTable.BOB_GO_HARASS_RECEPTIONIST and not (awaiting_gift or gave_plushie):
			dialog_comp.set_dialog_data(sad_dialog)
	)
	
