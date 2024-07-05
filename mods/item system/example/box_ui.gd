extends PanelContainer

@export var box_store:ItemStore

func update_item(inventory : Array):
	for index in $VBoxContainer.get_child_count():
		$VBoxContainer.get_child(index).queue_free()
	if box_store != null:
		for item in inventory:
			# 获取物品图鉴
			var item_library = _get_item_library()
			# 获取物品数据(已防止无效路径)
			var item_data = item_library.get_item(item["item_id"]).duplicate()
			var label = Label.new()
			label.text = item_data["name"] + " x" + str(item["quantity"])
			$VBoxContainer.add_child(label)

func _ready():
	if box_store != null:
		box_store.inventory_changed.connect(update_item)
	update_item(box_store.inventory)

func _get_item_library() -> _ItemLibrary:
	var item_library = get_node_or_null("/root/ItemLibrary")
	if item_library == null:
		var _item_library = _ItemLibrary.new()
		_item_library.name = "ItemLibrary"
		get_tree().root.add_child(_item_library)
		item_library = _item_library
	return item_library
