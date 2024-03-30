class_name PlayerCamera
extends Camera2D

@onready var player : Player = MainInstances.player
@onready var timer = $Timer

var shake_amount = 0

func _enter_tree():
	MainInstances.camera = self

func _ready():
	Events.add_screenshake.connect(start_screenshake)


func _process(delta):
	offset.x = randf_range(-shake_amount, shake_amount)
	offset.y = randf_range(-shake_amount, shake_amount)

func start_screenshake(amount, duration):
	shake_amount = amount
	timer.wait_time = duration
	timer.start()



func _on_timer_timeout():
	shake_amount = 0
