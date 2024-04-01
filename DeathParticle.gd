extends AnimatedSprite2D

@onready var timer = $Timer

@export var decel_speed := 125 #px/sec

var direction : Vector2
var velocity : int
var start_dir
var direction_x 

func initialize(pos : Vector2, dir: Vector2, velo: int, dir_x : int):
	global_position = pos
	direction = dir
	velocity = velo
	direction_x = dir_x

func _physics_process(delta):
	#Death Particle will begin by shooting outward and then as the timer still has time left,
	#then when the clock strikes zero the velocity will turn inward
	position += direction.normalized() * velocity * delta
	
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
