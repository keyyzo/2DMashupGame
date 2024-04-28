class_name JumpingPlayerState

extends PlayerMovementState

@export var BASE_SPEED : float = 400.0
@export var BASE_ACCELERATION_RATE : float = 30.0
@export var BASE_DECELERATION_RATE : float = 40.0
@export var BASE_JUMP_VELOCITY : float = -500.0
@export var WALL_JUMP_KNOCKBACK_STRENGTH : float = 600.0


func enter(previous_state) -> void:
	print("Player is now Jumping")
	PLAYER.velocity.y = BASE_JUMP_VELOCITY
	
	if previous_state.name == "WallJumpingPlayerState":
		if PLAYER.input_direction < 0:
			PLAYER.velocity.x = -WALL_JUMP_KNOCKBACK_STRENGTH
		elif PLAYER.input_direction > 0:
			PLAYER.velocity.x = WALL_JUMP_KNOCKBACK_STRENGTH
		
	PLAYER.can_double_jump = true
	
func exit() -> void:
	pass
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(BASE_SPEED,BASE_ACCELERATION_RATE,BASE_DECELERATION_RATE)
	PLAYER.update_velocity()
	
	if PLAYER.velocity.length() == 0.0 and PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
		
	if PLAYER.velocity.y > 10.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
		
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
		
	#if PLAYER.velocity.length() > 0.0 and !PLAYER.is_on_floor() and PLAYER.is_on_wall():
		#transition.emit("WallJumpingPlayerState")
		
	if PLAYER.is_on_wall() and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		transition.emit("WallJumpingPlayerState")
		
	if Input.is_action_just_pressed("dash") and PLAYER.NUM_OF_DASHES > 0:
		transition.emit("DashingPlayerState")
		
	if Input.is_action_just_pressed("jump") and PLAYER.can_double_jump == true:
		transition.emit("DoubleJumpPlayerState")
