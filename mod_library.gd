extends Control


func _on_buff_pressed():
	get_tree().change_scene_to_file("res://mods/buff system/example/example.tscn")


func _on_item_pressed():
	get_tree().change_scene_to_file("res://mods/item system/example/example.tscn")


func _on_usabel_item_pressed():
	get_tree().change_scene_to_file("res://mods/usable item system/example/example.tscn")


func _on_craft_pressed():
	get_tree().change_scene_to_file("res://mods/craft system/example/example.tscn")


func _on_achievement_pressed():
	get_tree().change_scene_to_file("res://mods/achievement system/example/example.tscn")


func _on_archive_pressed():
	get_tree().change_scene_to_file("res://mods/archive system/example/example.tscn")


func _on_combat_pressed():
	get_tree().change_scene_to_file("res://mods/combat system/example/example.tscn")


func _on_ui_pressed():
	get_tree().change_scene_to_file("res://mods/ui system/example/example.tscn")
