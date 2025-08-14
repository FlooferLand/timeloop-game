extends Node

enum Brand {
	None = -1,
	Unknown = 0,
	PlayStation,
	Valve,
	Xbox
}

## A state changed regarding the input connection
signal connection_state_changed(connected: bool)

## The state changed regarding the input method that is currently active
## Ex: User switched devices and is now playing on the keyboard, but the controller is still on
## Note: This will also be called when the controller is connected/disconnected
signal active_state_changed(controller_active: bool)

const BRAND_KEYWORDS: Dictionary[Brand, PackedStringArray] = {
	Brand.PlayStation: ["ps4", "ps5", "dualshock", "dualsense", "playstation"],
	Brand.Valve: ["valve", "steam"],
	Brand.Xbox: ["xbox", "xinput", "microsoft"],
}
const MAPPINGS: Dictionary[Brand, JoypadMapping] = {
	Brand.Xbox: preload("uid://bm3wnq186ypup"),
	Brand.PlayStation: preload("uid://d2gwfhyq6j3i5"),
	Brand.Unknown: preload("uid://dy3tg4hh5jxrv")
}

var _brand_cached: Brand = Brand.None
var connected: bool = false
var controller_active: bool = false
var device: int = 0

func _enter_tree() -> void:
	connected = not Input.get_connected_joypads().is_empty()
	Input.joy_connection_changed.connect(func(device: int, connected: bool) -> void:
		self.connected = connected
		self.controller_active = connected
		self.device = device
		connection_state_changed.emit(connected)
		if connected:
			_update_brand_name()
		active_state_changed.emit(connected)
	)

func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	# Keyboard should now be active
	if controller_active:
		if event is InputEventKey:
			controller_active = false
			active_state_changed.emit(false)
			return
	
	# Controller should now be active
	if not controller_active:
		if event is InputEventJoypadButton:
			var button := event as InputEventJoypadButton
			controller_active = true
			active_state_changed.emit(true)
			device = button.device
		elif event is InputEventJoypadMotion:
			var motion := event as InputEventJoypadMotion
			controller_active = true
			active_state_changed.emit(true)
			device = motion.device

## Updates and caches the brand name for further use
## NOTE: Should probably check via GUID, but that might be a bit less reliable?
func _update_brand_name() -> void:
	var joypad_name := Input.get_joy_name(device).to_lower()
	for brand: Brand in BRAND_KEYWORDS.keys():
		if brand <= 0:
			return
		var keywords: PackedStringArray = BRAND_KEYWORDS.get(brand)
		for value: String in keywords:
			if joypad_name.contains(value):
				_brand_cached = brand
				return
	# TODO: Move this to a user-facing error display system
	if _brand_cached <= 0:
		push_error("No brand found for controller '%s'" % Input.get_joy_name(device))

## Calls this function on *any* state changed, regardless of the state.
## Can still check the state via JoypadManager.connected
func connect_state_changed(callable: Callable) -> void:
	connection_state_changed.connect(callable.unbind(1))
	active_state_changed.connect(callable.unbind(1))

## Gets the name of the band
## It does a checkup for the first time its called, but it caches the result
func get_brand() -> Brand:
	if _brand_cached == Brand.None:
		_update_brand_name()
	return _brand_cached
	
## Returns the name for the controller input button
func get_name_for_input(button: JoyButton) -> StringName:
	var brand: Brand = get_brand()
	if brand == Brand.None:
		return "NONE"
	var map := MAPPINGS[brand]
	if button in map.mappings:
		return map.mappings[button]
	elif button in MAPPINGS[Brand.Unknown].mappings:
		return MAPPINGS[Brand.Unknown].mappings[button]
	return "?"

## Returns true if the action has a controller entry
func has_action(action: StringName) -> bool:
	var events := InputMap.action_get_events(action)
	for event in events:
		if event is InputEventJoypadButton \
		or event is InputEventJoypadMotion:
			return true
	return false
