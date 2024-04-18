extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Dash"):
		Engine.time_scale = 0.1
	else:
		Engine.time_scale = 1.0
