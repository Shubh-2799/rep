extends Label

var check = 0
var rot 
func _process(delta: float) -> void:
	rot = S.rot_count
	if S.flipp:
		if rot > check:
			text = "x" + str(rot)
			if rot > 1:
				
				visible = true
				get_tree().create_timer(0.2).timeout.connect(func(): invisible())
			check += 1
	elif S.flipp == false:
		check = -1
	
func invisible():
	visible = false
