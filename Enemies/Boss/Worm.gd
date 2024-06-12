extends CharacterBody2D


const SPEED = 120
@onready var player = get_node("../../mainCharacter") 
@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var direction : int = 1
@onready var health : int = 30
@onready var fireball : PackedScene = preload("res://Enemies/Boss/Fireball.tscn")
@onready var spawns : PackedScene = preload("res://Enemies/FlyingAbomination/FlyingAbomination.tscn")
var firstSpawn = true
var secondSpawn = true
var invincible = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	animation.play("Walk")
	$CanvasLayer/HealthBar.init_health(health)

func _physics_process(delta):
	if $AnimatedSprite2D.animation == "Walk":
		if not is_on_floor():
			velocity.y = gravity * delta
		velocity.x = direction * SPEED
	else:
		velocity = Vector2.ZERO
	if direction < 0:
		scale.y = -2
		rotation = PI
	if direction > 0:
		scale.y = 2
		rotation = 0
	move_and_slide()


func _on_hurt_player_body_entered(body):
	if body.name == "mainCharacter":
		body.take_damage(2)

func take_damage(damage):
	if !invincible:
		health -= damage
		animation.play("Hurt")
		$CanvasLayer/HealthBar._set_health(health)
		await animation.animation_finished
		animation.play("Walk")
	if health <= 0:
		$AttackTimer.queue_free()
		$HurtPlayer.queue_free()
		$CollisionShape2D.queue_free()
		animation.play("Death")
		await animation.animation_finished
		queue_free()
	if health <= 20 and firstSpawn:
		firstSpawn = false
		spawn()
	if health <= 10 and secondSpawn:
		secondSpawn = false
		spawn()
	

func attack():
	var fireballTemp = fireball.instantiate()
	var fireballPosition = self.position
	if direction > 0:
		fireballPosition += Vector2(60,-10)
	else: 
		fireballPosition += Vector2(-60,-10)
	fireballTemp.position = fireballPosition
	add_sibling(fireballTemp)

func spawn():
	invincible = true
	animation.play("Attack")
	await get_tree().create_timer(1.1).timeout
	animation.play("Walk")
	for i in range(5):
		var spawnTemp = spawns.instantiate()
		var spawnPosition = self.position + Vector2(200-100*i, -40)
		spawnTemp.position = spawnPosition
		add_sibling(spawnTemp)
	invincible = false


func _on_attack_timer_timeout():
	if $AnimatedSprite2D.animation != "Walk":
		await animation.animation_finished
	direction = sign(player.position.x - self.position.x)
	animation.play("Attack")
	await animation.animation_finished
	animation.play("Idle")
	await get_tree().create_timer(1.0).timeout
	animation.play("Walk")


func _on_turn_body_entered(body):
	if body.name != "Weapon" and body.name != "Worm" and body.name != "mainCharacter":
		direction *= -1
