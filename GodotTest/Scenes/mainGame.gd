extends KinematicBody2D

export(float) var runSpeed = 20
export(float) var xdecelGround = 1
export(float) var xdecelAir = 0
export(float) var xaccel = 2
export(float) var velCap = 10
export(float) var velAirReduction = 0.5
var move = 0.0
var velocity = Vector2()
export(float) var jumpHeight = 40
export(float) var jumpTime = 0.3
export(bool) var canIdle = true
export(bool) var canFall = true

func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#direction
	if(velocity.x > 0):
		$Sprite.flip_h= false
	if(velocity.x < 0):
		$Sprite.flip_h= true	
	print(move)

	#velocity calculations
	# -y is up, +y is down
	velocity.x = move * runSpeed
	var gravity = 2*jumpHeight/(jumpTime*jumpTime)
	velocity.y += gravity*delta
	velocity = move_and_slide(velocity, Vector2(0, -1))

	#horizontal acceleration/deceleration
	if(abs(move) >= velCap):
		if(sign(move) == 1):
			move = velCap
		else:
			move = -1*velCap
		#deceleration on ground
	if(sign(move) != 0 && is_on_floor() == true):
		if(sign(move) == 1 && is_on_floor() == true):
			move -= xdecelGround
		else:
			move += xdecelGround
		#deceleration in air
	if(sign(move) != 0 && is_on_floor() == false):
		if(sign(move) == 1 && is_on_floor() == false):
			move -= xdecelAir
		else:
			move += xdecelAir
	#grounded movement
	if(is_on_floor() == true):	
		if(Input.is_action_pressed("ui_right")):
			move += xaccel-velAirReduction
			$AnimationPlayer.play("playerRun")
		elif(Input.is_action_pressed("ui_left")):
			move -= xaccel-velAirReduction
			$AnimationPlayer.play("playerRun")
		else:
			velocity.x = 0
			if(canIdle):
				$AnimationPlayer.play("playerIdle")
		#air movement
	if(is_on_floor() == false):
		if(Input.is_action_pressed("ui_right")):
			move += xaccel
			$AnimationPlayer.play("playerRun")
		elif(Input.is_action_pressed("ui_left")):
			move -= xaccel
			$AnimationPlayer.play("playerRun")
		#else:
			#velocity.x = 0
		
	if(Input.is_action_just_pressed("jump") && is_on_floor() == true):
		$AnimationPlayer.play("playerJump")
		velocity.y = -2*jumpHeight/jumpTime
		
	#wall jump
	if(Input.is_action_just_pressed("jump") && is_on_floor() == false && is_on_wall() == true):
		canFall = false
		$AnimationPlayer.play("playerFlip")
		velocity.y = -2*jumpHeight/jumpTime

	#falling animation
	if(is_on_floor() != true && velocity.y > 0 && canFall == true):
		$AnimationPlayer.play("playerFalling")



	#attack animations
	if(Input.is_action_just_pressed("light attack") && canFall == true):
		#animation runs on a different frame system than the script
		#I set the canFall value in animation and it kept getting cancelled 
		#do state checks in script, not animation, as they are faster here (constant vs variable update)
		canFall = false
		canIdle = false
		$AnimationPlayer.play("playerLightAttack")
		print("Can idle is now ", canIdle)





#func _on_AnimationPlayer_animation_finished(anim_name):
#	canIdle = true
#	canFall = true


