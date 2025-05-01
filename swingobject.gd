extends StaticBody2D
var anim
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if S.swinging:
		anim = true
		
	if anim:
		animationdo()

func animationdo():
	$AnimationPlayer.play("new_animation")
	anim = false
