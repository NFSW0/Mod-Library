# TODO 由于存在结果返回值，不易同步，考虑传递额外参数，实现对合成结果的使用
# NOTE 合成管理考虑独立处理，由合成者处理同步问题
## 合成配方字典，键为合成结果，值包含原料、条件、结果数量
class_name _CraftingManager extends Node

## 已注册配方
# "result_item_id_1": {"ingredients": {"item_id_1": 2, "item_id_2": 1}, "conditions": ["condition_1"], "quantity": 1},
# "result_item_id_2": {"ingredients": {"item_id_2": 1, "item_id_3": 1}, "conditions": ["condition_2"], "quantity": 1},
var recipes : Dictionary = {}

## 原料索引
# "item_id_1":["result_item_id_1"],
# "item_id_2":["result_item_id_1","result_item_id_2"],
# "item_id_3":["result_item_id_2"],
var materials_index : Dictionary = {}

## 条件索引
# "condition_1":["result_item_id_1"],
# "condition_2":["result_item_id_2"],
var conditions_index : Dictionary = {}

## 注册合成配方
func register_recipe(result: int, ingredients: Dictionary, conditions: Array = ["None"], quantity: int = 1):
	# 添加配方
	recipes[result] = {"ingredients": ingredients, "conditions": conditions, "quantity": quantity}
	# 添加原料索引
	for material in ingredients:
		if materials_index.has(material):
			materials_index[material].append(result)
		else:
			materials_index[material] = [result]
	# 添加条件索引
	for condition in conditions:
		if conditions_index.has(condition):
			conditions_index[condition].append(result)
		else:
			conditions_index[condition] = [result]

## 处理合成请求
func craft(ingredients: Array, conditions: Array = ["None"]) -> Dictionary:
	# 查询涉及相同材料的配方
	var material_recipes:Array = materials_index.get(ingredients[0], [])
	# 查询涉及相同条件的配方
	var condition_recipes:Array = conditions_index.get(conditions[0], [])
	# 剔除无关配方
	var matching_recipes:Array = material_recipes.filter(func(element):return condition_recipes.has(element))
	# 遍历所有相关的合成配方 为减少此性能损耗 注册的合成配方可以考虑动态变化
	for result in matching_recipes:
		# 获取当前合成配方的材料和条件
		var recipe_ingredients = recipes[result]["ingredients"]
		var recipe_conditions = recipes[result]["conditions"]
		# 检查当前合成配方的条件是否满足
		if _check_conditions(recipe_conditions, conditions):
			# 如果条件满足，检查材料是否符合合成配方
			if _check_ingredients(recipe_ingredients, ingredients):
				# 如果条件和材料都满足，返回合成结果
				var quantity:int = recipes[result]["quantity"]
				return {"item_id":result,"quantity":quantity}
	# 如果没有匹配的合成配方或条件不满足，返回空字符串表示无法合成
	return {}

## 检查条件是否满足
func _check_conditions(recipe_conditions: Array, player_conditions: Array) -> bool:
	for condition in recipe_conditions:
		if condition not in player_conditions:
			return false
	return true

## 检查材料是否符合合成配方
func _check_ingredients(recipe_ingredients: Dictionary, ingredients: Array) -> bool:
	for ingredient in recipe_ingredients.keys():
		if ingredients.count(ingredient) < recipe_ingredients[ingredient]:
			return false
	return true
