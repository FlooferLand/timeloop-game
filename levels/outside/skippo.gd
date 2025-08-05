class_name IntroSkippo extends CanvasLayer

## TODO: Make it not skip the ENTIRE cutscene

const BuildingScene := preload("uid://douk4eknvrii7")

@export var to_stop: Array[Node] = []
@export var skip_component: SkipComponent
@export var skip_label: Label
@export var animator: AnimationPlayer
@export var camera: Camera2D
@export var camera_target: Marker2D

func _ready() -> void:
	skip_component.set_action("skip cutscene")
	skip_component.skipped.connect(func() -> void:
		for stopping in to_stop:
			if stopping == null:
				continue
			if stopping.has_method("stop"):
				stopping.call("stop")
		
		# Smoothly skips the cutscene by advancing; Very proud of this one
		var time_left := animator.current_animation_length - animator.current_animation_position
		animator.advance(time_left)
		camera.global_position = camera_target.global_position
	)

## Makes it so you can no longer skippo
func remove() -> void:
	queue_free()
