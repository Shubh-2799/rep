extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if S.dash == false:
		body.queue_free()
		S.oncooldown = false
		S.swinging = false
		get_tree().change_scene_to_file("res://a.tscn")
