extends CharacterBody2D


const SPEED = 80
var chase = false
@onready var animation : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var direction : Vector2 = Vector2.RIGHT
@onready var old_direction : Vector2 = Vector2.RIGHT

func _ready():
	animation.play("Fly")

func _process(_delta):
	if animation.animation != "Death":
		animation.play("Fly")
		old_direction = direction
		if chase: #chasing player when he detected it
			var player = get_node("../../mainCharacter")
			direction = (player.position - self.position).normalized()
		else: # chilling otherwise
			if direction.x > 0:
				direction = Vector2.RIGHT
			else:
				direction = Vector2.LEFT
		if sign(direction.x) != sign(old_direction.x):
			scale.x *= -1
		velocity = direction * SPEED
		move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "mainCharacter":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "mainCharacter":
		velocity = Vector2.ZERO
		chase = false

# I'll make them relevant 
func kill_enemy():
		$HitDetection/CollisionShape2D.queue_free()
		Game.killed_enemies += 1
		velocity = Vector2.ZERO
		chase = false
		animation.play("Death")
		await animation.animation_finished
		self.queue_free()
func handle_hit():
	kill_enemy()


func _on_hit_detection_body_entered(body):
	if body.name == "mainCharacter":
		Game.killed_enemies -= 1
		body.take_damage(3)
		body.velocity = Vector2.ZERO
		$AnimatedSprite2D.scale *= 2
		kill_enemy()
	elif chase == false:
		direction *= -1
		scale.x *= -1




func _on_hit_detection_area_entered(area):
	if area.name == "Weapon":
		kill_enemy()
