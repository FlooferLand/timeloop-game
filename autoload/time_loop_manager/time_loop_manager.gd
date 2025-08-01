## Handles time, space, and flying blue police call boxes
class_name TimeLoopManagerType extends Node

signal reset()

const MAX_TIME := 10  # 60
const START_PM := 1
const END_PM := 7

var counter: float = 0.0
var time: int = 0

func _process(delta: float) -> void:
	counter += delta
	time = int(remap(counter, 0, MAX_TIME, START_PM, END_PM))
	if time > END_PM:
		time = 0
		counter = 0
		(DialogManager as DialogManagerType).close()
		reset.emit()
