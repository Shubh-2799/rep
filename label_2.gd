extends Label

func _process(delta: float) -> void:
	$".".text = $"../..".velocity.x
