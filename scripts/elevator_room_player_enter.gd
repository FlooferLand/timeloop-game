extends Area2D

@export var blockade: CollisionShape2D

func _ready() -> void:
	blockade.disabled = true
	body_entered.connect(func(body: Node2D):
		if body is Player:
			blockade.disabled = false
	)
