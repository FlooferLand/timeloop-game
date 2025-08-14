extends PanelContainer

@export var status_label: Label
@export var login_button: Button
@export var bg: TextureRect

var logged_in := false

func _ready() -> void:
	_update_status(NGTyped.instance.session)
	login_button.pressed.connect(func() -> void:
		NGTyped.instance.sign_in()
		login_button.disabled = true
		status_label.text = "Signing in.."
		await get_tree().create_timer(10).timeout
		if not NGTyped.instance.session.is_signed_in():
			status_label.text = "Timed out. Try again"
			login_button.disabled = false
	)
	NGTyped.instance.on_session_change.connect(func(session: NewgroundsSession) -> void:
		if not login_button.disabled or session.is_signed_in():
			_update_status(session)
		await get_tree().create_timer(0.5).timeout
		NGTyped.instance.refresh_session()
	)

func _update_status(session: NewgroundsSession) -> void:
	var signed_in: bool = NGTyped.instance.signed_in
	if session == null:
		signed_in = false
	login_button.visible = not signed_in
	
	var user_name := ""
	if signed_in and session.user != null and session.user.name != null:
		user_name = session.user.name
	status_label.text = ("Signed in as %s!" % user_name) if signed_in else "Not logged in"
	logged_in = signed_in
	login_button.disabled = false

func _process(delta: float) -> void:
	bg.modulate = bg.modulate.lerp(Color.WHITE if logged_in else Color.TRANSPARENT, 2.0 * delta)
