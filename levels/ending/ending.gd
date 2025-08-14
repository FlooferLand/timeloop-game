extends Node2D

@export var anim_player: AnimationPlayer
@export var speedrun_time: Label

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	anim_player.play("ending")
	
	var time: float = SpeedrunManager.time
	if EnvManager.can_debug():
		time = 9_999_999
	
	## Showing the time to the user
	speedrun_time.text = "Completed in %s seconds" % snappedf(time, 0.001)
	SpeedrunManager.stop_timer()
	
	## Submitting the time
	var id := NewgroundsIds.ScoreboardId.CompletionTimes
	await NG.scoreboard_submit_time(id, time)
	
	## Medal
	NGTyped.instance.medal_unlock(NewgroundsIds.MedalId.BeatTheGame)
