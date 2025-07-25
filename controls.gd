extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Back.visible = false
	$Back.disabled = true
	$Label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_controls_pressed() -> void:
	$StarSwing.visible = false
	$Play.visible = false
	$Play.disabled = true
	$Controls.visible = false
	$Controls.disabled = true
	$Quit.visible = false
	$Quit.disabled = true
	$Back.visible = true
	$Back.disabled = false
	$Label.visible = true


func _on_back_pressed() -> void:
	$StarSwing.visible = true
	$Play.visible = true
	$Play.disabled = false
	$Controls.visible = true
	$Controls.disabled = false
	$Quit.visible = true
	$Quit.disabled = false
	$Back.visible = false
	$Back.disabled = true
	$Label.visible = false
