# 主要功能:加载UI
# 常见案例
# 玩家生成后加载角色UI
# 按下聊天按键后加载聊天UI
class_name _UIManager extends CanvasLayer

func get_ui(ui_path: String) -> Node:
	var ui_name = ui_path.rsplit("/")[-1].rstrip(".tscn")
	# 检查UI是否已经加载
	for child_node in get_children():
		if child_node.name == ui_name:
			return child_node
	# 从目录加载UI
	if ResourceLoader.exists(ui_path):
		var ui_instantiate = (load(ui_path) as PackedScene).instantiate()
		ui_instantiate.name = ui_name
		add_child(ui_instantiate)
		return ui_instantiate
	return null
