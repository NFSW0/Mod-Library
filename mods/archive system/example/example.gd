extends Node

var archive_array : PackedStringArray
var random_archive : String

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
		print("测试1:添加新存档")
		ArchiveManager.save_archive_data("archive1",ArchiveManager.ARCHIVE_TYPE.player,{"number":1})
	if event.is_action_pressed("test2"):
		print("测试2:获取存档列表")
		archive_array = ArchiveManager.get_archive_array()
		print(archive_array)
	if event.is_action_pressed("test3"):
		print("测试3:读取首个存档")
		random_archive = archive_array[0] if not archive_array.is_empty() else ""
		var data = ArchiveManager.get_archive_data(random_archive,ArchiveManager.ARCHIVE_TYPE.player)
		print(random_archive,":",data)
	if event.is_action_pressed("test4"):
		print("测试4:修改读取的存档")
		var number = randi_range(1,100)
		var new_data = {"number":number}
		ArchiveManager.save_archive_data(random_archive,ArchiveManager.ARCHIVE_TYPE.player,new_data)
	if event.is_action_pressed("test5"):
		print("测试5:重新读取存档")
		var data = ArchiveManager.get_archive_data(random_archive,ArchiveManager.ARCHIVE_TYPE.player)
		print(random_archive,":",data)
