extends CanvasLayer
var multi:float
var dashinc:float
var gravityred:float
var no:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if S.mainscore < 1000:
		$thousand.disabled = true
		$threethousand.disabled = true
		$fivethousand.disabled = true
	elif S.mainscore < 3000:
		$thousand.disabled = false
		$threethousand.disabled = true
		$fivethousand.disabled = true
	elif S.mainscore < 5000:
		$thousand.disabled = false
		$threethousand.disabled = false
		$fivethousand.disabled = true
	else:
		$thousand.disabled = false
		$threethousand.disabled = false
		$fivethousand.disabled = false

func _on__pressed() -> void:
	S.justgamble = true


func _on_thousand_pressed() -> void:
	S.mainscore -= 1000
	multi = 1.3
	dashinc = .1
	gravityred = 0.9
	roll()



func _on_threethousand_pressed() -> void:
	S.mainscore -= 3000
	multi = 2.0
	dashinc = .3
	gravityred = 0.7
	roll()



func _on_fivethousand_pressed() -> void:
	S.mainscore -= 5000
	multi = 3.0
	dashinc = .5
	gravityred = 0.5
	roll()

func roll():
	no = randi_range(1,6)
	if no == 1:
		S.multi = multi
		$AnimationPlayer.play("star")
	elif no == 2:
		S.dashinc = dashinc
		$AnimationPlayer.play("dash")
	elif no == 3:
		S.gravityred = gravityred
		$AnimationPlayer.play("grav")
	else:
		$AnimationPlayer.play("lose")
	print(no)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "grav" or "dash" or "lose" or "star" :
		S.justgamble = true
