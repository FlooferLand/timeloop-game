## Handles time, space, and flying blue police call boxes
class_name TimeLoopManagerType extends Node

signal reset()
signal time_advanced(new_hour: int)

const MAX_TIME := 60  ## Real world seconds
const START_PM := 1
const END_PM := 7

var counter: float = 0.0
var time: int = 0

func _process(delta: float) -> void:
	counter += delta
	
	var new_time := int(remap(counter, 0, MAX_TIME, START_PM, END_PM))
	if new_time > time:
		time_advanced.emit(new_time)
	time = new_time
	
	if time > END_PM:
		time = 0
		counter = 0
		(DialogManager as DialogManagerType).close()
		reset.emit()
