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
		print("测试1:单例UIManager")
		var ui_manager = get_node_or_null("/root/UIManager")
		if !ui_manager:
			var _ui_manager = _UIManager.new()
			_ui_manager.name = "UIManager"
			get_tree().root.add_child(_ui_manager)
	if event.is_action_pressed("test2"):
		print("测试2:加载UI")
		var ui_manager = get_node_or_null("/root/UIManager")
		if ui_manager:
			ui_manager.get_ui("res://mods/ui system/example/example_ui.tscn")
