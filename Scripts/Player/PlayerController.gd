class_name PlayerController

extends CharacterBody2D


# General Movement Variables

@export var BASE_SPEED : float = 100.0
@export var BASE_ACCELERATION_RATE : float = 10.0
@export var BASE_DECELERATION_RATE : float = 20.0
var input_direction : float

# Jump variables

@export var BASE_JUMP_VELOCITY : float = -200.0
var can_jump : bool = true


# Double Jump Variables
@export var DOUBLE_jUMP_VELOCITY : float = -50.0
var can_double_jump : bool = false
var double_jump_unlocked : bool = true

# Dash Variables

@export var NUM_OF_DASHES : int = 1
@export var DASH_LENGTH_TIME : float = 0.2
@export var DASH_COOLDOWN : float = 2.0
var can_dash : bool = true
var dash_unlocked : bool = true

# Wall Jump / Slide variables
@export var WALL_SLIDE_FALL_GRACE_LENGTH : float = 1.0
@export var PUSH_OFF_FALL_GRACE_LENGTH : float = 0.3
@export var WALL_COLLIDER : RayCast2D
var is_wall_sliding : bool = false
var last_wall_normal : float = 0.0
var wall_jump_unlocked : bool = true


# Melee variables
@export var MELEE_SIDE_HITBOX : Area2D
@export var MELEE_TOP_HITBOX : Area2D
@export var MELEE_BOTTOM_HITBOX : Area2D
@export var MELEE_RESET_LENGTH : float = 0.3
@export var MELEE_ATTACK_LENGTH : float = 0.3
var can_melee_attack : bool = true

# Range Variables


var can_range_attack : bool = false
var range_attack_unlocked : bool = true

# Gravity variables

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var wall_jump_gravity : int = 150
var normal_gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var updated_normal_gravity : int = 600


var gravity_to_use : int


func _ready() -> void:
	Global.player = self
	gravity_to_use = updated_normal_gravity
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	pass
	
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = BASE_JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * BASE_SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, BASE_SPEED)
#
	#move_and_slide()
	
	if Input.is_action_just_pressed("attack") and can_melee_attack == true:
		can_melee_attack = false
		melee_attack()
	
	
func update_input(_speed : float, _acceleration : float, _deceleration : float):
	var direction = Input.get_axis("move_left","move_right")
	
	if is_wall_sliding == false:
		if direction == 1:
			WALL_COLLIDER.scale.x = 1
			MELEE_SIDE_HITBOX.scale.x = 1
		if direction == -1:
			WALL_COLLIDER.scale.x = -1
			MELEE_SIDE_HITBOX.scale.x = -1
	
	
	input_direction = direction
	
	if direction and is_wall_sliding != true:
		velocity.x += direction * _acceleration
		velocity.x = clampf(velocity.x, -_speed,_speed)
	else:
		velocity.x = move_toward(velocity.x, 0.0, _deceleration)
	
func update_velocity() -> void:
	move_and_slide()
	
func update_gravity(delta) -> void:
	if not is_on_floor() and not is_on_wall():
		velocity.y += gravity_to_use * delta
	if not is_on_floor() and is_on_wall():
		velocity.y += gravity_to_use * delta
		clampf(velocity.y,0,gravity_to_use)
		
func wall_collider_check() -> bool:
	return WALL_COLLIDER.is_colliding()
		
		
func melee_attack():
	print("attacking with melee")
	$MeleeHitboxSide/MeleeSideCollider.set_deferred("disabled",false)
	#MELEE_SIDE_HITBOX.set_deferred("Monitoring", true)
	$MeleeHitboxSide/AnimatedSprite2D.show()
	$MeleeHitboxSide/AnimatedSprite2D.frame = randi_range(0,2)
	await get_tree().create_timer(MELEE_ATTACK_LENGTH).timeout
	#MELEE_SIDE_HITBOX.set_deferred("Monitoring", false)
	$MeleeHitboxSide/MeleeSideCollider.set_deferred("disabled",true)
	$MeleeHitboxSide/AnimatedSprite2D.hide()
	print("melee attack finished")
	melee_reset()
	#can_melee_attack = true
	
func melee_reset():
	await get_tree().create_timer(MELEE_RESET_LENGTH).timeout
	can_melee_attack = true
	print("can melee again")
	
