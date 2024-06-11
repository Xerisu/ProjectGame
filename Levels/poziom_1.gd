extends Node2D
@onready var flyer = preload("res://Enemies/FlyingAbomination/FlyingAbomination.tscn")
@onready var skelly = preload("res://Enemies/TPK_Szkielet/Szkielet.tscn")
@onready var star = preload("res://Collectibles/Star.tscn")
@onready var healing = preload("res://Levels/pickups.tscn")
var spawning = false
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.endless:
		var healingTemp = healing.instantiate()
		add_child(healingTemp)
		$mainCharacter/UI/KilledCounter.visible = true
	else:
		Game.health = 10
		Game.killed_enemies = 0
		Game.phase = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Enemies.get_child_count() == 0 and (Game.phase == 0 or Game.endless):
		spawn_enemies()
	if $Enemies.get_child_count() == 0 and Game.phase == 1 and Game.endless == false:
		var starTemp = star.instantiate()
		starTemp.position = Vector2(674, 275)
		add_child(starTemp)
		$mainCharacter/UI/Respawn.start()
		$mainCharacter/UI/RespawnInfo.text = "Dobra robota!"
		$mainCharacter/UI/RespawnInfo.modulate.a = 1
		Game.phase += 1

func spawn_enemies():
	if !spawning:
		spawning = true
		$mainCharacter/UI/Respawn.start()
		$mainCharacter/UI/RespawnInfo.text = "Przygotuj się..."
		$mainCharacter/UI/RespawnInfo.modulate.a = 1
		await get_tree().create_timer(3.0).timeout
		for i in range(10 + Game.phase):
			var flyerTemp = flyer.instantiate()
			flyerTemp.position = Vector2(rng.randi_range(200,1050),rng.randi_range(350,550))
			while flyerTemp.position.distance_to($mainCharacter.position) < 120:
				flyerTemp.position = Vector2(rng.randi_range(200,1050),rng.randi_range(350,550))
			$Enemies.add_child(flyerTemp)	
		var positions = [Vector2(431, 498), Vector2(462, 370), Vector2(926, 496), Vector2(894, 370), Vector2(559, 306), Vector2(809, 303) ]
		for i in range(len(positions)):
			var skellyTemp = skelly.instantiate()
			skellyTemp.position = positions[i]
			$Enemies.add_child(skellyTemp)
		for i in range(Game.phase):
			var skellyTemp = skelly.instantiate()
			skellyTemp.position = Vector2(rng.randi_range(200,1050), 550)
			$Enemies.add_child(skellyTemp)
		var healingTemp = healing.instantiate()
		add_child(healingTemp)
		Game.phase += 1	
		spawning = false
