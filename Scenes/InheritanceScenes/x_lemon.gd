extends Projectile

const SmallDeflect = preload("res://Scenes/InheritanceScenes/smalldeflect.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D




func _on_hit_box_component_area_entered(area):
	if area is HurtBox:
		queue_free()
		Utils.instantiate_scene_on_world(SmallDeflect, global_position)

