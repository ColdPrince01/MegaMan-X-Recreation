class_name Projectile
extends Node2D

@export var speed = 250

var velocity = Vector2.ZERO
var direction : Vector2

func initialize(pos : Vector2, dir: Vector2, velo: int):
	global_position = pos
	direction = dir
	velocity = velo
	

func update_velocity():
	velocity.x = speed
	

func _process(delta):
	position += velocity * delta #updates bullet position every process frame


func _on_hit_box_component_area_entered(area):
	if area is HurtBox:
		queue_free()




func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
