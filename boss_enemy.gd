extends CharacterBody2D
@export var Melee = preload("res://melee_enemy.tscn")
@export var Ranged = preload("res://range_enemy.tscn")

var rand = RandomNumberGenerator.new() #gets a random seed
var x = 0
var y = 0

var pPosition = Vector2(0,0) #Players position
var angry = false #when true, it also attacks the player using melee's attack, but fullscreen
var health = 10

func _ready(): #runs once at the start
	x = rand.randi_range(-3,3) #random x direction
	y = rand.randi_range(-3,3) #random y direction

func _on_timer_timeout():
	x = rand.randi_range(-3,3) #random x direction
	y = rand.randi_range(-3,3) #random y direction
	summon_allies()
	resetPP()

func _physics_process(delta):
	velocity = Vector2(x,y)*20 #set direction/speed
	if angry:
		velocity = pPosition
	move_and_slide()

var number_of_ranged = 2
var number_of_melee = 1
var marker = Marker2D
func summon_allies():
	#The main attack of the boss. Summons 2 ranged enemies and 1 melee enemy. 
	#for i in number_of_ranged: #spawns 2 ranged 
		#var spawnRange = Ranged.instantiate() #gets instance data (i think)
		#add_child(spawnRange)
		#spawnRange.position=get_parent().Marker1 #changes the position of it to the boss
	var spawnRange1 = Ranged.instantiate()
	var spawnRange2 = Ranged.instantiate()
	var spawnMelee1 = Melee.instantiate()
	
	spawnMelee1.activatedAtStart=true
	spawnRange2.activatedAtStart=true
	spawnRange1.activatedAtStart=true
	
	get_parent().add_child(spawnRange1)
	get_parent().add_child(spawnRange2)
	get_parent().add_child(spawnMelee1)
	
	spawnRange1.position=$Marker1.global_position
	spawnRange2.position=$Marker2.global_position
	spawnMelee1.position=$Marker3.global_position
	#for i in number_of_melee:
		#var spawnMelee = Melee.instantiate()
		#add_child(spawnMelee)
		#spawnMelee.position=get_parent().position #changes the position of it to the boss

func resetPP():
	pPosition = Vector2(0,0) #reset the player position

func PlayerPosition(pX,pY): #gets player vector relative to enemy
	var xTemp = (position.x-pX)*(-1)
	var yTemp = (position.y-pY)*(-1)
	pPosition = Vector2(xTemp,yTemp)
