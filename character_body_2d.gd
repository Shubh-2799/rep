extends CharacterBody2D

const SPEED = 300.0
const PADSPEED = 600.0
const JUMP_VELOCITY = -500.0
var acc = 0.1
var ret = 0.1
var direction
var justjumped:bool = false
func _ready() -> void:
	pass
func padmechanic():
	if justjumped == false:
		velocity.y -= 900.0
		justjumped = true
func _process(delta: float) -> void:
	if S.jumppad and not is_on_floor():
		velocity.x = direction * PADSPEED
	if velocity.x < 100.0 and velocity.x > 0 and S.jump == false and not is_on_floor() and S.swinging == false:
		velocity.x = 100.0
	if S.jump:
		velocity.x = direction * SPEED
	if is_on_floor():
		if S.jumppad:
			$AnimatedSprite2D.play("fall")
			
		S.jumppad = false
		S.jump = false
		justjumped = false
	elif is_on_floor() and not direction:
		$AnimatedSprite2D.play("default")
	'''if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true'''
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
			velocity += get_gravity() * delta
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
	move_and_slide()
