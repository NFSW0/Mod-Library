extends Node


var buff1_path:String = "res://mods/buff system/example/example_buff1.tres"
var buff2_path:String = "res://mods/buff system/example/example_buff2.tres"


func _ready():
	print("添加自动加载节点:BuffManager")
	var buff_manager = get_node_or_null("/root/BuffManager")
	if !buff_manager:
		var _buff_manager = _BuffManager.new()
		_buff_manager.name = "BuffManager"
		await get_tree().create_timer(0.1).timeout
		get_tree().root.add_child(_buff_manager)


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
		print("测试1:添加BuffManager监听")
		var buff_manager = get_node_or_null("/root/BuffManager")
		if buff_manager:
			buff_manager.new_buff_appended.connect(func(buff_info:BuffInfo):
				if buff_info.buff_target == $Node1:
					var label = Label.new()
					label.text = buff_info.buff_data.buff_name
					$Node1/Sprite2D/VBoxContainer.add_child(label))
	if event.is_action_pressed("test2"):
		print("测试2:调试Buff1")
		var buff_manager = get_node_or_null("/root/BuffManager")
		if buff_manager:
			if ResourceLoader.exists(buff1_path):
				var buff1:BuffData = load(buff1_path)
				buff_manager.rpc_id(1,"append_buff",buff1.resource_path,$Node1.get_instance_id(),$Node2.get_instance_id())
	if event.is_action_pressed("test3"):
		print("测试3:调试Buff2")
		var buff_manager = get_node_or_null("/root/BuffManager")
		if buff_manager:
			if ResourceLoader.exists(buff2_path):
				var buff2:BuffData = load(buff2_path)
				buff_manager.rpc_id(1,"append_buff",buff2.resource_path,$Node2.get_instance_id(),$Node1.get_instance_id())
	if event.is_action_pressed("test4"):
		print("测试4:创建多人服务器")
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_server(7777, 4)
		if error:
			print("服务器创建失败")
			return
		multiplayer.multiplayer_peer = peer
		print("已创建服务器")
	if event.is_action_pressed("test5"):
		print("测试5:加入多人服务器")
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_client("127.0.0.1", 7777)
		if error:
			print(error)
			return
		multiplayer.multiplayer_peer = peer



## 多人传递节点
@rpc("any_peer","call_local","reliable")
func debug1(node_id):
	var node = instance_from_id(node_id)
	print(node.name)
## 多人传递资源
@rpc("any_peer","call_local","reliable")
func debug2(resource_path):
	var resource = load(resource_path)
	print(resource.buff_name)
