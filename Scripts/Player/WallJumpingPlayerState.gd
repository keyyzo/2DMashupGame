class_name WallJumpingPlayerState

extends PlayerMovementState

@export var BASE_SPEED : float = 400.0
@export var BASE_ACCELERATION_RATE : float = 30.0
@export var BASE_DECELERATION_RATE : float = 40.0
@export var BASE_JUMP_VELOCITY : float = -400.0

@export var FALL_GRACE_TIMER : Timer

@export var WALL_COLLIDER : RayCast2D

var grace_period_started : bool = false
var grace_period_finished : bool = false

func enter(previous_state) -> void:
	print("Player is now Wall Jumping")
	PLAYER.velocity.y = 0
	PLAYER.gravity_to_use = PLAYER.wall_jump_gravity
	PLAYER.is_wall_sliding = true
	
	
func exit() -> void:
	PLAYER.gravity_to_use = PLAYER.normal_gravity
	PLAYER.is_wall_sliding = false
	grace_period_finished = false
	grace_period_started = false
	FALL_GRACE_TIMER.stop()
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(BASE_SPEED,BASE_ACCELERATION_RATE,BASE_DECELERATION_RATE)
	PLAYER.update_velocity()
	
	if PLAYER.wall_collider_check():
		PLAYER.last_wall_normal = WALL_COLLIDER.get_collision_normal().x
		#print(str(PLAYER.last_wall_normal))
	
	if PLAYER.velocity.length() == 0.0 and PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
		
	if PLAYER.velocity.y > 10.0 and !PLAYER.is_on_floor() and !PLAYER.is_on_wall():
		print("1st Fall call")
		transition.emit("FallingPlayerState")
		
	if PLAYER.is_on_wall_only() and !PLAYER.is_on_floor() and (!Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right")):
		if grace_period_started == false:
			grace_period_activated(PLAYER.WALL_SLIDE_FALL_GRACE_LENGTH)
		#FALL_GRACE_TIMER.start(PLAYER.WALL_SLIDE_FALL_GRACE_LENGTH)
		#print("Grace period activated")
		
		if grace_period_finished == true:
			transition.emit("FallingPlayerState")
			print("2nd Fall call")
	
	if PLAYER.is_on_wall_only() and !PLAYER.is_on_floor() and PLAYER.input_direction != 0:
		if (PLAYER.last_wall_normal == 1 and PLAYER.input_direction == 1) or (PLAYER.last_wall_normal == -1 and PLAYER.input_direction == -1):
		
			if grace_period_started == false:
				grace_period_activated(PLAYER.PUSH_OFF_FALL_GRACE_LENGTH)
			#FALL_GRACE_TIMER.start(PLAYER.WALL_SLIDE_FALL_GRACE_LENGTH)
			#print("Grace period activated")
			
			
			if grace_period_finished == true:
				transition.emit("FallingPlayerState")
				print("2nd Fall call")
		
		
	#if PLAYER.is_on_wall_only() and !PLAYER.is_on_floor() and (!Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right")):
		
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
		
	if Input.is_action_just_pressed("dash") and PLAYER.NUM_OF_DASHES > 0:
		transition.emit("DashingPlayerState")
		
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_wall():
		if PLAYER.last_wall_normal == 1 and Input.is_action_pressed("move_right"):
			transition.emit("JumpingPlayerState")
		elif PLAYER.last_wall_normal == -1 and Input.is_action_pressed("move_left"):
			transition.emit("JumpingPlayerState")
		

	

func _on_fall_grace_timer_timeout() -> void:
	grace_period_finished = true
	print("Timer finished")
	transition.emit("FallingPlayerState")
	
func grace_period_activated(length_of_grace:float):
	FALL_GRACE_TIMER.start(length_of_grace)
	print("Grace period activated")
	grace_period_started = true
