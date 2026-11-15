extends StaticBody2D

@export var enemies = 1
@export var roomName = "room1"
@export var isAlreadyLocked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#adds door to room name group
	add_to_group(roomName)
	$Icon.frame=0
	if isAlreadyLocked:
		$Icon.frame=0
		$CollisionShape2D.disabled=false
	else:
		$Icon.frame=1
		$CollisionShape2D.disabled=true

func enemyDied():
	enemies-=1
	if enemies == 0:
		$CollisionShape2D.disabled=true
		$Icon.frame=1

func _on_player_enter_body_entered(body: Node2D) -> void:
	if "player" in body.name and not isAlreadyLocked:
		get_tree().call_group(roomName, "playerEntered")
		

func playerEntered():
	$Icon.frame=0
	$CollisionShape2D.set_deferred("disabled",false)
	isAlreadyLocked=true
