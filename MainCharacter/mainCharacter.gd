extends CharacterBody2D

var health : int = 10
const SPEED : float = 300.0
const JUMP_VELOCITY : float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation : AnimationPlayer = get_node("AnimationPlayer")

# State = animation name
enum STATE {RUN, JUMP, FALL, IDLE, HURT}

var state_animation = {
	STATE.RUN: "Run",
	STATE.JUMP: "Fall",
	STATE.FALL: "Jump",
	STATE.IDLE: "Idle",
	STATE.HURT: "Hurt"
}

@onready var current_state : STATE = STATE.IDLE

func log_debug(string: String, use_time: bool = true):
	var ms_from_start = str(Time.get_ticks_msec())
	
	var prefix = "[" + get_name()
	if use_time:
		prefix += " @ " + ms_from_start
	prefix += "]: "
	
	print(prefix + string)

func set_state(new_state: STATE):
	if current_state == new_state:
		return
	
	log_debug("New State - \"" + STATE.keys()[new_state] + "\"")
	current_state = new_state

func sync_animation_with_current_state():
		if animation.current_animation != state_animation[current_state]:
			animation.play(state_animation[current_state])
			
func process_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		set_state(STATE.JUMP)
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			set_state(STATE.RUN)
	else:	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			set_state(STATE.IDLE)
		if velocity.y > 0:
			set_state(STATE.FALL)
			
func process_death():
	animation.play("Hurt")
	queue_free()
	get_tree().change_scene_to_file("res://main.tscn")

func _physics_process(delta):
	sync_animation_with_current_state()
	
	if current_state == STATE.HURT:
		return
		
	process_movement(delta)

	if health <= 0:
		process_death()
		return
		
	move_and_slide()

func on_hurt_animation_finished(animationName: String):
	set_state(STATE.IDLE)
