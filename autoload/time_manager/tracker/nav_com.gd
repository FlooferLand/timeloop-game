extends AudioStreamPlayer

@export var time_loop_approaching: AudioStream
@export var time_loop_reset: AudioStream

@onready var time_manager := TimeManager as TimeManagerType

## Should be toggled on after the first time to not annoy the player
var told_about_reset := false

func _ready() -> void:
	time_manager.time_advanced.connect(func(new_hour: int):
		if new_hour == TimeManagerType.END_PM - 1:
			stream = time_loop_approaching
			play()
	)
	time_manager.reset.connect(func():
		if not told_about_reset:
			await get_tree().create_timer(1.0).timeout
			stream = time_loop_reset
			play()
			told_about_reset = true
	)
