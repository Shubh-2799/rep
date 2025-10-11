extends Node2D
@export var street_lamp_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var satellite_scene: PackedScene
@export var spinasteroid_scene: PackedScene
@export var static_body_scene: PackedScene  # Preloaded StaticBody2D scene# Distance ahead of player to spawn
@export var despawn_distance: float = 700  # Distance behind player to despawn
@export var min_gap: float = 100  # Minimum gap between spawns
var chunk_size := Vector2(2000, 2000) # ek chunk ka size
var active_radius := 2                # kitne chunks tak load karna hai (x aur y)
var loaded_chunks := {} 
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
var x_pos
func _ready():
	$CanvasLayer.visible = false
	S.jumppad = false
	S.oncooldown = false
	S.score = 0
	S.mainscore = 0
	S.perswingscore = 0
	player = $CharacterBody2D
	positioncheck = player.global_position
func _process(delta):
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
		S.perswingscore += 1 * S.multi 
		$Label3.text = "+" + str(S.perswingscore)
		$Label3.visible = true
		positioncheck = player.global_position
	elif S.flipp == false:
		$Label3.visible = false
	if player.global_position.y > dedzone :
		player.queue_free()
		get_tree().change_scene_to_file("res://a.tscn")
	if S.justgamble:
		S.gamble = false
		S.justgamble = false
		$Control/CanvasLayer.visible = true
		print("aagaya")
		
	var player_chunk = get_chunk_coords(player.global_position)
	#update_chunks(player_chunk)
	spawn_if_needed()
	despawn_old_objects()

func get_chunk_coords(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos.x / chunk_size.x), floor(pos.y / chunk_size.y))


func update_chunks(center_chunk: Vector2i):
	var needed_chunks = []

	# Center ke around active_radius tak chunks collect karo
	for x in range(center_chunk.x - active_radius, center_chunk.x + active_radius + 1):
		for y in range(center_chunk.y - active_radius, center_chunk.y + active_radius + 1):
			needed_chunks.append(Vector2i(x, y))

	# Load new chunks
	for chunk in needed_chunks:
		if not loaded_chunks.has(chunk):
			spawn_chunk(chunk.x , chunk.y)

	# Unload chunks jo ab nahi chahiye
	for chunk in loaded_chunks.keys():
		if chunk not in needed_chunks:
			despawn_chunk(chunk)


func spawn_chunk(chunk_x: int, chunk_y: int):
	var chunk_size = 2000
	var num_to_spawn = 20
	var min_distance = 400  # minimum gap between spawned objects

	if not loaded_chunks.has(Vector2i(chunk_x, chunk_y)):
		loaded_chunks[Vector2i(chunk_x, chunk_y)] = []

	var chunk_origin = Vector2(chunk_x * chunk_size, chunk_y * chunk_size)
	var placed_positions: Array[Vector2] = []

	for i in range(num_to_spawn):
		var new_body = static_body_scene.instantiate()
		var try_count = 0
		var pos: Vector2

		while true:
			# random position inside this chunk
			pos = chunk_origin + Vector2(
				randf_range(200, chunk_size - 200),
				randf_range(200, chunk_size - 200)
			)

			# check distance from all placed objects in this chunk
			var too_close = false
			for existing_pos in placed_positions:
				if existing_pos.distance_to(pos) < min_distance:
					too_close = true
					break

			if not too_close:
				break

			try_count += 1
			if try_count > 20: # give up after 20 tries
				break

		placed_positions.append(pos)
		new_body.global_position = pos
		add_child(new_body)
		loaded_chunks[Vector2i(chunk_x, chunk_y)].append(new_body)


func despawn_chunk(chunk: Vector2i):
	if loaded_chunks.has(chunk):
		for obj in loaded_chunks[chunk]:
			obj.queue_free()
		loaded_chunks.erase(chunk)

func spawn_if_needed():
	var spawn_distance = clamp(player.velocity.length() * 2 , 1200 , 2000)
	var num_to_spawn := 50

	# Only check distance, not object_count
	if player.global_position.x + spawn_distance > last_spawn_x + min_gap:
		var current_y = player.global_position.y + randf_range(-3600, -1600)

		for i in range(num_to_spawn):
			var selection = randi_range(1, 10)
			var new_body
			var new_body_name: String

			if selection == 21 and platformspawning:
				new_body = street_lamp_scene.instantiate()
				new_body_name = "platform"
			elif selection == 3:
				var obstacle_selection = randi_range(1, 4)
				if obstacle_selection == 1:
					new_body = satellite_scene.instantiate()
					new_body_name = "satellite"
				elif obstacle_selection == 2:
					new_body = spinasteroid_scene.instantiate()
					new_body_name = "spinasteroid"
				else:
					new_body = obstacle_scene.instantiate()
					new_body_name = "obstacle"
			else:
				new_body = static_body_scene.instantiate()
				new_body_name = "normal"

			# Scaling
			var xscale: float
			var yscale: float
			if new_body_name == "obstacle":
				xscale = randf_range(0.01 , 0.02)
				yscale = randf_range(0.08 , 0.1)
			elif new_body_name == "satellite":
				xscale = 5
				yscale = 5
			elif new_body_name == "spinasteroid":
				xscale = 2
				yscale = 2
			elif new_body_name == "platform":
				xscale = randf_range(-0.7, -0.9)
				yscale = 0.03
			else:
				xscale = 0.059
				yscale = 0.415

			new_body.scale = Vector2(xscale, yscale)

			# Y-position
			if new_body_name == "spinasteroid":
				current_y += randf_range(100, 400)
			else:
				current_y += randf_range(500, 1000)

			# X-position
			var x_pos: float
			if new_body_name == "spinasteroid":
				x_pos = player.global_position.x + spawn_distance + randf_range(1000, 1200)
			else:
				x_pos = player.global_position.x + spawn_distance + randf_range(-100, 100)

			if new_body_name == "platform":
				new_body.global_position = Vector2(player.global_position.x + 1900, current_y)
				$"platform timer".start()
				platformspawning = false
			else:
				new_body.global_position = Vector2(x_pos, current_y)

			add_child(new_body)
			spawned_objects.append(new_body)
			last_spawn_x = max(last_spawn_x, new_body.global_position.x)

func despawn_old_objects():
	for obj in spawned_objects:
		if obj.global_position.x < player.global_position.x - despawn_distance:
			obj.queue_free()
			spawned_objects.erase(obj)
			


func _on_timer_timeout() -> void:
	$Label.visible = false


func _on_platform_timer_timeout() -> void:
	platformspawning = true
