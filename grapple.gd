extends Node2D

@onready var raycast = $ShapeCast2D
@onready var player = get_parent()
@onready var line = $Line2D
var actualrotation
var sprite
var pulled: bool = false
var launched: bool = false
var target: Vector2
var rest_length = 50.0  # Rope ki initial length
var stiffness = 10.0 # Rope elasticity
var damping_factor = 10.0  # Damping to slow down movement
var angular_velocity = 6 # Angular velocity for circular motion
var max_angular_velocity = 6000.0 # Maximum speed for swing
var min_angular_velocity:float  # Minimum speed
var pullstrength = 15.0
var pulling: bool = false
var last_swing_direction = 1  # 1 for clockwise, -1 for anti-clockwise
var release_vel:Vector2
var rot_spd = 300
var flip:bool
var throwvel:bool
var counted:bool = false
var aeq = 0.0
var after_swing_rot: bool = false
var playercurrentvelx:float
var collider
var was_swinging:bool = false
func _ready() -> void: 
	S.rot_count = 0
	sprite = $"../AnimatedSprite2D"
	actualrotation = sprite.rotation
	$"../Area2D".area_entered.connect(_on_area_entered)  # Signal connect karo
	release_vel.x = 300
func _on_area_entered(area):
	if area.get_parent() is StaticBody2D:
		pulled = false  # Pull disable
		gretract()  # Grapple bhi retract ho jaye
		
func _process(delta: float) -> void:
	line.set_point_position(0, line.to_local($"../AnimatedSprite2D/Marker2D".global_position))
	playercurrentvelx = player.velocity.x
	if not S.dash:
		sprite.rotation = aeq
		release_vel = lerp(release_vel, Vector2(200.0,200.0) , 0.01)
		raycast.look_at(get_global_mouse_position())
		if S.resting:
			rotation_handle()
			if Input.is_action_just_pressed("left click"):
				pass
		if Input.is_action_just_pressed("left click"):
			if raycast.is_colliding():
				collider = raycast.get_collider(0)
				$"../AnimatedSprite2D".flip_h = false
				if collider and collider.has_method("rest"):
					$"../AnimatedSprite2D".play("grapple")
				elif not collider:
					player.velocity.x = playercurrentvelx
				else:
					$"../AnimatedSprite2D".play("swing")
				var body = raycast.get_collider(0)
				if body.has_method("grapple_anim"):
					body.grapple_anim()
				S.jump = false
				S.jumppad = false
				S.dash = false
				S.swinging = true
				glaunch()
				was_swinging = true
			else:
				pass
		elif Input.is_action_just_pressed("left click") and not raycast.is_colliding():
			player.velocity.x = playercurrentvelx
		if Input.is_action_just_released("left click"):
			gretract()
			S.swinging = false
			player.velocity.x = angular_velocity * last_swing_direction
		elif Input.is_action_just_released("right_click"):
			pretract()
		if flip:
			S.reset = false
			player.rotation_degrees += -(rot_spd) * delta
			S.flipp = true
			if player.rotation_degrees < 0 and counted == false:
				S.rot_count += 1
				counted = true
			if player.rotation > 0:
				counted = false
			
		elif flip == false:
			var playrot = player.rotation
			var spriterot = sprite.rotation
			player.rotation = lerp(playrot, 0.0 , 0.08)
			S.reset = true
			S.done = false
			S.flipp = false
		if S.resting:
			player.velocity = Vector2(0.0,0.0)
			launched = false
			pulled = false
			if Input.is_action_just_pressed("spacebar"):
				S.resting = false
				player.velocity = Vector2(S.velx, -600)
		
		if throwvel:
			player.velocity.x = release_vel.x
			throwvel = false
		if launched:
			S.jump = false
			counted = false
			flip = false
			S.flipp = false
			handle_swing(delta)
			var angle = ((line.get_point_position(1) - line.get_point_position(0)).angle()) + 90
			sprite.rotation = angle
			aeq = angle
			
		elif not launched:
			after_swing_rot = true
			if Input.is_action_pressed("flip") and not player.is_on_floor():
				flip = true
			else:
				flip = false
				sprite.rotation = 0
		if pulled:
			pull(delta)
		if after_swing_rot:
			
			after_swing_rot = false
	else:
		gretract()
		launched = false
func pretract():
	pulled = false
	line.hide()
func plaunch():
		target = raycast.get_collision_point(0)
		pulled = true
		line.show()
func glaunch():
	collider = raycast.get_collider(0)
	if collider and collider.has_method("rest"):
		plaunch()
		
	else:
		min_angular_velocity = player.velocity.x
		sprite.rotation = 0.0
		player.rotation = 0.0
		launched = true
		target = raycast.get_collision_point(0)
		angular_velocity = min_angular_velocity 
		last_swing_direction = 1  
		line.show()
		
func gretract():
	if S.dash:
		$"../AnimatedSprite2D".play("dash")
	elif not S.dash and was_swinging == false:
		$"../AnimatedSprite2D".play("jumppad")
	elif was_swinging == true and not S.dash:
		$"../AnimatedSprite2D".play("fall")
	launched = false
	throwvel = true
	line.hide()
	was_swinging = false

func pull(delta):
	stiffness += 0.1
	damping_factor += 0.2
	var anchor_dir = player.global_position.direction_to(target)  # Target ki direction
	var distance = player.global_position.distance_to(target)

	var displacement = distance - rest_length
	var spring_force = anchor_dir * stiffness * displacement
	
	var velocity_dot = player.velocity.dot(anchor_dir)
	var damping = -damping_factor * velocity_dot * anchor_dir 
	var force = spring_force + damping
	player.velocity = anchor_dir * min(distance * 20, 900)
	line.set_point_position(1, to_local(target))
func handle_swing(delta):
	min_angular_velocity = release_vel.x
	var anchor_dir = player.global_position.direction_to(target)
	var distance = player.global_position.distance_to(target)

	# Rope stretch force
	var displacement = distance - rest_length
	var spring_force = anchor_dir * stiffness * displacement

	# Damping (reduces extra swinging motion)
	var velocity_dot = player.velocity.dot(anchor_dir)
	var damping = -damping_factor * velocity_dot * anchor_dir

	# Applying forces
	var force = spring_force + damping
	player.velocity += force * delta

	# **Circular motion calculation**
	var tangential_velocity = Vector2(-anchor_dir.y, anchor_dir.x) * angular_velocity
	player.velocity += tangential_velocity * delta

	# **Maintain constant swing physics**
	var swing_direction = sign(player.velocity.x)  # Current movement direction
	
	if swing_direction != last_swing_direction:
		# Reset angular velocity when direction changes
		angular_velocity = min_angular_velocity
	else:
		# Keep it stable between min and max limits
		angular_velocity = clamp(angular_velocity, min_angular_velocity, max_angular_velocity)
	release_vel = player.velocity
	last_swing_direction = swing_direction  # Update direction
	# Rope visual update
	line.set_point_position(1, to_local(target))

func rotation_handle():
	sprite.rotation = 0.0
