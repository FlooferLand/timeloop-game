## Responsible for showing the dialog and interactions
class_name DialogBox extends PanelContainer

@export var manager: DialogManagerType
@export var content_label: DialogContentLabel
@export var char_name_label: DialogCharNameLabel
@export var additional_audio_player: AudioStreamPlayer
@export var interaction_hint_label: Label

var entry_index: int = 0
var inner_index: int = 0

var data: DialogData = null
var current: DialogEntry = null

var too_early_to_skip := true
var speaking := false

func _ready() -> void:
	set_process(false)
	set_process_input(false)
	manager.update_speaking.connect(func(speaking: bool) -> void:
		self.speaking = speaking
		_update_hint_label()
	)
	JoypadManager.connect_state_changed(_update_hint_label)
	_update_hint_label()
	_reset()

func _reset() -> void:
	content_label.text = ""
	inner_index = 0
	entry_index = 0
	data = null
	current = null

func present(data: DialogData) -> void:
	_reset()
	self.data = data
	set_process(true)
	set_process_input(true)
	advance()
	too_early_to_skip = true
	interaction_hint_label.visible = false
	get_tree().create_timer(0.1).timeout.connect(func() -> void:
		too_early_to_skip = false
		interaction_hint_label.visible = true
	)

func close() -> void:
	_reset()
	set_process(false)
	set_process_input(false)
	additional_audio_player.stop()
	content_label.stop()

func advance() -> void:
	if entry_index >= data.entries.size():
		manager.close()
		return
	current = data.entries[entry_index]
	assert(current != null, "current was null")
	
	# Setting a character if there is one
	var character: CharacterData = null
	if current is DialogEntryWithCharacter:
		var entry := current as DialogEntryWithCharacter
		char_name_label.set_character(entry.character)
		character = entry.character
	else:
		char_name_label.clear_character()
	
	# Playing dialog actions
	for additional in current.additional:
		if additional is DialogPlaySoundAction:
			var action := additional as DialogPlaySoundAction
			additional_audio_player.stream = action.sound
			additional_audio_player.play()
		elif additional is DialogChangeAnimationAction:
			var action := additional as DialogChangeAnimationAction
			manager.action_change_animation.emit(action.anim_name)
		elif additional is DialogEventAction:
			var action := additional as DialogEventAction
			manager.action_event.emit(action.event_name)
			manager.can_close_early = false  # Fixes item duplication
	
	# Looking at all the dialog content types
	var pitch_variety := 1.0 if character == null else character.pitch_variety
	if current is DialogTextEntry:
		var entry := current as DialogTextEntry
		content_label.type(entry.text, entry.character.sound, pitch_variety)
	elif current is DialogCharacterActsEntry:
		var entry := current as DialogCharacterActsEntry
		content_label.set_fast("[i][color=gray]%s[/color][/i]" % entry.text)
	elif current is DialogTextCollection:
		advance_text_collection()
		return
	else:
		push_error("Unhandled dialog type!")
	
	# Advancing
	if entry_index + 1 <= data.entries.size():
		entry_index += 1

func advance_text_collection() -> void:
	var collection := current as DialogTextCollection
	if inner_index >= collection.texts.size():
		entry_index += 1
		inner_index = 0
		advance()
		return
	var entry := DialogTextEntry.new()
	entry.text = collection.texts[inner_index]
	entry.character = collection.character
	content_label.type(entry.text, entry.character.sound, entry.character.pitch_variety)
	
	# Advancing
	if inner_index + 1 <= collection.texts.size():
		inner_index += 1

#region Only enabled while doing dialog
func _process(delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not too_early_to_skip:
		var button := event as InputEventMouseButton
		if button.pressed and button.button_index == MOUSE_BUTTON_LEFT:
			if not too_early_to_skip:
				_trigger_early_skip_prevention()
				if speaking:
					content_label.skip_to_end()
				else:
					advance()

func _input(event: InputEvent) -> void:
	var advance_dialog_input := event.is_action_pressed("advance_dialog") \
		or event.is_action_pressed("interact")
	
	if advance_dialog_input and manager.visible and not too_early_to_skip:
		_trigger_early_skip_prevention()
		if speaking:
			content_label.skip_to_end()
		else:
			advance()
#endregion

func _trigger_early_skip_prevention() -> void:
	too_early_to_skip = true
	get_tree().create_timer(0.3).timeout.connect(func() -> void:
		too_early_to_skip = false
		interaction_hint_label.visible = true
	)

func _update_hint_label() -> void:
	var input_name := InputManager.get_input_name_from_list(["advance_dialog", "interact"])
	if speaking:
		interaction_hint_label.text = "Press %s to fast forward" % input_name
	else:
		interaction_hint_label.text = "Press %s to continue" % input_name
