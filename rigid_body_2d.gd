extends RigidBody2D

var spd = 200
var dir = 1
var spawn_pos 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	spawn_pos = position
func _physics_process(delta) -> void:
	linear_velocity = Vector2(spd * dir , 0)
	
	if position.x > spawn_pos.x + 400:
		dir = -1
	elif position.x < spawn_pos.x + 100:
		dir = 1
