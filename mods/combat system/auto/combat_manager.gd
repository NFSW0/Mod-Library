## [自动加载] 战斗管理 用于同步结算伤害
class_name _CombatManager extends Node

## 记录所有待结算伤害
var damage_infos : Array[Dictionary] = []

## 添加伤害信息 攻击者 受击者 方向角 伤害值
@rpc("any_peer","call_local","reliable")
func append_damage_info(attacker_id:int,defender_id:int,degree,damage):
	if not multiplayer.is_server():
		return
	print("联机ID为 %d 的同伴提交伤害请求" % multiplayer.get_remote_sender_id())
	damage_infos.append({"attacker_id":attacker_id,"defender_id":defender_id,"degree":degree,"damage":damage})

## 伤害结算
func _physics_process(_delta):
	if not multiplayer.is_server():
		return
	# 每完成一个伤害结算就移除一个伤害信息 先进先出
	while damage_infos.size() > 0:
		print("%s 对 %s 以 %s 方向造成 %d 伤害" % [damage_infos[0]["attacker_id"],damage_infos[0]["defender_id"],damage_infos[0]["degree"],damage_infos[0]["damage"]])
		damage_infos.remove_at(0)

