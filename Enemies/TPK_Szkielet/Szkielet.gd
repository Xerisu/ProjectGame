extends CharacterBody2D

const SPEED : int = 50
var chase = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_node("../../mainCharacter") 
@onready var animation : AnimationPlayer = $To_Flip/AnimationPlayer
@onready var direction : int = 1
@onready var health : int = 6
@onready var isdead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Walk")
	$HealthBar.init_health(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor() and $To_Flip/AnimatedSprite2D.animation != "Death": 
		velocity.y += gravity * delta
	
	if $To_Flip/AnimatedSprite2D.animation == "Walk":
		if chase: #chasing player when he detected it
			direction = sign(player.position.x - self.position.x)
			if abs(player.position.x - self.position.x) < 60 and abs(player.position.y - self.position.y) < 20 and is_on_floor():
				$To_Flip/AnimatedSprite2D.position.x += 6 
				animation.play("Attack")
				await animation.animation_finished
				$To_Flip/AnimatedSprite2D.position.x -= 6
				animation.play("Walk")
		change_direction()
		velocity.x = direction * SPEED
		move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "mainCharacter":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "mainCharacter":
		chase = false


func _on_left_platform_checker_body_exited(_body):
	if !chase:
		direction = 1
	change_direction()
	
func _on_right_platform_checker_body_exited(_body):
	if !chase:
		direction = -1
	change_direction()
		


func _on_area_hitbox_body_entered(_body):
	if !chase:
		direction *= -1
	change_direction()


func _on_hurt_player_body_entered(body):
	if body.name == "mainCharacter":
		body.take_damage(2)

func take_damage(damage):
	health -= damage
	$HealthBar._set_health(health)
	velocity = Vector2.ZERO
	animation.play("Hurt")
	if health <= 0:
		die()
	await animation.animation_finished
	animation.play("Walk")

func die():
	isdead = true
	$To_Flip/HurtPlayer/CollisionShape2D.queue_free()
	$Hitbox.queue_free()
	$To_Flip/PlayerDetection.queue_free()
	$To_Flip/Weapon/WeaponCollision1.queue_free()
	$To_Flip/Weapon/WeaponCollision2.queue_free()
	Game.killed_enemies += 1
	velocity = Vector2.ZERO
	chase = false
	animation.play("Death")
	await animation.animation_finished
	queue_free()

func _on_weapon_body_entered(body):
	if body.has_method("take_damage") and body != self:
		body.take_damage(4)
		
func change_direction():
	if !isdead:
		if direction > 0:
			$To_Flip.scale.x = 1
			$Hitbox.scale.x = 1
		if direction < 0:
			$To_Flip.scale.x = -1
			$Hitbox.scale.x = -1
