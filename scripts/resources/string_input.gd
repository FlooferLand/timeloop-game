## A resource to map cross-platform joypad input buttons to a string
## Have to do this because Godot is too annoying to do it on its own
class_name JoypadMapping extends Resource

@export var mappings: Dictionary[JoyButton, String] = {}
