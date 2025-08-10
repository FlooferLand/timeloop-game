class_name ComputerOS extends CanvasLayer

@export var parent: ManagersComputer

@export_group("Local")
@export var shutdown_button: Button

func _enter_tree() -> void:
	visible = false
	shutdown_button.pressed.connect(parent.exit)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit_dialog"):
		parent.exit()  # Calls shut_down on its own

func boot() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func shut_down() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
