extends Node2D
@export var street_lamp_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var static_body_scene: PackedScene  # Preloaded StaticBody2D scene
@export var spawn_distance: float = 500  # Distance ahead of player to spawn
@export var despawn_distance: float = 700  # Distance behind player to despawn
@export var min_gap: float = 100  # Minimum gap between spawns
@export var object_count: int = 10
var new_body_name
var dedzone: int = 2000
var player: CharacterBody2D
var last_spawn_x: float = -INF
var spawned_objects = []
var selection = 1
var new_body
var positioncheck
var slowscore:float
var distance
func _ready():
	S.oncooldown = false
	S.score = 0
	S.mainscore = 0
	S.perswingscore = 0
	player = $CharacterBody2D
	positioncheck = player.global_position
func _process(delta):
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
	$Label.global_position = player.global_position + Vector2(-120 , -100)
	$Label2.text = "Score: " + str(S.mainscore)
	if S.flipp:
		#distance = player.global_position.distance_to(positioncheck)
		#print(slowscore)
		S.perswingscore += 1
		$Label3.text = "+" + str(S.perswingscore)
		$Label3.visible = true
		positioncheck = player.global_position
	elif S.flipp == false:
		$Label3.visible = false
	if player.global_position.y > dedzone :
		player.queue_free()
		get_tree().change_scene_to_file("res://a.tscn")
	spawn_if_needed()
	despawn_old_objects()

func spawn_if_needed():
	
	if new_body_name == "platform":
		spawn_distance = 3400
	else:
		spawn_distance = 1000
	selection = randi_range(1,10)
	if player.global_position.x + spawn_distance > last_spawn_x + min_gap and object_count:
		if selection == 21:
			new_body = street_lamp_scene.instantiate() as StaticBody2D 
			new_body_name = "platform"
		elif selection == 3 or selection == 4:
			new_body = obstacle_scene.instantiate() as StaticBody2D
			new_body_name = "obstacle"
		else:
			new_body = static_body_scene.instantiate() as StaticBody2D
			new_body_name = "normal"
		
		object_count -= 1
		var y_pos = randf_range(player.global_position.y - 200 , player.global_position.y + 200)
		var xscale:float
		var yscale:float
		if selection != 2:
			if selection == 3 or selection == 4:
				xscale = randf_range(0.03 , 0.05)
				yscale = randf_range(0.2 , 0.4)
			else:
				xscale = randf_range(0.0423 , 0.0913)
				yscale = 0.415
		elif selection == 21:
			xscale = randf_range(-0.7,-0.9)
			yscale = 0.03
		
		new_body.scale = Vector2(xscale, yscale)
		if new_body_name == "normal":
			new_body.global_position = Vector2(player.global_position.x + spawn_distance, y_pos)
		elif new_body_name == "platform":
			new_body.global_position = Vector2(player.global_position.x + 1900, y_pos)
		elif new_body_name == "obstacle":
			new_body.global_position = Vector2(player.global_position.x + spawn_distance, y_pos)
		add_child(new_body)
		spawned_objects.append(new_body)
		
		last_spawn_x = new_body.global_position.x  
		if selection == 21:
			print("long spawned at : " , new_body.global_position)
			print("player position : " , player.global_position)
func despawn_old_objects():
	for obj in spawned_objects:
		if obj.global_position.x < player.global_position.x - despawn_distance:
			obj.queue_free()
			object_count += 1
			spawned_objects.erase(obj)
			


func _on_timer_timeout() -> void:
	$Label.visible = false
