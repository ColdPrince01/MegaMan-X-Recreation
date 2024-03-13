extends Node


func instantiate_scene_on_world(scene : PackedScene, position : Vector2):
	var world = get_tree().current_scene
	var instance = scene.instantiate()
	world.add_child.call_deferred(instance)
	instance.global_position = position
	return instance


func instantiate_scene_on_world_flipped(scene : PackedScene, position : Vector2):
	var world = get_tree().current_scene
	var instance = scene.instantiate()
	world.add_child.call_deferred(instance)
	instance.global_position = position
	instance.scale.x *= -1
	return instance
