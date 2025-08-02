class_name DialogContentLabel extends RichTextLabel

const SILENT_CHARS: Array[String] = [" ", ".", ",", "-", "'", "\""]
const CUSS_WORDS: Array[String] = ["fucker", "fuck", "shit", "bastard", "twat"]

@export var char_timer: Timer
@export var char_audio_player: AudioStreamPlayer
@export var censor_audio_player: AudioStreamPlayer

@onready var dialog_manager := (DialogManager as DialogManagerType)

## An empty string represents a cuss word ending
var cusses_in_text: Dictionary[int, String] = {}

func _ready() -> void:
	char_timer.timeout.connect(func():
		if visible_characters >= text.length():
			visible_characters = -1
			char_timer.stop()
			dialog_manager.update_speaking.emit(false)
			return
		
		# Cuss words
		# FIXME: For some reason the cuss sound stops if there are too many cuss words together
		var index := visible_characters
		var char := text[index]
		if cusses_in_text.has(index):
			if cusses_in_text[index] != "":
				censor_audio_player.play()
			else:
				censor_audio_player.stop()
			visible_characters += 1
			return
		
		# Skip silent/empty characters
		if char in SILENT_CHARS:
			visible_characters += 1
			return
			
		# Continue and play sound blip
		visible_characters += 1
		if char_audio_player.stream != null:
			char_audio_player.play()
	)

## A char_sound of null usually means the character is not speaking (acting, etc)
func type(what: String, char_sound: AudioStream = null, pitch_variety := 1.0) -> void:
	cusses_in_text.clear()
	visible_characters = 0
	text = what
	char_timer.start()
	
	# Bad word detection, oh noes!
	## TODO: OPTIMIZE THIS GARBAGE
	var lower_text := text.to_lower()
	for cuss: String in CUSS_WORDS:
		for i in range(lower_text.count(cuss)):
			# Start
			var found := lower_text.find(cuss, i)
			if found == -1: continue
			cusses_in_text[found] = cuss
			
			# End
			cusses_in_text[found + cuss.length()] = ""
			var literal_cuss := text.substr(found, cuss.length())
			text = text.replace(literal_cuss, "#".repeat(literal_cuss.length()))
	
	if char_sound != null:
		if visible_characters == 0:
			dialog_manager.update_speaking.emit(true)
		var stream := AudioStreamRandomizer.new()
		stream.random_pitch = 1.0 + (0.15 * pitch_variety)
		stream.add_stream(0, char_sound)
		char_audio_player.stream = stream
	else:
		char_audio_player.stream = null

## Sets the text all at once, skipping the typewriter effect
func set_fast(what: String) -> void:
	cusses_in_text.clear()
	visible_characters = -1
	text = what
	
## Essentially set_fast, but this skips to the current dialog's end instead of setting a new one
func skip_to_end() -> void:
	stop()

## Pretty self-explanitory this one
func stop() -> void:
	visible_characters = -1
	char_timer.stop()
	dialog_manager.update_speaking.emit(false)
	cusses_in_text.clear()
	
