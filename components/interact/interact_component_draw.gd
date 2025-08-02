@tool extends Node2D

@export var interact_comp: InteractComponent

func _draw() -> void:
	if interact_comp.player_hovering or Engine.is_editor_hint():
		const font_size := 48
		var font := ThemeDB.fallback_font
		var text: String
		match interact_comp.type:
			InteractComponent.Type.Interact:
				text = "Interact"
			InteractComponent.Type.Talk:
				text = "Talk"
		
		var total_size_w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size).x
		var pos := interact_comp.info_offset - Vector2i(total_size_w / 2, 0.0)
		
		draw_string(font, pos + Vector2i(2,2), text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color.BLACK)
		draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color.WHITE)
