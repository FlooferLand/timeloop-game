class_name SpotlightManagerType extends Node2D

const LightTexture := preload("uid://fyb3wuw770hk")
const DARK_COLOR := Color(0.8, 0.8, 0.8)
const CLEAR_COLOR := Color.WHITE

var blackout: CanvasModulate
var light: PointLight2D

var displaying := false

func _enter_tree() -> void:
	var root := get_node("/root")
	set_process_input(false)
	set_physics_process(false)
	set_process(false)
	
	blackout = CanvasModulate.new()
	root.add_child.call_deferred(blackout)
	
	light = PointLight2D.new()
	light.texture = LightTexture
	light.texture_scale = 3.0
	light.color = Color.WHITE
	root.add_child.call_deferred(light)
		
	_reset_to_transparent()
	get_tree().scene_changed.connect(func() -> void:
		_reset_to_transparent()
		set_process(false)
	)

func _reset_to_transparent() -> void:
	blackout.color = CLEAR_COLOR
	blackout.visible = false
	light.energy = 0.0
	light.visible = false

## Display the spotlight on a global position
func display_on(global_pos: Vector2) -> void:
	_reset_to_transparent()
	light.global_position = global_pos
	displaying = true
	blackout.visible = true
	light.visible = true
	set_process(true)

## Remove the spotlight
func remove() -> void:
	displaying = false

func _process(delta: float) -> void:
	var color := DARK_COLOR if displaying else CLEAR_COLOR
	var intensity := 0.25 if displaying else 0.0
	blackout.color = blackout.color.lerp(color, 12 * delta)
	light.energy = lerp(light.energy, intensity, 12 * delta)
	if is_equal_approx(light.energy, intensity) and not displaying:
		_reset_to_transparent()
		set_process(false)
		
