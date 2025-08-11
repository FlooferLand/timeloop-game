class_name EnvManagerType extends Node

const SECRETS := preload("uid://d18qe3rd4osis")
const DEV_MENU_CODE := "girlmenu"

var typed_so_far := ""
var is_debug_via_cheatcode := false

## Returns true if debug menus can be triggered for example
func can_debug() -> bool:
	var is_dev: bool = false
	if NGTyped.instance.session != null:
		if NGTyped.instance.session.user != null:
			if NGTyped.instance.session.user.name != null:
				is_dev = NGTyped.instance.session.user.name.to_lower() == "flooferland"
				print("your name: '%s'" % NGTyped.instance.session.user.name.to_lower())
	return OS.is_debug_build() or is_dev or is_debug_via_cheatcode

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key := event as InputEventKey
		if key.unicode == 0: return
		var unicode := char(key.unicode)
		if DEV_MENU_CODE.contains(unicode):
			typed_so_far += unicode
		else:
			typed_so_far = ""
		if typed_so_far == DEV_MENU_CODE:
			is_debug_via_cheatcode = true
			typed_so_far = ""
		if typed_so_far.length() > DEV_MENU_CODE.length():
			typed_so_far = ""
