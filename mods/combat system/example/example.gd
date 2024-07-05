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
	if event.is_action_pressed("join"):
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_client("127.0.0.1", 7777)
		if error:
			print("服务器加入失败")
			return
		multiplayer.multiplayer_peer = peer
		print("已加入服务器")
	if event.is_action_pressed("test1"):
		print("测试1:添加CombatManager单例")
		var combat_manager = get_node_or_null("/root/CombatManager")
		if !combat_manager:
			var _combat_manager = _CombatManager.new()
			_combat_manager.name = "CombatManager"
			get_tree().root.add_child(_combat_manager)
	if event.is_action_pressed("test2"):
		print("测试2:Node1 对 Node2 造成伤害")
		var combat_manager = get_node_or_null("/root/CombatManager")
		if combat_manager:
			combat_manager.rpc_id(1,"append_damage_info",$Node1.get_instance_id(),$Node2.get_instance_id(),1,1)
	if event.is_action_pressed("test3"):
		print("测试3:Node2 对 Node1 造成伤害")
		var combat_manager = get_node_or_null("/root/CombatManager")
		if combat_manager:
			combat_manager.rpc_id(1,"append_damage_info",$Node1.get_instance_id(),$Node2.get_instance_id(),1,1)
