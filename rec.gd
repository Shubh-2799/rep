extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D
var positioncheck
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if S.reset == true and S.done == false:
		if S.rot_count == 0 or S.rot_count == 1:
			S.mainscore += S.perswingscore
		else:
			S.mainscore += S.perswingscore * S.rot_count
		
		S.rot_count = 0
		S.perswingscore = 0
		S.done = true
	$Label4.global_position = player.global_position + Vector2(100, -70)
	$Label2.global_position = player.global_position + Vector2(10, -350)
	$Label3.global_position = player.global_position + Vector2(70,-70)
	$Label2.text = "Score: " + str(S.mainscore)
	if S.flipp:
		#distance = player.global_position.distance_to(positioncheck)
		#print(slowscore)
		if not S.dash:
			S.perswingscore += 1
		elif S.dash:
			S.perswingscore += 20
		$Label3.text = "+" + str(S.perswingscore)
		$Label3.visible = true
		positioncheck = player.global_position
	elif S.flipp == false:
		$Label3.visible = false
