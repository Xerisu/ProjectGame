extends CharacterBody2D

const SPEED = 350
@onready var player = get_node("../../mainCharacter") 
@onready var animation : AnimatedSprite2D = $Hitbox/AnimatedSprite2D
@onready var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Fly")
	direction = (player.position - self.position).normalized()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity = direction * SPEED
	$Hitbox.rotation = velocity.angle()
	move_and_slide()


func _on_hitbox_body_entered(body):
	if body.name == "mainCharacter":
		direction = Vector2.ZERO
		velocity = Vector2.ZERO
		body.take_damage(3)
		animation.play("Explosion")
		await animation.animation_finished
		queue_free()


func _on_despawn_timeout():
	queue_free()
