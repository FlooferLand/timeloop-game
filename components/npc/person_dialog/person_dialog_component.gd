## Like DialogComponent but for people. Unifies some things like interaction
@tool class_name PersonDialogComponent extends Node2D

signal on_dialog_opened
signal on_dialog_closed

@export var sprite: AnimatedSprite2D = null

var interact_comp: InteractComponent = null
var dialog_comp: DialogComponent = null

var speaking := false

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
		dialog_comp.start()
	)
	dialog_comp.on_dialog_closed.connect(func():
		on_dialog_closed.emit()
		sprite_play("idle")
	)
	dialog_comp.change_animation.connect(func(anim_name: String):
		if speaking:
			sprite_play(anim_name)
		elif sprite != null:
			sprite.animation = anim_name
			sprite.frame = 0
	)
	dialog_comp.update_speaking.connect(func(speaking: bool):
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
