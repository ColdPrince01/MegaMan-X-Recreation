extends Projectile

const ChargeDeflect = preload("res://Scenes/InheritanceScenes/charge_deflect.tscn")

func _on_hit_box_component_area_entered(area):
	if area is HurtBox:
		queue_free()
		Utils.instantiate_scene_on_world(ChargeDeflect, global_position)
