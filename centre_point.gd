extends Marker2D

var canDeflect = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#looks at the mouse
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("click") and canDeflect:
		canDeflect = false
		$refreshTimer.start()
		$directionArrow/slashArea/CollisionShape2D.disabled=false
		$Timer.start()

func _on_timer_timeout() -> void:
	$directionArrow/slashArea/CollisionShape2D.disabled=true

func _on_refresh_timer_timeout() -> void:
	canDeflect=true
