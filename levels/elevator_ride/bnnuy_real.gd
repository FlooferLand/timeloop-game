extends Area2D

@export var squeak: AudioStreamPlayer
@export var medal_unlocker: NewgroundsMedalUnlocker

func _ready() -> void:
	visible = GameStorage.will_have_bnnuy_in_elevator
	if visible:
		medal_unlocker.unlock()
	body_entered.connect(func(body: Node2D) -> void:
		if body is Player and visible:
			squeak.play()
	)
