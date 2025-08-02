extends Node2D

@onready var time_manager: TimeManagerType = TimeManager
var eeping := false

func _ready() -> void:
	time_manager.time_advanced.connect(func(new_hour: int):
		
		eeping = true
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
