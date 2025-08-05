extends CanvasLayer

## TODO: Make it not skip the ENTIRE cutscene

const BuildingScene := preload("uid://douk4eknvrii7")

@export var to_stop: Array[Node] = []
@export var skip_component: SkipComponent
@export var skip_label: Label

func _ready() -> void:
	skip_component.set_action("skip cutscene")
	skip_component.skipped.connect(func() -> void:
		for stopping in to_stop:
			if stopping == null:
				continue
			if stopping.has_method("stop"):
				stopping.call("stop")
		get_tree().change_scene_to_packed(BuildingScene)
	)
