extends KinematicBody2D

export(float) var runSpeed = 220

var velocity = Vector2()
export(float) var jumpHeight = 40
export(float) var jumpTime = 0.3
export(bool) var canIdle = true
export(bool) var canFall = true

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move = 0.0
	var gravity = 2*jumpHeight/(jumpTime*jumpTime)

	velocity.y += gravity*delta


	#movement
	if(Input.is_action_pressed("ui_right")):
		move += 1
		if(velocity.x > 0):
			$Sprite.flip_h= false
		if(velocity.x < 0):
			$Sprite.flip_h= true
		if(canFall):
			$AnimationPlayer.play("playerRun")
		
	elif(Input.is_action_pressed("ui_left")):
		move -= 1
		if(velocity.x < 0):
			$Sprite.flip_h= true
		if(canFall):
			$AnimationPlayer.play("playerRun")
	else:
		velocity.x = 0
		if(canIdle):
			$AnimationPlayer.play("playerIdle")
		
	if(Input.is_action_just_pressed("jump") && is_on_floor() == true):
		$AnimationPlayer.play("playerJump")
		velocity.y = -2*jumpHeight/jumpTime

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

	#movement calculations
	velocity.x = move * runSpeed
	# -y is up, +y is down
	velocity = move_and_slide(velocity, Vector2(0, -1))



#func _on_AnimationPlayer_animation_finished(anim_name):
#	canIdle = true
#	canFall = true


