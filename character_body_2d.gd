extends CharacterBody2D

const SPEED = 300.0
const PADSPEED = 600.0
const JUMP_VELOCITY = -500.0
var acc = 0.1
var ret = 0.1
var direction
var justjumped:bool = false
var lastvelocityx:float
var skin:String
var played_once = false
func _ready() -> void:
	if S.skin_number == 0:
		skin = "mc"
	elif S.skin_number == 1:
		skin = "cletus"
	elif S.skin_number == 2:
		skin = "felix"
	elif S.skin_number == 3:
		skin = "tomo"
	elif S.skin_number == 4:
		skin = "monkey"
	elif S.skin_number == 5:
		skin = "four"
	if skin == "mc":
		$AnimatedSprite2D/Marker2D.position = Vector2(6.096,-9.337)
		$grapple/Line2D.default_color = Color(1,1,1,1)
	elif skin == "monkey":
		$grapple/Line2D.default_color = Color.html("#ffae70")
func padmechanic():
	if justjumped == false:
		velocity.y -= 900.0
		justjumped = true
func _process(delta: float) -> void:
	
	if velocity.x > 5000.0:
		velocity.x = 5000.0
	if S.jumppad and not is_on_floor():
		$AnimatedSprite2D.play(skin + "_jumppad")
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
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.play(skin + "_idle")
		
	if S.dash:
		velocity.x = 1200.0
		if velocity.x > 0:
			velocity.x = 1200.0
		elif velocity.x < 0:
			velocity.x = -1200.0
		velocity.y = 0.0
		$AnimatedSprite2D.play(skin + "_dash")
		$CPUParticles2D2.emitting = true
		$CPUParticles2D3.emitting = true
	if velocity.x > 0 and not S.swinging:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0 and not S.swinging:
		$AnimatedSprite2D.flip_h = true
	
	
func _physics_process(delta: float) -> void:
	if not S.gamble:
		if Input.is_action_just_pressed("gamble"):
			S.gamble = true
		if S.jumppad:
			$AnimatedSprite2D.play(skin +"_swing")
			padmechanic()
		if S.resting:
			$AnimatedSprite2D.play(skin + "_idle")
			$AnimatedSprite2D.rotation = 0
			S.resting = false
		if not is_on_floor() : 
			if not S.dash:
				velocity += get_gravity() * delta * 0.7 * S.gravityred
		direction = Input.get_axis("ui_left" , "ui_right")
		if S.resting == false and S.swinging == false and is_on_floor():
			velocity.x = direction * SPEED
			if velocity.x > 0:
				$AnimatedSprite2D.play(skin +"_run")
				$AnimatedSprite2D.flip_h = false
			elif velocity.x < 0:
				$AnimatedSprite2D.play(skin +"_run")
				$AnimatedSprite2D.flip_h = true
			elif velocity.x == 0:
				$AnimatedSprite2D.play(skin +"_idle")
			
		else:
			velocity.x = move_toward(velocity.x , 0 , SPEED * delta)
		if is_on_floor() and Input.is_action_just_pressed("spacebar"):
			$AnimatedSprite2D.play(skin + "_fall")
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
			$Timer.wait_time = 0.25 + S.dashinc
			$Timer.start()
			$Cooldown.start()
			S.oncooldown = true
	else:
		velocity = Vector2(0,0)
		$"../Control/CanvasLayer".visible = false
		if !played_once:
			$"../AnimationPlayer".play("gambling")
			print("gambling done")
			played_once = true
		if S.justgamble:
			$"../AnimationPlayer".play_backwards("gambling")
			played_once = false
	move_and_slide()


func _on_timer_timeout() -> void:
	S.dash = false
	$AnimatedSprite2D.play(skin + "_jumppad")

func _on_cooldown_timeout() -> void:
	S.oncooldown = false
