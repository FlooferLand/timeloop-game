extends Node2D

@export var managers_desk_target: Marker2D
@export var bridge_door: RoomBridge

@export_group("Local")
@export var elevator_keys_item: InventoryItem
@export var plushie_item: InventoryItem
@export var received_plushie_dialog: DialogData
@export var cant_talk_dialog: DialogData
@export var walk_comp: PersonWalkComponent
@export var person_dialog_comp: PersonDialogComponent
@export var dialog_comp: DialogComponent
@export var interact_comp: InteractComponent

@onready var time_manager: TimeManagerType = TimeManager
@onready var dialog_manager: DialogManagerType = DialogManager

var can_receive_plushie := true

func _ready() -> void:
	interact_comp.interact_condition = func(player: Player) -> bool:
		if player.inventory_comp.has_item(plushie_item.id):
			dialog_comp.dialog_data = received_plushie_dialog
		return true
	dialog_manager.action_event.connect(func(event_name: String):
		if dialog_comp.active:
			match event_name:
				"steal_the_bnnuy":
					interact_comp.current_player.inventory_comp.remove_item(plushie_item)
				"give_elevator_keys":
					interact_comp.current_player.inventory_comp.add_item(elevator_keys_item)
	)
	time_manager.time_advanced.connect(func(new_hour: int):
		if new_hour == TimeTable.MANAGER_GO_TO_DESK:
			walk_comp.target = managers_desk_target
			dialog_comp.dialog_data = cant_talk_dialog
			can_receive_plushie = false
	)

func _process(delta: float) -> void:
	if global_position.x > bridge_door.global_position.x and bridge_door.locked:
		bridge_door.locked = false
