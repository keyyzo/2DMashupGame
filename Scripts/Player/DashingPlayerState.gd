class_name DashingPlayerState

extends PlayerMovementState

@export var BASE_SPEED : float = 1200.0
@export var BASE_ACCELERATION_RATE : float = 200.0
@export var BASE_DECELERATION_RATE : float = 40.0
@export var BASE_JUMP_VELOCITY : float = -400.0
@export var DASH_TIMER : Timer
var DASHING : bool = false

func enter(previous_state) -> void:
	print("Player is now Dashing")
	DASHING = true
	PLAYER.NUM_OF_DASHES -= 1
	DASH_TIMER.start(PLAYER.DASH_LENGTH_TIME)
	
func exit() -> void:
	DASHING = false
	DASH_TIMER.stop()
	regain_dash()
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(BASE_SPEED,BASE_ACCELERATION_RATE,BASE_DECELERATION_RATE)
	PLAYER.update_velocity()
	
	#if PLAYER.velocity.length() == 0.0 and PLAYER.is_on_floor():
		#transition.emit("IdlePlayerState")
		#
	#if PLAYER.velocity.y > 10.0 and !PLAYER.is_on_floor():
		#transition.emit("FallingPlayerState")
		#
	#if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		#transition.emit("JumpingPlayerState")
		#
	#if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		#transition.emit("WalkingPlayerState")
	if PLAYER.is_on_wall():
		transition.emit("WallJumpingPlayerState")
		
	if DASHING == false:
		transition.emit("WalkingPlayerState")
		
func regain_dash():
	await get_tree().create_timer(PLAYER.DASH_COOLDOWN).timeout
	PLAYER.NUM_OF_DASHES += 1
	print("One dash has been regained")


func _on_dash_length_timeout() -> void:
	DASHING = false
	
