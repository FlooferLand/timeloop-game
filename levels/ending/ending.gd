extends Node2D

@export var anim_player: AnimationPlayer
@export var speedrun_time: Label
@export var speedrun_scoreboard: NewgroundsScoreboard

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	anim_player.play("ending")
	
	## Showing the time to the user
	speedrun_time.text = "Completed in %s seconds" % snappedf(SpeedrunManager.time, 0.001)
	SpeedrunManager.stop_timer()
	
	## Submitting the time
	speedrun_scoreboard.submit_time(SpeedrunManager.time)
