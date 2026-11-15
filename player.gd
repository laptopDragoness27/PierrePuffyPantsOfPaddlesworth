extends CharacterBody2D

var health = 11

#value in pixels per second that the player will accelerate by each frame that the button is held
const SPEED = 150.0
#when the player is putting in input, the player will slow down by this many pixels per second per frame
const DECEL = 25.0
#this is the maximum speed in pixels per second that the player can go
const MAXSPEED = 250.0

func _ready():
	$AnimationPlayer2.play("normalSword")

func _physics_process(delta: float) -> void:
	$healthbar.frame=clamp((11-health),0,11)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down"))
	#if the player is putting in movement input run the acceleration code
		#adds the speed set with the SPEED variable in the direction that was inputted
	velocity.x += direction.x * SPEED
	velocity.y += direction.y * SPEED
	
	#animation planning
	if Input.is_action_just_pressed("click"):
		$AnimationPlayer.play("attack")
		$AnimationPlayer2.play("swordSlash")
		$deflectSound.play()
	elif direction and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("walk")
	elif not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("idle")
	
	var lookDirection = 0
	
	if direction.x==1:
		lookDirection=1
	elif direction.x==-1:
		lookDirection=-1
	
	if lookDirection==-1:
		$Icon.flip_h=true
	elif lookDirection==1:
		$Icon.flip_h=false
	
	#limits horizontal velocity to MAXSPEED
	if velocity.x>MAXSPEED or velocity.x<-MAXSPEED:
		velocity.x=MAXSPEED*direction.x
	#limits vertical velocity to MAXSPEED
	if velocity.y>MAXSPEED or velocity.y<-MAXSPEED:
		velocity.y=MAXSPEED*direction.y
		
	#if the player is not inputting anything in the x axis, run the x-axis deceleration code
	if direction.x==0:
		velocity.x = move_toward(velocity.x, 0, DECEL)
	#if the player is not inputting anything in the y axis, run the y-axis deceleration code
	if direction.y==0:
		velocity.y = move_toward(velocity.y, 0, DECEL)
	
	#move the character by velocity each section
	move_and_slide()
	
	#give the new player position to the enemies
	get_tree().call_group("Enemy","PlayerPosition",position.x,position.y)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if "bullet" in area.name or "MeleeEnemy" in area.name:
		health-=1
		$hitSound.play()
		if health==0:
			get_tree().change_scene_to_file("res://deathScreen.tscn")
	if "scroll" in area.name:
		get_tree().change_scene_to_file("res://win.tscn")
