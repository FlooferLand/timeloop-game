## Handles time, space, and flying blue police call boxes
class_name TimeManagerType extends Node

signal prereset()
signal reset()  ## Called when the time loop does a time loopy
signal time_advanced(new_hour: int)  ## Called when the time advances by an hour
signal dev_time_speedup(enabled: bool)  ## For development only
signal time_stopped()  ## Triggered by entering the elevator room

const MAX_TIME := 70  ## Real world seconds
const START_PM := 1
const END_PM := 7

var counter: float = 0.0
var time: int = 0  ## The time in hours from START_PM to END_PM
var running := false

var _called_prereset := false
var _dev_time_speedup := false

func _process(delta: float) -> void:
	if not running:
		return
	counter += delta
	if _dev_time_speedup:
		counter += delta * 5
	
	var new_time_float := remap(counter, 0, MAX_TIME, START_PM, END_PM)
	var new_time := int(new_time_float)
	if new_time > time and new_time != END_PM:
		time_advanced.emit(new_time)
	time = new_time
	
	# Time reset
	if counter > MAX_TIME:
		time = 0
		counter = 0
		(DialogManager as DialogManagerType).close()
		reset.emit()
		_called_prereset = false
	elif counter > MAX_TIME - 5 and not _called_prereset:
		prereset.emit()
		_called_prereset = true

func _input(event: InputEvent) -> void:
	if not EnvManager.can_debug():
		return
	if event is InputEventKey:
		var key := event as InputEventKey
		if key.pressed and key.keycode == KEY_T:
			_dev_time_speedup = not _dev_time_speedup
			dev_time_speedup.emit(_dev_time_speedup)

## Starts all time (real)
func start() -> void:
	running = true

## Stops all time (real-
func stop() -> void:
	running = false
	counter = 0.0
	time = 0
	_called_prereset = false
	time_stopped.emit()
