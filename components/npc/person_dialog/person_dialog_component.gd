## Like DialogComponent but for people. Unifies some things like interaction
@tool class_name PersonDialogComponent extends Node2D

signal on_dialog_opened
signal on_dialog_closed
signal on_dialog_closed_early

class RequiredAnimations extends Object:
	var idle := "idle"
	var talk := "talk"

@export var sprite: AnimatedSprite2D = null
@export var future_dialogs: Array[DialogData] = []
@export var walk_comp: PersonWalkComponent = null
@export var head_position: Vector2:
	get(): return head_position
	set(value):
		head_position = value
		if head_position_editor_col != null:
			head_position_editor_col.position = head_position

var head_position_editor_col: CollisionShape2D
var head_position_editor_area: Area2D

var active: bool:
	get(): return dialog_comp.active
	set(value):
		dialog_comp.active = value

var interact_comp: InteractComponent = null
var dialog_comp: DialogComponent = null

var speaking := false
var dialog_index := 0
var interact_counter := 0
var required_animations := RequiredAnimations.new()
var _sprite_postfix := ""
var incomplete_dialog := false
var _character_postfix := ""

func _enter_tree() -> void:
	for child in get_children():
		if child is InteractComponent:
			interact_comp = child as InteractComponent
		elif child is DialogComponent:
			dialog_comp = child as DialogComponent
	if Engine.is_editor_hint():
		head_position_editor_area = Area2D.new()
		
		var shape := CircleShape2D.new()
		shape.radius = 50
		head_position_editor_col = CollisionShape2D.new()
		head_position_editor_col.shape = shape
		head_position_editor_col.debug_color = Color.AQUAMARINE.lerp(Color.TRANSPARENT, 0.8)
		head_position_editor_col.position = head_position
		head_position_editor_area.add_child(head_position_editor_col)
		add_child(head_position_editor_area)

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		head_position_editor_area.queue_free()

func _ready() -> void:
	if Engine.is_editor_hint():
		_editor_ready()
		return
	_sprite_check_default_animations()
	sprite_play(required_animations.idle)
	interact_comp.on_player_interact.connect(func(player: Player) -> void:
		on_dialog_opened.emit()
		if not incomplete_dialog:
			interact_counter += 1
			if future_dialogs.size() > 0 and interact_counter > 1:
				dialog_comp.dialog_data = future_dialogs[dialog_index]
		incomplete_dialog = false
		dialog_comp.start()
		interact_comp.hide_info()
		if head_position:
			SpotlightManager.display_on(to_global(head_position))
		if walk_comp != null:
			walk_comp.paused = true
	)
	dialog_comp.on_dialog_closed.connect(func() -> void:
		on_dialog_closed.emit()
		sprite_play(required_animations.idle)
		if interact_counter > 0 and not future_dialogs.is_empty():
			interact_comp.set_postfix(_character_postfix + "more")
		if dialog_index == future_dialogs.size()-1 and interact_counter > 1:
			interact_comp.set_postfix(_character_postfix + "again")
		if dialog_index + 1 < future_dialogs.size() and interact_counter > 1:
			dialog_index += 1
		interact_comp.show_info()
		SpotlightManager.remove()
		if walk_comp != null:
			walk_comp.paused = false
	)
	dialog_comp.on_dialog_closed_early.connect(func() -> void:
		on_dialog_closed_early.emit()
		sprite_play(required_animations.idle)
		interact_comp.show_info()
		incomplete_dialog = true
		SpotlightManager.remove()
		if walk_comp != null:
			walk_comp.paused = false
	)
	dialog_comp.change_animation.connect(func(anim_name: String) -> void:
		if speaking:
			sprite_play(anim_name)
		elif sprite != null:
			sprite.animation = anim_name
			sprite.frame = 0
	)
	dialog_comp.update_speaking.connect(func(speaking: bool) -> void:
		self.speaking = speaking
		if not speaking and sprite != null:
			sprite_stop()
			sprite.frame = 1
	)
	
	# Getting the character name to display before interaction
	if dialog_comp.dialog_data != null:
		var first: DialogEntry = dialog_comp.dialog_data.entries.get(0)
		if first != null and first is DialogEntryWithCharacter:
			var diag := first as DialogEntryWithCharacter
			_character_postfix = "to %s " % diag.character.name  # Space at end needed
		interact_comp.set_postfix(_character_postfix)

func sprite_play(anim_name: String) -> void:
	if sprite != null:
		var postfix := ("_%s" % _sprite_postfix) if not _sprite_postfix.is_empty() else ""
		var anim_full_name: String = anim_name + postfix
		sprite_check_animations([anim_full_name])
		sprite.play(anim_full_name)

func sprite_stop() -> void:
	if sprite != null:
		sprite.stop()

## Checks if a custom list of animations all exist; Very fast.
func sprite_check_animations(custom_animations: PackedStringArray) -> void:
	var frames: SpriteFrames = sprite.sprite_frames
	for custom in custom_animations:
		if not frames.has_animation(custom):
			_missing_animation_error(custom)

## Checks if the default list of animations all exist; Slow.
func _sprite_check_default_animations() -> void:
	if sprite != null and OS.is_debug_build():
		var frames: SpriteFrames = sprite.sprite_frames
		
		# Accumulating animations
		for prop in required_animations.get_property_list():
			if prop.get("hint") != PropertyHint.PROPERTY_HINT_NONE:
				continue
			if prop.get("usage") != PropertyUsageFlags.PROPERTY_USAGE_SCRIPT_VARIABLE:
				continue
			var prop_name: String = prop.get("name")
			var prop_value: String = required_animations.get(prop_name)
			if not frames.has_animation(prop_value):
				_missing_animation_error(prop_value)

func _missing_animation_error(anim_name: String) -> void:
	push_error("Sprite frames on '%s' are missing animation '%s'" % [get_parent().name, anim_name])

func _editor_ready() -> void:
	update_configuration_warnings()
	
	child_entered_tree.connect(func(child: Node) -> void:
		if child is InteractComponent:
			interact_comp = child as InteractComponent
		elif child is DialogComponent:
			dialog_comp = child as DialogComponent
		update_configuration_warnings()
	)
	child_exiting_tree.connect(func(child: Node) -> void:
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

func set_dialog_data(data: DialogData) -> void:
	dialog_comp.dialog_data = data
	dialog_index = 0
	interact_counter = 0

func set_sprite_postfix(postfix: String) -> void:
	_sprite_postfix = postfix
