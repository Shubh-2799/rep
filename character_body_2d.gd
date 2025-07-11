extends CharacterBody2D

const SPEED = 300.0
const PADSPEED = 600.0
const JUMP_VELOCITY = -500.0
var acc = 0.1
var ret = 0.1
var direction
var justjumped:bool = false
var lastvelocityx:float
func _ready() -> void:
	pass
func padmechanic():
	if justjumped == false:
		velocity.y -= 900.0
		justjumped = true
func _process(delta: float) -> void:
	if S.jumppad and not is_on_floor():
		$AnimatedSprite2D.play("jumppad")
		velocity.x = direction * PADSPEED
	if velocity.x < 100.0 and velocity.x > 0 and S.jump == false and not is_on_floor() and S.swinging == false:
		velocity.x = 100.0
	if S.jump:
		velocity.x = direction * SPEED
	if is_on_floor():
		S.jumppad = false
		S.jump = false
		justjumped = false
	elif is_on_floor() and not direction:
		$AnimatedSprite2D.play("default")
	if S.dash:
		if velocity.x > 0:
			velocity.x = 1200.0
		elif velocity.x < 0:
			velocity.x = -1200.0
		velocity.y = 0.0
		$AnimatedSprite2D.play("dash")
		$CPUParticles2D2.emitting = true
		$CPUParticles2D3.emitting = true
	if velocity.x > 0 and not S.swinging:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0 and not S.swinging:
		$AnimatedSprite2D.flip_h = true
func _physics_process(delta: float) -> void:
	if S.jumppad:
		$AnimatedSprite2D.play("swing")
		padmechanic()
	if S.resting:
		$AnimatedSprite2D.play("default")
		$AnimatedSprite2D.rotation = 0
		S.resting = false
	if not is_on_floor() : 
		if not S.dash:
			velocity += get_gravity() * delta * 0.7
	direction = Input.get_axis("ui_left" , "ui_right")
	if S.resting == false and S.swinging == false and is_on_floor():
		velocity.x = direction * SPEED
		if velocity.x > 0:
			$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = false
		elif velocity.x < 0:
			$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = true
		elif velocity.x == 0:
			$AnimatedSprite2D.play("default")
		
	else:
		velocity.x = move_toward(velocity.x , 0 , SPEED * delta)
	if is_on_floor() and Input.is_action_just_pressed("spacebar"):
		$AnimatedSprite2D.play("fall")
		velocity.y = JUMP_VELOCITY
		velocity.x = direction * SPEED
		S.jump = true
	if not is_on_floor() and Input.is_action_just_pressed("dash") and S.oncooldown == false:
		lastvelocityx = velocity.x
		S.dash = true
		rotation = 0.0
		$AnimatedSprite2D.rotation = 0.0
		S.swinging = false
		S.flipp = false
		$Timer.start()
		$Cooldown.start()
		S.oncooldown = true
	move_and_slide()


func _on_timer_timeout() -> void:
	S.dash = false
	$AnimatedSprite2D.play("jumppad")

func _on_cooldown_timeout() -> void:
	S.oncooldown = false
