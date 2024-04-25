extends Node2D

@export var health_gain := 15



func _on_pickup_area_area_entered(area):
	if not area is HurtBox: return
	PlayerStats.health += health_gain
	Sounds.play(Sounds.life_gain, 1.0, -9.0)
	queue_free()
