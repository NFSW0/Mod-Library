extends Node

func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://mod_library.tscn")
	if event.is_action_pressed("test1"):
		print("测试1:添加自动加载节点:CraftingManager")
		var crafting_manager = get_node_or_null("/root/CraftingManager")
		if !crafting_manager:
			var _crafting_manager = _CraftingManager.new()
			_crafting_manager.name = "CraftingManager"
			get_tree().root.add_child(_crafting_manager)
	if event.is_action_pressed("test2"):
		print("测试2:注册配方 - 铁剑(有效) - 船(无效)")
		var crafting_manager = get_node_or_null("/root/CraftingManager")
		if crafting_manager != null:
			# 注册配方
			(crafting_manager as _CraftingManager).register_recipe(-3, {-2: 2, -1: 1}, ["Workbench"],1)
			(crafting_manager as _CraftingManager).register_recipe(-4, {-1: 5}, ["InWater"],1)
	if event.is_action_pressed("test3"):
		print("测试3:正确合成物品")
		var crafting_manager = get_node_or_null("/root/CraftingManager")
		if crafting_manager != null:
			var result = (crafting_manager as _CraftingManager).craft([-2, -2, -1], ["Workbench"])
			if not (result as Dictionary).is_empty():
				print("合成成功,获得: %s(ID:%d) x%d" % [_get_item_library().get_item(result["item_id"])["name"],result["item_id"],result["quantity"]])
			else:
				print("无法合成该物品。")
	if event.is_action_pressed("test4"):
		print("测试4:错误合成物品 - 数量")
		var crafting_manager = get_node_or_null("/root/CraftingManager")
		if crafting_manager != null:
			var result = (crafting_manager as _CraftingManager).craft([-2, -1], ["Workbench"])
			if not (result as Dictionary).is_empty():
				print("合成成功,获得: ID(%d) x%d" % [result["item_id"],result["quantity"]])
			else:
				print("无法合成该物品。")
	if event.is_action_pressed("test5"):
		print("测试5:错误合成物品 - 条件")
		var crafting_manager = get_node_or_null("/root/CraftingManager")
		if crafting_manager != null:
			var result = (crafting_manager as _CraftingManager).craft([-2, -2, -1], ["InWater"])
			if not (result as Dictionary).is_empty():
				print("合成成功,获得: ID(%d) x%d" % [result["item_id"],result["quantity"]])
			else:
				print("无法合成该物品。")
	if event.is_action_pressed("test6"):
		print("测试6:错误合成物品 - 原料")
		var crafting_manager = get_node_or_null("/root/CraftingManager")
		if crafting_manager != null:
			var result = (crafting_manager as _CraftingManager).craft([-2, -2, -2], ["InWater"])
			if not (result as Dictionary).is_empty():
				print("合成成功,获得: ID(%d) x%d" % [result["item_id"],result["quantity"]])
			else:
				print("无法合成该物品。")

## 获取物品图鉴
func _get_item_library() -> _ItemLibrary:
	var item_library = get_node_or_null("/root/ItemLibrary")
	if item_library == null:
		var _item_library = _ItemLibrary.new()
		_item_library.name = "ItemLibrary"
		get_tree().root.add_child(_item_library)
		item_library = _item_library
	return item_library
