extends CharacterBody2D

const SPEED : int = 100
var chase = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var direction : int = 1
@onready var old_direction : int = 1
@onready var health : int = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation.animation != "Death":
		animation.play("Walk")
		if not is_on_floor():
			velocity.y += gravity * delta
		old_direction = direction
		if chase: #chasing player when he detected it
			var player = get_node("../../mainCharacter") 
			direction = sign(player.position.x - self.position.x)
		else: # chilling otherwise
			pass # większość będzie w checkach i guess
		if direction != old_direction:
			scale.x *= -1
			$LeftPlatformChecker.scale.x *= -1
			$RightPlatformChecker.scale.x *= -1
		velocity.x = direction * SPEED
		move_and_slide()



func _on_player_detection_body_entered(body):
	if body.name == "mainCharacter":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "mainCharacter":
		chase = false


func _on_left_platform_checker_body_exited(body):
	if !chase:
		if direction == -1:
			scale.x *= -1
			$LeftPlatformChecker.scale.x *= -1
			$RightPlatformChecker.scale.x *= -1
		direction = 1
func _on_right_platform_checker_body_exited(body):
	if !chase:
		if direction == 1:
			scale.x *= -1
			$LeftPlatformChecker.scale.x *= -1
			$RightPlatformChecker.scale.x *= -1
		direction = -1
		


func _on_area_hitbox_body_entered(body):
	if !chase:
		direction *= -1
		scale.x *= -1
		$LeftPlatformChecker.scale.x *= -1
		$RightPlatformChecker.scale.x *= -1


func _on_hurt_player_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(2)

func manage_hit(damage):
	health -= damage
	chase = false
	velocity = Vector2.ZERO
	direction = 0
	$ChaseAgain.start()
	if health <= 0:
		die()

func die():
	$HurtPlayer/CollisionShape2D.queue_free()
	$Hitbox.queue_free()
	velocity = Vector2.ZERO
	chase = false
	animation.play("Death")
	await animation.animation_finished
	queue_free()


func _on_chase_again_timeout():
	chase = true
