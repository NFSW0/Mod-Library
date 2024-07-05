## 物品系统父类 其他mod主要依赖此节点
class_name ItemSystem extends Node

## 获取物品图鉴
func _get_item_library() -> _ItemLibrary:
	var item_library = get_node_or_null("/root/ItemLibrary")
	if item_library == null:
		var _item_library = _ItemLibrary.new()
		_item_library.name = "ItemLibrary"
		get_tree().root.add_child(_item_library)
		item_library = _item_library
	return item_library
