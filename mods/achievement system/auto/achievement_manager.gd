## 成就管理器
class_name _AchievementManager extends Node

## 数据文件路径
const DEFAULT_ACHIEVEMENT_PATH := "res://mods/achievement system/assets/default_achievement.json"
const SAVE_ACHIEVEMENT_PATH := "user://achievements.json"

## 成就达成信号
signal achieve(achievement_name:String)

## 成就数据
var achievements := {}

func _ready():
	if FileAccess.file_exists(SAVE_ACHIEVEMENT_PATH):
		var file = FileAccess.open(SAVE_ACHIEVEMENT_PATH, FileAccess.READ)
		achievements = JSON.parse_string(file.get_as_text())
	else:
		var file = FileAccess.open(DEFAULT_ACHIEVEMENT_PATH, FileAccess.READ)
		achievements = JSON.parse_string(file.get_as_text())

## 获取成就信息
func get_achievement(achievement_name: String) -> Dictionary:
	return achievements.get(achievement_name,{})

## 达成成就
@rpc("any_peer","call_local","reliable")
func unlock_achievement(achievement_name: String) -> void:
	# 成就不存在
	if not achievements.has(achievement_name):
		print("成就 %s 不存在" % achievement_name)
		return
	# 成就已解锁
	if achievements[achievement_name]["unlocked"]:
		print("成就 %s 已解锁" % achievement_name)
		return
	# 解锁成就
	print(multiplayer.get_unique_id(), "解锁成就：", achievement_name)
	achievements[achievement_name]["unlocked"] = true
	# 发射成就达成信号
	achieve.emit(achievement_name)
	# 保存成就数据
	var file = FileAccess.open(SAVE_ACHIEVEMENT_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(achievements))
