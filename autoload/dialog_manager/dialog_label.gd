class_name DialogLabel extends RichTextLabel

@export var char_timer: Timer
@export var char_audio_player: AudioStreamPlayer

func _ready() -> void:
	char_timer.timeout.connect(func():
		if visible_characters >= text.length():
			visible_characters = -1
			char_timer.stop()
			return
		visible_characters += 1
		if char_audio_player.stream != null:
			char_audio_player.play()
	)

func set_fast(what: String) -> void:
	visible_characters = -1
	text = what

func type(what: String, char_sound: AudioStreamWAV = null) -> void:
	visible_characters = 0
	text = what
	char_timer.start()
	
	if char_sound != null:
		var stream := AudioStreamRandomizer.new()
		stream.random_pitch = 1.2
		stream.add_stream(0, char_sound)
		char_audio_player.stream = stream
	else:
		char_audio_player.stream = null
		
