extends Area2D
@onready var animation : AnimatedSprite2D = get_node("AnimatedSprite2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "mainCharacter":
		body.health += 2
		queue_free()
