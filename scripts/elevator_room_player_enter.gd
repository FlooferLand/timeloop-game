extends Area2D

@export var blockade: CollisionShape2D

@onready var time_manager := (TimeManager as TimeManagerType)

func _ready() -> void:
	blockade.disabled = true
	body_entered.connect(func(body: Node2D) -> void:
		if body is Player:
			blockade.set_deferred("disabled", false)
			time_manager.stop()
	)
