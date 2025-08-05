## Acts as an interface for DialogBox
class_name DialogManagerType extends CanvasLayer

# NOTE: These signals should not be listened to from globally

signal dialog_opened  ## Called when the dialog is opened
signal dialog_closed(closed_early: bool)  ## Called when the dialog is closed
signal update_speaking(speaking: bool)  ## Called when speech dialog is started or stopped
signal action_change_animation(anim_name: String)  ## Called by the change animation action
signal action_event(event_name: String)  ## Called by the event action

@export var dialog_box: DialogBox

var player_ref: Player = null  ## Filled in by Player
var time_in_dialog: float = 0.0

func _enter_tree() -> void:
	visible = false

func present(data: DialogData) -> void:
	dialog_box.present(data)
	visible = true
	if player_ref != null:  # Required when not running in-game
		player_ref.can_move = false
		player_ref.is_looking = true
		player_ref.mouse_locked = false
	time_in_dialog = 0
	dialog_opened.emit()

func close(closed_early: bool = false) -> void:
	dialog_box.close()
	visible = false
	if player_ref != null:  # Required when not running in-game
		player_ref.can_move = true
		player_ref.is_looking = false
		player_ref.mouse_locked = true
	dialog_closed.emit(closed_early)
	update_speaking.emit(false)
	time_in_dialog = 0

func _process(delta: float) -> void:
	if visible:
		time_in_dialog += delta

func _input(event: InputEvent) -> void:
	if visible and Input.is_action_just_pressed("exit_dialog") and time_in_dialog > 1.0:
		close(true)
