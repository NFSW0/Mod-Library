extends Node


func _input(event):
	if event.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://mod_library.tscn")
	if event.is_action_pressed("host"):
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_server(7777, 4)
		if error:
			print("服务器创建失败")
			return
		multiplayer.multiplayer_peer = peer
		print("已创建服务器")
		multiplayer.peer_connected.connect(func(id):$Node2.set_multiplayer_authority(id))
	if event.is_action_pressed("join"):
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_client("127.0.0.1", 7777)
		if error:
			print("服务器加入失败")
			return
		multiplayer.multiplayer_peer = peer
		print("已加入服务器")
		$Node2.set_multiplayer_authority(multiplayer.get_unique_id())
	if event.is_action_pressed("test1"):
		print("测试1:添加单例节点(服务端用于运算，客户端用于响应)")
		var usable_item_manager = get_node_or_null("/root/UsableItemManager")
		if !usable_item_manager:
			var _usable_item_manager = _UsableItemManager.new()
			_usable_item_manager.name = "UsableItemManager"
			get_tree().root.add_child(_usable_item_manager)
	if event.is_action_pressed("test2"):
		print("测试2:服务端 使用0号物品")
		var usable_item_manager = get_node_or_null("/root/UsableItemManager")
		if usable_item_manager:
			usable_item_manager.rpc_id(1,"use_item",0,$Node1.get_instance_id(),Vector3.ZERO)
	if event.is_action_pressed("test3"):
		print("测试3:客户端 使用0号物品")
		var usable_item_manager = get_node_or_null("/root/UsableItemManager")
		if usable_item_manager:
			usable_item_manager.rpc_id(1,"use_item",0,$Node2.get_instance_id(),Vector3.ZERO)
