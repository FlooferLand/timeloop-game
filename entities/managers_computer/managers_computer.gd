class_name ManagersComputer extends Node2D

@export var room: Room

@export_group("Local")
@export var interact_comp: InteractComponent
@export var computer_os: ComputerOS

var manager_entered := false
var player_on_puter := false

func _ready() -> void:
	interact_comp.interact_condition = func(player: Player) -> bool:
		return not manager_entered
	interact_comp.on_player_interact.connect(func(player: Player) -> void:
		start()
	)
	room.entity_entered.connect(func(entity: CharacterBody2D) -> void:
		if entity is TheManagerEntity:
			manager_entered = true
			exit()
	)
	room.entity_exited.connect(func(entity: CharacterBody2D) -> void:
		if entity is TheManagerEntity:
			manager_entered = false
	)

func start() -> void:
	computer_os.boot()
	player_on_puter = true

func exit() -> void:
	computer_os.shut_down()
	player_on_puter = false
