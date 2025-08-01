class_name DialogCharNameLabel extends RichTextLabel

func set_character(character: CharacterData) -> void:
	visible = true
	text = character.name

func clear_character() -> void:
	visible = false
	text = ""
