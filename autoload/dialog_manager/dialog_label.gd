class_name DialogLabel extends RichTextLabel

@export var char_timer: Timer
@export var char_audio_player: AudioStreamPlayer

@onready var dialog_manager := (DialogManager as DialogManagerType)

func _ready() -> void:
	char_timer.timeout.connect(func():
		if visible_characters >= text.length():
			visible_characters = -1
			char_timer.stop()
			dialog_manager.update_speaking.emit(false)
			return
		visible_characters += 1
		if char_audio_player.stream != null:
			char_audio_player.play()
	)

func set_fast(what: String) -> void:
	visible_characters = -1
	text = what

## A char_sound of null usually means the character is acting (not speaking)
func type(what: String, char_sound: AudioStreamWAV = null) -> void:
	visible_characters = 0
	text = what
	char_timer.start()
	
	if char_sound != null:
		if visible_characters == 0:
			dialog_manager.update_speaking.emit(true)
		var stream := AudioStreamRandomizer.new()
		stream.random_pitch = 1.2
		stream.add_stream(0, char_sound)
		char_audio_player.stream = stream
	else:
		char_audio_player.stream = null
		
