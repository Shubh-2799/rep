extends Label
var player:CharacterBody2D
func _ready() -> void:
	player = $".."
func _process(delta: float) -> void:
	text = "Velocity x  :" + str(player.velocity.x)
