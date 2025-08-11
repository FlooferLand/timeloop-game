extends HBoxContainer

@export var debug_menu: DebugMenuType
@export var options: OptionButton
@export var add_button: Button

var items: Dictionary[InventoryItem.Id, InventoryItem] = {}

func _enter_tree() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	
	var items_dir := "res://assets/resources/items/"
	var items_dir_contents := ResourceLoader.list_directory(items_dir)
	for item_dir in items_dir_contents:
		if not item_dir.ends_with('/'): continue
		var contents := ResourceLoader.list_directory(items_dir + item_dir)
		for res_file in contents:
			if not res_file.ends_with(".tres") and not res_file.ends_with(".res"): continue
			var item: InventoryItem = ResourceLoader.load(items_dir + item_dir + res_file)
			var image := item.image.get_image()
			image.resize(32, 32)
			options.add_icon_item(ImageTexture.create_from_image(image), item.name, item.id)
			items[item.id] = item
	
	add_button.pressed.connect(func() -> void:
		if debug_menu.player_ref == null: return
		var item := items[options.get_selected_id() as InventoryItem.Id]
		debug_menu.player_ref.inventory_comp.add_item(item)
	)
