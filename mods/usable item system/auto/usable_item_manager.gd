## 集中处理物品使用请求 强化多人同步 仅服务端存在
class_name _UsableItemManager extends ItemSystem

## 物品方法字典
var actions:Dictionary = {
	0:&"_print_info",
	1:"_print_info",
}

## 使用物品 rpc_id(1,item_id,user_id,target_position)
@rpc("any_peer","call_local","reliable")# ("傀儡无效","自我有效","低频重要")
func use_item(item_id: int, user_id: int, target_position: Vector3):
	# 仅服务端参与运算 客户端只需响应
	if not multiplayer.is_server():
		return
	# 获取物品图鉴
	var item_library = _get_item_library()
	# 获取物品数据(已防止无效路径)
	var item = item_library.get_item(item_id).duplicate()
	if item["id"] in actions:
		# 获取方法名
		var method_name = actions[item["id"]]
		if has_method(method_name):
			# 触发方法
			print("联机ID为 %d 的同伴发起使用请求:" % multiplayer.get_remote_sender_id())
			rpc(method_name, user_id, target_position)
		else:
			print("此物品指向一个无效的方法:", item["name"])
	else:
		print("此物品无可用方法:",item["name"])


## 调式方法
@rpc("any_peer","call_local","reliable")
func _print_info(user_id:int,target_position:Vector3):
	# 获取使用者节点
	var user = instance_from_id(user_id)
	print("联机ID为 %d 的同伴说: 节点 %s 对目标 %s 使用了物品0" % [multiplayer.get_unique_id(),user.name,target_position])


## 多方法实现案例
@rpc("any_peer","call_local","reliable")
func _call_more_function(user_id:int,target_position:Vector3,methods:Array[StringName]):
	for method in methods:
		if has_method(method):
			rpc(method, user_id, target_position)
