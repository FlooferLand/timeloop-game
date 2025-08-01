## Acts as an interface for DialogBox
class_name DialogManagerType extends CanvasLayer

signal dialog_closed

@export var dialog_box: DialogBox

var player_ref: Player = null  ## Filled in by Player

func _enter_tree() -> void:
	visible = false

func present(data: DialogData) -> void:
	dialog_box.present(data)
	visible = true
	player_ref.can_move = false
	player_ref.is_looking = true
	player_ref.mouse_locked = false

func close() -> void:
	dialog_box.close()
	visible = false
	player_ref.can_move = true
	player_ref.is_looking = false
	player_ref.mouse_locked = true
	dialog_closed.emit()
