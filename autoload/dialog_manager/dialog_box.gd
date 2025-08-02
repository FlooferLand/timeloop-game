## Responsible for showing the dialog and interactions
class_name DialogBox extends PanelContainer

@export var manager: DialogManagerType
@export var content_label: DialogLabel
@export var char_name_label: DialogCharNameLabel
@export var additional_audio_player: AudioStreamPlayer

var entry_index: int = 0
var inner_index: int = 0

var data: DialogData = null
var current: DialogEntry = null

var speaking := false

func _ready() -> void:
	set_process(false)
	set_process_input(false)
	manager.update_speaking.connect(func(speaking: bool):
		self.speaking = speaking
	)

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

func close() -> void:
	_reset()
	set_process(false)
	set_process_input(false)
	additional_audio_player.stop()

func advance() -> void:
	if entry_index >= data.entries.size():
		manager.close()
		return
	current = data.entries[entry_index]
	assert(current != null, "current was null")
	
	# Setting a character if there is one
	if current is DialogEntryWithCharacter:
		var entry := current as DialogEntryWithCharacter
		char_name_label.set_character(entry.character)
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
	
	# Looking at all the dialog content types
	if current is DialogTextEntry:
		var entry := current as DialogTextEntry
		content_label.type(entry.text, entry.character.sound)
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
	else:
		manager.close()

func advance_text_collection() -> void:
	var collection := current as DialogTextCollection
	var entry := DialogTextEntry.new()
	entry.text = collection.texts[inner_index]
	entry.character = collection.character
	content_label.type(entry.text, entry.character.sound)
	
	# Advancing
	if inner_index + 1 < collection.texts.size():
		inner_index += 1
	elif entry_index + 1 < data.entries.size():
		entry_index += 1
	else:
		manager.close()

#region Only enabled while doing dialog
func _process(delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var button := event as InputEventMouseButton
		if button.pressed and button.button_index == MOUSE_BUTTON_LEFT:
			advance()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("advance_dialog") and manager.visible:
		if speaking:
			content_label.skip_to_end()
		else:
			advance()
#endregion
