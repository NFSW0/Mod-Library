## 物品图鉴 用于通过物品ID获取物品数据
class_name _ItemLibrary extends Node

## 图鉴大小 每个图鉴的大小
@export var library_size:int = 100

## 加载的物品图鉴
var item_library:Dictionary = {}

## 特殊物品 用于避免潜在问题
const _default_item = {"id":0,"name":"阿哈的盒子","description":"特殊物品","icon":"/zero.png","stack":64}

## 物品图鉴目录 存放所有图鉴
const _item_libraries_path:String = "res://mods/item system/assets/item_libraries"

## 通过编号获取物品所在图鉴
func get_item(id:int) -> Dictionary:
	# 检查缓存中是否存在该物品数据
	if item_library.has(id):
		# 直接从缓存中获取并返回物品数据
		return item_library[id]
	else:
		# 计算所属图鉴的起始编号
		@warning_ignore("integer_division")
		var library_start = (id / library_size) * library_size + 1
		# 加载对应图鉴的数据
		_load_library(library_start)
		# 再次尝试获取物品数据
		if item_library.has(id):
			return item_library[id]
		else:
			# 如果再次未找到该物品ID，则返回默认物品数据
			return _default_item

## 加载指定起始编号的图鉴数据
func _load_library(start_id: int) -> void:
	# 构建图鉴文件路径
	var file_path = _item_libraries_path.path_join(str(start_id)+".json")
	# 检查文件是否存在
	if FileAccess.file_exists(file_path):
		# 清空当前图鉴数据
		item_library.clear()
		# 从 JSON 文件加载数据
		var json_data = _load_json(file_path)
		# 将加载的数据添加到图鉴中
		for item_id in json_data.keys():
			item_library[int(item_id)] = json_data[item_id]

## 加载 JSON 文件并解析内容
func _load_json(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_str = file.get_as_text()
	file.close()
	return JSON.parse_string(json_str)
