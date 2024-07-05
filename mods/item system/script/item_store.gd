## 物品存储节点 用于存储物品编号(用于区分物品，允许在编辑器外部设计物品)、物品数量(用于记录)
class_name ItemStore extends ItemSystem

# 存储发生变化时产生信号
signal inventory_changed(inventory : Array)

# 声明最大堆栈大小和库存大小
var max_stack_size : int = 64  # 物品最大堆叠 与数据值取小
var max_inventory_size : int = 36  # 类似于Minecraft的默认库存大小

# 声明库存数组来存储项目
var inventory : Array[Dictionary] = []

## 添加物品
@rpc("any_peer","call_local","reliable")
func append_item(item_id : int, quantity : int) -> int:
	# 多人傀儡体不做运算
	if not is_multiplayer_authority():
		return 0
	# 避免潜在问题
	if quantity < 0:
		return subtract_item(item_id,-quantity)
	# 获取物品图鉴
	var item_library = _get_item_library()
	# 获取物品数据(已防止无效路径)
	var item = item_library.get_item(item_id).duplicate()
	# 获取物品最大可堆叠数量
	var item_max_stack_size = min(max_stack_size,item["stack"])
	# 初始化剩余需存储数量
	var remaining_quantity = quantity
	# 检查该物品是否可以堆放在现有的库存中
	for existing_item in inventory:
		if existing_item["item_id"] == item["id"] and existing_item["quantity"] < item_max_stack_size:
			# 计算堆栈中的剩余空间
			var space_left = item_max_stack_size - existing_item["quantity"]
			# 确定有多少项可以添加到堆栈中
			var items_to_add = min(space_left, remaining_quantity)
			# 更新现有堆栈中的数量
			existing_item["quantity"] += items_to_add
			# 更新剩余需存储数量
			remaining_quantity -= items_to_add
			# 如果添加了所有项，则结束并返回剩余数量
			if remaining_quantity == 0:
				inventory_changed.emit(inventory)
				return 0
	# 检查库存中是否有添加新堆栈的空间
	while remaining_quantity > 0 and len(inventory) < max_inventory_size:
		# 计算有多少项可以添加到一个新的堆栈
		var items_to_add = min(item_max_stack_size, remaining_quantity)
		# 添加一个新的堆栈到库存
		inventory.append({"item_id": item["id"], "quantity": items_to_add})
		# 更新剩余数量
		remaining_quantity -= items_to_add
	# 返回无法存储的剩余数量
	inventory_changed.emit(inventory)
	return remaining_quantity

## 减少物品 可理解为反向的添加物品 会产生负数物品 一般情况不会使用
@rpc("any_peer","call_local","reliable")
func subtract_item(item_id : int, quantity : int) -> int:
	# 多人傀儡体不做运算
	if not is_multiplayer_authority():
		return 0
	# 避免潜在问题
	if quantity < 0:
		return append_item(item_id,-quantity)
	# 获取物品图鉴
	var item_library = _get_item_library()
	# 获取物品数据(已防止无效路径)
	var item = item_library.get_item(item_id).duplicate()
	# 获取物品最大可堆叠数量
	var item_max_stack_size = min(max_stack_size,item["stack"])
	# 初始化剩余待处理数量
	var remaining_quantity = quantity
	# 在库存中逆向查找和删除物品
	for i in range(inventory.size() - 1, -1, -1):
		var current_item = inventory[i]
		# 检查当前项是否与要删除的项匹配
		if current_item["item_id"] == item["id"]:
			# 计算可以从当前堆栈中移除多少项
			var items_to_remove = min(remaining_quantity, current_item["quantity"])
			# 更新当前堆栈的数量
			current_item["quantity"] -= items_to_remove
			# 更新剩余数量
			remaining_quantity -= items_to_remove
			# 如果数量变为零，则从库存中删除该项目
			if current_item["quantity"] == 0:
				inventory.remove_at(i)
			# 检查是否所有要求的项目已被删除并返回剩余数量
			if remaining_quantity == 0:
				break
	# 检查库存中是否有添加新堆栈的空间
	while remaining_quantity > 0 and len(inventory) < max_inventory_size:
		# 计算有多少项可以添加到一个新的堆栈
		var items_to_subtract = min(item_max_stack_size, remaining_quantity)
		# 添加一个新的堆栈到库存
		inventory.append({"item_id": item["id"], "quantity": -items_to_subtract})
		# 更新剩余数量
		remaining_quantity -= items_to_subtract
	# 返回无法存储的剩余数量
	inventory_changed.emit(inventory)
	return -remaining_quantity

## 移除物品
@rpc("any_peer","call_local","reliable")
func erase_item(item_id : int, quantity : int) -> bool:
	# 多人傀儡体不做运算
	if not is_multiplayer_authority():
		return true
	# 避免潜在问题
	if quantity < 0:
		print("<item_system><item_store> 移除物品时参数2应不小于0")
		return false
	# 获取物品图鉴
	var item_library = _get_item_library()
	# 获取物品数据(已防止无效路径)
	var item = item_library.get_item(item_id).duplicate()
	# 初始化剩余数量
	var remaining_quantity = quantity
	# 计算所有槽中指定物品的总数量
	var total_item_quantity = 0
	for inventory_item in inventory:
		# 避免潜在问题
		if not inventory_item.has("item_id"):
			continue
		# 计算总量
		if inventory_item["item_id"] == item["id"]:
			total_item_quantity += inventory_item["quantity"]
	# 检查是否有足够的物品来满足移除请求
	if quantity <= total_item_quantity:
		# 在库存中迭代查找和删除物品
		for i in range(inventory.size() - 1, -1, -1):
			var current_item = inventory[i]
			# 避免潜在问题
			if not current_item.has("item_id"):
				inventory.remove_at(i)
			# 检查当前项是否与要删除的项匹配
			if current_item["item_id"] == item["id"]:
				# 计算可以从当前堆栈中移除多少项
				var items_to_remove = min(remaining_quantity, current_item["quantity"])
				# 更新当前堆栈的数量
				current_item["quantity"] -= items_to_remove
				# 更新剩余数量
				remaining_quantity -= items_to_remove
				# 如果数量变为零，则从库存中删除该项目
				if current_item["quantity"] == 0:
					inventory.remove_at(i)
				# 所有要求的项目已被删除则返回成功
				if remaining_quantity == 0:
					inventory_changed.emit(inventory)
					return true
	else:
		# 库存物品总数不足以满足移除请求
		print("<item_system><item_store> 库存物品总数不足以满足移除请求")
		return false
	# 触发条件:
	# 时机:目标物品总数判定后，完成移除前
	# 事件:部分目标物品数量受其他事件影响发生减少导致无法满足所需移除总数
	print("<item_system><item_store> 这是一次稀有的过度移除，建议把日志发给作者看看")
	subtract_item(item_id,remaining_quantity)
	return true
