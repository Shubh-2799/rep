extends Sprite2D


func _process(delta: float) -> void:
	position.x = $"../CharacterBody2D".position.x
