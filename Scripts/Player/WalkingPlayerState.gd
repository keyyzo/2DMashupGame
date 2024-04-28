class_name WalkingPlayerState

extends PlayerMovementState

@export var BASE_SPEED : float = 400.0
@export var BASE_ACCELERATION_RATE : float = 30.0
@export var BASE_DECELERATION_RATE : float = 40.0
@export var BASE_JUMP_VELOCITY : float = -400.0

func enter(previous_state) -> void:
	print("Player is now Walking")
	
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
		
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
		
	if Input.is_action_just_pressed("dash") and PLAYER.NUM_OF_DASHES > 0:
		transition.emit("DashingPlayerState")
