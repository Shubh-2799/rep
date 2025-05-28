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
var platformspawning:bool = true
func _ready():
	S.jumppad = false
	S.oncooldown = false
	S.score = 0
	S.mainscore = 0
	S.perswingscore = 0
	player = $CharacterBody2D
	positioncheck = player.global_position
func _process(delta):
	print(player.velocity.x)
	if S.reset == true and S.done == false or S.dash:
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
	if Input.is_action_just_pressed("dash") and S.oncooldown == true:
		$Label3.visible = true
		get_tree().create_timer(0.2).timeout
		$Label3.visible = false
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

	# Number of objects to spawn at once
	var num_to_spawn := 6  # Tum isse customize kar sakte ho

	if player.global_position.x + spawn_distance > last_spawn_x + min_gap and object_count >= num_to_spawn:
		for i in range(num_to_spawn):
			selection = randi_range(1,10)

			var new_body: StaticBody2D
			var new_body_name: String

			if selection == 21 and platformspawning:
				new_body = street_lamp_scene.instantiate() as StaticBody2D 
				new_body_name = "platform"
			elif selection == 3 or selection == 4:
				new_body = obstacle_scene.instantiate() as StaticBody2D
				new_body_name = "obstacle"
			else:
				new_body = static_body_scene.instantiate() as StaticBody2D
				new_body_name = "normal"

			object_count -= 1
			var y_offset = randf_range(-700, -200) + i * 1000  # Vertical spread
			var y_pos = player.global_position.y + y_offset

			var xscale:float
			var yscale:float

			if selection != 2:
				if selection == 3 or selection == 4:
					xscale = randf_range(0.01 , 0.02)
					yscale = randf_range(0.08 , 0.1)
				else:
					xscale = 0.059
					yscale = 0.415
			elif selection == 21 and platformspawning:
				xscale = randf_range(-0.7,-0.9)
				yscale = 0.03

			new_body.scale = Vector2(xscale, yscale)

			if new_body_name == "normal":
				new_body.global_position = Vector2(player.global_position.x + spawn_distance, y_pos)
			elif new_body_name == "platform":
				new_body.global_position = Vector2(player.global_position.x + 1900, y_pos)
				$"platform timer".start()
				platformspawning = false
			elif new_body_name == "obstacle":
				new_body.global_position = Vector2(player.global_position.x + spawn_distance, y_pos)

			add_child(new_body)
			spawned_objects.append(new_body)
			last_spawn_x = max(last_spawn_x, new_body.global_position.x)  # Track furthest object only

func despawn_old_objects():
	for obj in spawned_objects:
		if obj.global_position.x < player.global_position.x - despawn_distance:
			obj.queue_free()
			object_count += 1
			spawned_objects.erase(obj)
			


func _on_timer_timeout() -> void:
	$Label.visible = false


func _on_platform_timer_timeout() -> void:
	platformspawning = true
