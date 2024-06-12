extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$mainCharacter/UI/MobCounter.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Enemies.get_child_count() == 0:
		$mainCharacter/UI/MobCounter.visible = true
		$mainCharacter/UI/RespawnInfo.text = "Gratulacje!!!"
		$mainCharacter/UI/RespawnInfo.modulate.a = 1
		await wait(3.0)
		$mainCharacter/UI/RespawnInfo.text = "Powrót do\nmenu głównego..."
		await wait(2.0)
		get_tree().change_scene_to_file("res://main.tscn")

func wait(time):
	await get_tree().create_timer(time).timeout
