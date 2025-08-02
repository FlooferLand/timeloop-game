class_name WalkingBob extends Node2D

@export_group("Local")
@export var walk_comp: PersonWalkComponent
@export var complain_audio_player: AudioStreamPlayer2D

var desk_self: BobAtDesk

func go_complain(target: Marker2D) -> void:
	walk_comp.target = target

func _ready() -> void:
	TimeManager.time_advanced.connect(func(new_hour: int):
		if new_hour == 6:
			walk_comp.target = desk_self.bob_desk_pos
	)
	walk_comp.on_arrived.connect(func(target: Marker2D):
		match target:
			desk_self.bob_complain_target:
				# Hehe..
				complain_audio_player.play()
			desk_self.bob_desk_pos:
				desk_self.bob_sprite.visible = true
				queue_free()
	)
