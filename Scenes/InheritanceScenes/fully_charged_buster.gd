extends Projectile

const ChargeDeflect = preload("res://Scenes/InheritanceScenes/charge_deflect.tscn")

func _on_hit_box_component_area_entered(area):
	if area is HurtBox:
		queue_free()
		Utils.instantiate_scene_on_world(ChargeDeflect, global_position)



func _on_visible_on_screen_notifier_2d_screen_exited():
	await get_tree().create_timer(1.0).timeout
	queue_free()
