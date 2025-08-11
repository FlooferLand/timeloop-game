class_name NGTyped extends Node

const NGType := preload("res://addons/newgrounds/scripts/newgrounds.gd")

## The instance of the Newgrounds API
static var instance: NGType:
	get():
		return NG as NGType
