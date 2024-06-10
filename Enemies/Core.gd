extends CharacterBody2D

const SPEED : int = 100
var chase = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var direction : int = 1
@onready var old_direction : int = 1

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
			print(player.position.x - self.position.x)
			direction = sign(player.position.x - self.position.x)
		else: # chilling otherwise
			pass # większość będzie w checkach i guess
		if direction != old_direction:
			pass
			#scale.x *= -1
		velocity.x = direction * SPEED
		move_and_slide()



func _on_player_detection_body_entered(body):
	if body.name == "mainCharacter":
		print("Started chasing")
		#chase = true


func _on_player_detection_body_exited(body):
	if body.name == "mainCharacter":
		print("stopped chasing")
		chase = false


func _on_left_platform_checker_body_exited(body):
	if !chase:
		print("lost left")
		if direction == -1:
			pass
			#scale.x *= -1 
		direction = 1
func _on_right_platform_checker_body_exited(body):
	if !chase:
		print("lost right")
		if direction == 1:
			pass
			#scale.x *= -1 
		direction = -1
		


func _on_area_hitbox_body_entered(body):
	print("Bump!")
	if !chase:
		direction *= -1



