extends Node2D




func _on_play_pressed():
	Game.endless = true
	get_tree().change_scene_to_file("res://Levels/poziom_1.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
