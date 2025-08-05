@tool class_name TileableSprite2D extends Sprite2D

var shader := preload("uid://be1s7apltixil")

func _ready() -> void:
	var mat := ShaderMaterial.new()
	mat.shader = shader
	material = mat
	_update()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_LOCAL_TRANSFORM_CHANGED, NOTIFICATION_TRANSFORM_CHANGED:
			_update()

func _update() -> void:
	var mat := material as ShaderMaterial
	mat.set_shader_parameter("tile", scale)
