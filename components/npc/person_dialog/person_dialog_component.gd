## Like DialogComponent but for people. Unifies some things like interaction
@tool class_name PersonDialogComponent extends Node2D

signal on_dialog_opened
signal on_dialog_closed

@export var sprite: AnimatedSprite2D = null
@export var future_dialogs: Array[DialogData] = []
@export var walk_comp: PersonWalkComponent = null

var interact_comp: InteractComponent = null
var dialog_comp: DialogComponent = null

var speaking := false
var dialog_index := 0
var interact_counter := 0

func _enter_tree() -> void:
	for child in get_children():
		if child is InteractComponent:
			interact_comp = child as InteractComponent
		elif child is DialogComponent:
			dialog_comp = child as DialogComponent

func _ready() -> void:
	if Engine.is_editor_hint():
		_editor_ready()
		return
		
	sprite_play("idle")
	interact_comp.on_player_interact.connect(func(player: Player):
		on_dialog_opened.emit()
		interact_counter += 1
		if future_dialogs.size() > 0 and interact_counter > 1:
			dialog_comp.dialog_data = future_dialogs[dialog_index]
		dialog_comp.start()
		interact_comp.hide_info()
		if walk_comp != null:
			walk_comp.paused = true
	)
	dialog_comp.on_dialog_closed.connect(func():
		on_dialog_closed.emit()
		sprite_play("idle")
		if dialog_index + 1 < future_dialogs.size() and interact_counter > 1:
			dialog_index += 1
			interact_comp.set_postfix("again")
		interact_comp.show_info()
		if walk_comp != null:
			walk_comp.paused = false
	)
	dialog_comp.change_animation.connect(func(anim_name: String):
		if not dialog_comp.active:
			return
		if speaking:
			sprite_play(anim_name)
		elif sprite != null:
			sprite.animation = anim_name
			sprite.frame = 0
	)
	dialog_comp.update_speaking.connect(func(speaking: bool):
		if not dialog_comp.active:
			return
		self.speaking = speaking
		if not speaking and sprite != null:
			sprite_stop()
			sprite.frame = 1
	)

func sprite_play(anim_name: String) -> void:
	if sprite != null:
		sprite.play(anim_name)

func sprite_stop() -> void:
	if sprite != null:
		sprite.stop()

func _editor_ready() -> void:
	update_configuration_warnings()
	
	child_entered_tree.connect(func(child: Node):
		if child is InteractComponent:
			interact_comp = child as InteractComponent
		elif child is DialogComponent:
			dialog_comp = child as DialogComponent
		update_configuration_warnings()
	)
	child_exiting_tree.connect(func(child: Node):
		if child is InteractComponent:
			interact_comp = null
		elif child is DialogComponent:
			dialog_comp = null
		update_configuration_warnings()
	)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	if interact_comp == null:
		warnings.append("You need to add an interaction component underneath")
	if dialog_comp == null:
		warnings.append("You need to add a dialog component underneath")
	return warnings
