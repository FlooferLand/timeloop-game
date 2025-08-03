## Acts as an interface for DialogBox
class_name DialogManagerType extends CanvasLayer

# NOTE: These signals should not be listened to from globally

signal dialog_opened  ## Called when the dialog is opened
signal dialog_closed  ## Called when the dialog is closed
signal update_speaking(speaking: bool)  ## Called when speech dialog is started or stopped
signal action_change_animation(anim_name: String)  ## Called by the change animation action
signal action_event(event_name: String)  ## Called by the event action

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
	dialog_opened.emit()

func close() -> void:
	dialog_box.close()
	visible = false
	player_ref.can_move = true
	player_ref.is_looking = false
	player_ref.mouse_locked = true
	dialog_closed.emit()
	update_speaking.emit(false)
