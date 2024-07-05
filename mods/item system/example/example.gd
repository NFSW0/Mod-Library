extends Node

@export var store1:ItemStore
@export var store2:ItemStore
@export var store3:ItemStore

var item_id = 0

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
		multiplayer.peer_connected.connect(func(id):store3.set_multiplayer_authority(id))
	if event.is_action_pressed("join"):
		var peer = ENetMultiplayerPeer.new()
		var error = peer.create_client("127.0.0.1", 7777)
		if error:
			print("服务器加入失败")
			return
		multiplayer.multiplayer_peer = peer
		print("已加入服务器")
		store3.set_multiplayer_authority(multiplayer.get_unique_id())
	if event.is_action("test1"):
		print("测试1:服务端 添加随机正负数物品")
		if store1 != null:
			var quantity = randi_range(-20,20)
			store1.rpc("append_item",item_id,quantity)
	if event.is_action("test2"):
		print("测试2:客户端->主机 正常随机增减物品")
		if store2 != null:
			var quantity = randi_range(-20,20)
			if quantity < 0:
				quantity = -quantity
				store2.rpc_id(multiplayer.get_peers()[0],"erase_item",item_id,quantity)
			else:
				store2.rpc_id(multiplayer.get_peers()[0],"append_item",item_id,quantity)
	if event.is_action("test3"):
		print("测试3:客户端->主机 正常随机增减物品(单次)")
		if store3 != null:
			var quantity = randi_range(-20,20)
			if quantity < 0:
				quantity = -quantity
				store3.rpc_id(multiplayer.get_peers()[0],"erase_item",item_id,quantity)
			else:
				store3.rpc_id(multiplayer.get_peers()[0],"append_item",item_id,quantity)
