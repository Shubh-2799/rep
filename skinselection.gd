extends CanvasLayer

var i: int = 0
@onready var skin: AnimatedSprite2D = $CenterContainer/AnimatedSprite2D
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if i == 0:
		$Button2.disabled = true
	elif i == 5:
		$Button.disabled = true
	else:
		$Button.disabled = false
		$Button2.disabled = false
	if i == 0:
		skin.play("default")
		label.text = "Default"
	elif i == 1:
		skin.play("cletus")
		label.text = "Cletus"
	elif i == 2:
		skin.play("felix")
		label.text = "Felix"
	elif i == 3:
		skin.play("tomo")
		label.text = "Tomo"
	elif i == 4:
		skin.play("monkey")
		label.text = "Monkey Man"
	elif i == 5:
		skin.play("four")
		label.text = "Mr. Four"
	


func _on_button_pressed() -> void:
	i += 1


func _on_button_2_pressed() -> void:
	i -= 1


func _on_button_3_pressed() -> void:
	S.skin_number = i
	get_tree().change_scene_to_file("res://mainmenu.tscn")
