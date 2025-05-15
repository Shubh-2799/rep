extends CanvasModulate
var t = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if t != 1:
		t = clamp(t+delta,0,1)
	else:
		t = clamp(-(t+delta) ,1,0)
	var colors = Color(1.0-t,t,0.0)
	color = colors
