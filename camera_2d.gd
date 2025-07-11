extends Camera2D


@export var min_zoom = Vector2(1.2,1.2)
@export var max_zoom = Vector2(0.5,0.5)
var max_speed = 1000.0
var min_speed = 100.0
@onready var player = get_parent()
var zoom_speed = 5.0
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed = player.velocity.length()
	if player.velocity.y < 0:
		var t = clamp(speed/max_speed , 0.0 , 1.0)
		var target_zoom = min_zoom.lerp(max_zoom , t)
		zoom = zoom.lerp(target_zoom,1.0 * delta)
	else:
		zoom = zoom.lerp(Vector2(1.2,1.2), 1.0 * delta)
