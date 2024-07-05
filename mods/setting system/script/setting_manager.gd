class_name _SettingManager extends Node

const SETTING_PATH = "user://setting.json"

signal setting_changed(option_name, value)

var settings = {}

func _ready():
	if not _load_settings():
		default_setting()
	apply_setting()

# 获取设置
func get_setting(option_name):
	return settings.get(option_name)

# 添加/改变设置
func set_setting(option_name, value):
	settings[option_name] = value
	setting_changed.emit(option_name, value)
	_save_settings()

# 初始设置
func default_setting():
	settings["music_volume"] = 0.5
	settings["sound_volume"] = 0.7
	settings["language"] = "en"

# 应用设置
func apply_setting():
	for option_name in settings.keys():
		setting_changed.emit(option_name,settings[option_name])

# 保存设置
func _save_settings():
	var file = FileAccess.open(SETTING_PATH,FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(settings))

# 加载设置
func _load_settings() -> bool:
	var file = FileAccess.open(SETTING_PATH,FileAccess.READ)
	if file:
		settings = JSON.parse_string(file.get_as_text())
		return true
	return false
