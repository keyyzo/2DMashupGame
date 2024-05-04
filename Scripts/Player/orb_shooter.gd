class_name OrbShooter

extends Node2D

@export var PIVOT_POINT : Node2D
@export var SHOOTING_POINT : Marker2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	PIVOT_POINT.look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("attack") and Global.player.can_range_attack == true:
		shoot()
		Global.player.can_range_attack = false


func shoot():
	pass
