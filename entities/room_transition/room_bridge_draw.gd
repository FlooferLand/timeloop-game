@tool class_name RoomBridgeDraw extends Node2D

@export var bridge: RoomBridge

func _draw() -> void:
	if (bridge.locked and bridge.player != null) or Engine.is_editor_hint():
		const font_size := 48
		var font := ThemeDB.fallback_font
		var text := "Locked"
		
		var total_size_w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size).x
		var pos := -Vector2i(total_size_w / 2, 0.0)
		
		draw_string(font, pos + Vector2i(2,2), text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color.BLACK)
		draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, Color.WHITE)
