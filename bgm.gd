extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if S.gamble:
		if not $AudioStreamPlayer.playing:
			stop()
			$AudioStreamPlayer.play()
	else:
		if not playing:
			$AudioStreamPlayer.stop()
			play()
