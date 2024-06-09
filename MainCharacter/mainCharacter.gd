extends CharacterBody2D

var health : int = 10
var invincible : bool = false
var can_attack : bool = true
const SPEED : float = 300.0
const JUMP_VELOCITY : float = -400.0
@onready var direction : int = 1
@onready var old_direction : int = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation : AnimationPlayer = $AnimationPlayer

# State = animation name
enum STATE {RUN, JUMP, FALL, IDLE, HURT, DEATH, ATTACK}

const NOT_CONTOLLED_STATES : Array[STATE] = [STATE.HURT, STATE.DEATH, STATE.ATTACK]

var state_animation = {
	STATE.RUN: "Run",
	STATE.JUMP: "Jump",
	STATE.FALL: "Fall",
	STATE.IDLE: "Idle",
	STATE.HURT: "Hurt",
	STATE.DEATH: "Death",
	STATE.ATTACK: "Attack",
}

@onready var current_state : STATE = STATE.IDLE

func _ready():
	$Weapon/WeaponCollision.set_deferred("Disabled", true) #nie działa

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
	if Input.is_action_just_pressed("attack") and can_attack == true:
		set_state(STATE.ATTACK)
		can_attack = false
		$Weapon/AttackTimer.start()
		velocity.y = 0
		return
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		set_state(STATE.JUMP)
	if direction != 0:
		old_direction = direction
	direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		if direction != old_direction:
			scale.x *= -1

		velocity.x = direction * SPEED
		if velocity.y == 0:
			set_state(STATE.RUN)
	else:	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			set_state(STATE.IDLE)
		if velocity.y > 0:
			set_state(STATE.FALL)
	

func on_death_animation_finished():
	queue_free()
	get_tree().change_scene_to_file("res://main.tscn")

func take_damage(damage):
	if !invincible:
		health -= damage
		invincible = true
		set_state(STATE.HURT)
		$Timer.start()
		modulate.a = 0.5


func _physics_process(delta):
	sync_animation_with_current_state()
	
	if current_state in NOT_CONTOLLED_STATES: 
		return
		
	process_movement(delta)

	if health <= 0:
		$Camera2D.zoom.x = 5
		$Camera2D.zoom.y = 5
		set_state(STATE.DEATH)
		return
		
	move_and_slide()

func set_idle_state():
	set_state(STATE.IDLE)


func _on_timer_timeout():
	invincible = false
	modulate.a = 1
	# koniec wizualnej rzeczy


func _on_attack_timer_timeout():
	can_attack = true


