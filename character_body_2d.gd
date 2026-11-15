extends CharacterBody2D
var rand = RandomNumberGenerator.new() #gets a random seed

var x = 0
var y = 0
var seenP = false
var chasing = false #if it is true, it is chasing the player. if it is false, it is wandering
var pPosition = Vector2(0,0) #Players position
var pGlobal = Vector2.ZERO

@export var activatedAtStart = false

#preloads the bullet scene for later
var bulletScene = preload("res://bullet.tscn")

@export var roomName = "room1"

func _ready(): #runs once at the start
	#adds enemy to room name group
	add_to_group(roomName)
	
	x = rand.randi_range(-3,3) #random x direction
	y = rand.randi_range(-3,3) #random y direction

func _on_timer_timeout():
	if not seenP:
		x = rand.randi_range(-3,3) #random x direction
		y = rand.randi_range(-3,3) #random y direction
	if seenP:
		chasing = not chasing

func _physics_process(_delta):
	if activatedAtStart:
		velocity = Vector2(x,y).normalized()*40 #set direction/speed
		if chasing:
			velocity = pPosition.normalized()*-100
		move_and_slide()
	
		if velocity!=Vector2.ZERO and not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("walk")
		elif not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("idle")

func _on_area_2d_area_entered(area):
	if area.is_in_group("PlayerVicinity"):
		seenP = true #saw the enemy, and will run toward it 
	if "bullet" in area.name:
		$deadSound.play()

func _on_area_2d_area_exited(area):
	if area.is_in_group("PlayerVicinity"):
		seenP = false
		chasing = false

func resetPP():
	pPosition = Vector2(0,0) #reset the player position

func PlayerPosition(pX,pY):
	var xTemp = (position.x-pX)*(-1)
	var yTemp = (position.y-pY)*(-1)
	pPosition = Vector2(xTemp,yTemp)
	pGlobal = Vector2(pX,pY)

func _on_shoot_timer_timeout() -> void:
	if activatedAtStart:
		$enemyAttack.play()
		$AnimationPlayer.play("attack")
		print(pPosition)
		$bulletAxis.look_at(pGlobal)
		var bullet = bulletScene.instantiate() # Create a new bulletScene.
		get_parent().add_child(bullet) # Add it as a child of this node's parent.
		bullet.position=$bulletAxis/bulletPoint.global_position
		bullet.rotation = $bulletAxis.rotation

func _on_area_2d_body_entered(body: Node2D) -> void:
	x *= -1
	y *= -1
	print(str(x)+str(y))
	seenP=false
	chasing = false

func playerEntered():
	activatedAtStart=true

func _on_dead_sound_finished() -> void:
	get_tree().call_group(roomName, "enemyDied")
	queue_free()
