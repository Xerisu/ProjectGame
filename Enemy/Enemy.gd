extends CharacterBody2D


const SPEED = 80
const JUMP_VELOCITY = -400.0
var chase = false
@onready var animation : AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready():
	animation.play("Fly")

func _physics_process(_delta):
	if animation.animation != "Death":
		animation.play("Fly")
	if chase == true:
		var player = get_node("../mainCharacter")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			animation.flip_h = true
		elif direction.x < 0:
			animation.flip_h = false
		velocity = direction * SPEED
	elif animation.animation != "Death":
		if animation.flip_h == true:
			velocity.x = 1 * SPEED
		else:
			velocity.x = -1 * SPEED
	move_and_slide()
	#if Input.is_action_just_pressed("ui_down"):
	#	kill_enemy()


func _on_player_detection_body_entered(body):
	if body.name == "mainCharacter":
		print("Started chasing")
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "mainCharacter":
		print("stopped chasing")
		velocity = Vector2.ZERO
		chase = false

# I'll make them relevant 
func kill_enemy():
		velocity = Vector2.ZERO
		chase = false
		animation.play("Death")
		await animation.animation_finished
		self.queue_free()
func handle_hit():
	kill_enemy()


func _on_hit_detection_body_entered(body):
	if body.name == "mainCharacter":
		print("Got hit")
		body.take_damage(2)
		body.velocity = Vector2.ZERO
		#body.get_node("AnimationPlayer").play("Hurt") # działa tylko jak się mocno wpierdolę w bossa
		kill_enemy()
	else:
		animation.flip_h = !animation.flip_h




func _on_hit_detection_area_entered(area):
	if area.name == "Weapon":
		kill_enemy()
