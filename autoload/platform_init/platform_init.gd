## Initializes things for Newgrounds and all
extends Node

func _enter_tree() -> void:
	var secrets := ConfigFile.new()
	if secrets.load("res://secrets.cfg") == OK:
		var app_id: String = secrets.get_value("newgrounds", "api_key", ProjectSettings.get_setting("newgrounds.io/app_id"))
		var aes_key: String = secrets.get_value("newgrounds", "aes_key", "")
		
		ProjectSettings.set_setting("newgrounds.io/app_id", app_id)
		ProjectSettings.set_setting("newgrounds.io/AES-128_key", aes_key)
		NG.call("init")
	else:
		push_error("You must make a file called secrets.cfg and include the Newgrounds AES key, or leave it blank if not publishing on NG")
		get_tree().quit(-1)
