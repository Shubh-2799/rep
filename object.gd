extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func throw():
	S.throw = true
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	S.release_velocity = body.velocity
	throw()
