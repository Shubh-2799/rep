extends CanvasLayer

var i: int = 0
@onready var skin: AnimatedSprite2D = $CenterContainer/AnimatedSprite2D
@onready var preceeding: AnimatedSprite2D = $CenterContainer/AnimatedSprite2D2
@onready var succeeding: AnimatedSprite2D = $CenterContainer/AnimatedSprite2D3
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if i == 0:
		$Button2.disabled = true
	elif i == 6:
		$Button.disabled = true
	else:
		$Button.disabled = false
		$Button2.disabled = false
	if i == 0:
		skin.play("default")
		preceeding.visible = false
		succeeding.play("cletus")
		label.text = "Default"
	elif i == 1:
		skin.play("cletus")
		preceeding.visible = true
		preceeding.play("default")
		succeeding.play("felix")
		label.text = "Cletus"
	elif i == 2:
		skin.play("felix")
		preceeding.play("cletus")
		succeeding.play("tomo")
		label.text = "Felix"
	elif i == 3:
		skin.play("tomo")
		preceeding.play("felix")
		succeeding.play("monkey")
		label.text = "Tomo"
	elif i == 4:
		skin.play("monkey")
		preceeding.play("tomo")
		succeeding.scale = Vector2(3.37 , 3.473)
		succeeding.play("four")
		label.text = "Monkey Man"
	elif i == 5:
		skin.scale = Vector2(5.37,5.534)
		skin.play("four")
		succeeding.visible = true
		succeeding.play("raven")
		succeeding.scale = Vector2(0.4 , 0.412)
		preceeding.play("monkey")
		label.text = "Mr. Four"
	elif i == 6:
		skin.scale = Vector2(0.7,0.721)
		skin.play("raven")
		succeeding.visible = false
		preceeding.play("four")
		label.text = "...."
	
	print(i)


func _on_button_pressed() -> void:
	i += 1


func _on_button_2_pressed() -> void:
	i -= 1


func _on_button_3_pressed() -> void:
	S.skin_number = i
	get_tree().change_scene_to_file("res://mainmenu.tscn")
