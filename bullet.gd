extends CharacterBody2D

var direction = Vector2(-100,100)
var directionAngle=0

#this is the multiplier for the perry speed
const PERRYSPEED = 100

func _ready():
	print(rotation_degrees)

#this function gives a directional vector for the 
func getDirection(location):
	var localPosition = location-position
	return localPosition

func _physics_process(delta: float) -> void:
	
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("bullet")
	
	velocity=transform.x*PERRYSPEED
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if "slashArea" in area.name:
		look_at(get_global_mouse_position())
	elif not "playerZone" in area.name:
		queue_free()

func _on_bullet_body_entered(body: Node2D) -> void:
	if "Obelisk" in body.name:
		rotation_degrees+=180
	else:
		queue_free()
