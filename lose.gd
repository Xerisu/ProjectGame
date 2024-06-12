extends Node2D

func _ready():
	
	if Game.phase > Game.bestPhase:
		Game.bestPhase = Game.phase
	if Game.killed_enemies > Game.bestKilledEnemies:
		Game.bestKilledEnemies = Game.killed_enemies
	Utils.saveGame()
	$Stats2.text = "Przeżyte rundy: " + str(Game.phase)
	$Stats2.text += " (Najlepszy wynik: " + str(Game.bestPhase) + ")"
	$Stats2.text += "\nZabici wrogowie: " + str(Game.killed_enemies)
	$Stats2.text += " (Najlepszy wynik: " + str(Game.bestKilledEnemies) + ")"


func _on_play_pressed():
	Game.endless = false
	get_tree().change_scene_to_file("res://Levels/poziom_1.tscn")


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_boss_pressed():
	get_tree().change_scene_to_file("res://Levels/boss.tscn")
