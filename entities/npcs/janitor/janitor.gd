class_name Janitor extends Node2D

@onready var time_manager: TimeManagerType = TimeManager

@export_group("Local")
@export var sprite: AnimatedSprite2D
@export var interact_comp: InteractComponent
@export var dialog_comp: DialogComponent

var eeping := false

func _ready() -> void:
	sprite.play("idle")
	time_manager.time_advanced.connect(func(new_hour: int):
		if new_hour == TimeTable.JANITOR_FALL_ASLEEP:
			eeping = true
			sprite.play("asleep")
			interact_comp.can_interact = false
			dialog_comp.stop()
	)
