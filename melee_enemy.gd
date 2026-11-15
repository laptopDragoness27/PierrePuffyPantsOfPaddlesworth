extends CharacterBody2D
var rand = RandomNumberGenerator.new() #gets a random seed

var x = 0
var y = 0
var seenP = false
var chasing = false #if it is true, it is chasing the player. if it is false, it is wandering
var pPosition = Vector2(0,0) #Players position

var life=3

var scared=false

@export var roomName = "room1"
@export var activatedAtStart = false

func _ready(): #runs once at the start
	#adds enemy to room name group
	add_to_group(roomName)
	
	x = rand.randi_range(-3,3) #random x direction
	y = rand.randi_range(-3,3) #random y direction

func _on_timer_timeout():
	x = rand.randi_range(-3,3) #random x direction
	y = rand.randi_range(-3,3) #random y direction
	if seenP:
		chasing = not chasing

func _physics_process(_delta):
	if activatedAtStart:
		velocity = position.direction_to(Vector2(x,y))*20 #set direction/speed
		if chasing:
			velocity = pPosition.normalized()*100
		if scared:
			velocity = pPosition.normalized()*-100
		move_and_slide()
		if velocity!=Vector2.ZERO and not $s.is_playing():
			$s.play("walk")
		elif not $s.is_playing():
			$s.play("idle")

func _on_area_2d_area_entered(area):
	if area.is_in_group("PlayerVicinity"):
		seenP = true #saw the enemy, and will run toward it 
	if "bullet" in area.name:
		$dyingSound.play()
	if "slashArea" in area.name:
		scared=true
		$afraidTimer.start()
		life-=1
		get_node("life"+str(life+1)).queue_free()
		if life==0:
			$dyingSound.play()

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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "player" in body.name:
		$s.play("attack")
	x = rand.randi_range(-3,3) #random x direction
	y = rand.randi_range(-3,3) #random y direction

func _on_dying_sound_finished() -> void:
	get_tree().call_group(roomName, "enemyDied")
	queue_free()

func _on_afraid_timer_timeout() -> void:
	scared = false

func playerEntered():
	activatedAtStart=true
