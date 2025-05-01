extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body) -> void:
	print("area entered")
	if body is CharacterBody2D and body.is_on_floor():
		body.velocity.y = -1600.0
