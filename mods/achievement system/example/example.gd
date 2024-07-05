extends Node

func _ready():
	print("添加自动加载节点:AchievementManager")
	var achievement_manager = get_node_or_null("/root/AchievementManager")
	if !achievement_manager:
		var _achievement_manager = _AchievementManager.new()
		_achievement_manager.name = "AchievementManager"
		await get_tree().create_timer(0.1).timeout
		get_tree().root.add_child(_achievement_manager)


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
		print("测试1:尝试达成成就first_kill")
		var achievement_manager = get_node_or_null("/root/AchievementManager")
		if achievement_manager:
			achievement_manager.rpc("unlock_achievement","first_kill")
	if event.is_action_pressed("test2"):
		print("测试2:尝试达成成就first_die")
		var achievement_manager = get_node_or_null("/root/AchievementManager")
		if achievement_manager:
			achievement_manager.rpc("unlock_achievement","first_die")
