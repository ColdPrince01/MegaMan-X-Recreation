extends Projectile

const ChargeDeflect = preload("res://Scenes/InheritanceScenes/charge_deflect.tscn")

func _on_hit_box_component_area_entered(area):
	if area is HurtBox:
		queue_free()
		var deflect = Utils.instantiate_scene_on_world(ChargeDeflect, global_position)
		deflect.scale.x = 0.6
		deflect.scale.y = 0.6
		deflect.modulate = Color.GREEN
