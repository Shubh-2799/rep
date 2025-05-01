extends StaticBody2D

var ehe
var shape 
var player
var sprite
var b = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shape = $CollisionShape2D2
	var center = global_position + shape.shape.size / 2
	shape.disabled = true
	player = $CharacterBody2D
	sprite = $AnimatedSprite2D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rest():
	S.resting = true
	


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	rest()
	var cord = body.global_position.x
	var cordy = global_position.y
	body.velocity = Vector2(0,0)
	body.position = Vector2(cord, cordy)
	$Area2D.visible = false


func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	S.resting = false
	S.ftime = true


func _on_area_2d_2_body_entered(body: CharacterBody2D) -> void:
	S.jumppad = true
	S.jump = false
	strt()
	
func strt():
	b = true
