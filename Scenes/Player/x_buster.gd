extends Node2D

const XLemonScene = preload("res://Scenes/InheritanceScenes/x_lemon.tscn")


@onready var buster_pos = $BusterPos
@onready var buster_pos_2 = $BusterPos2


@onready var player = MainInstances.player


func fire_lemon():
	buster_pos.position.x = abs(buster_pos.position.x) * player.get_direction().x
	var direction = buster_pos.position.x
	if player.x_sprite.flip_h:
		var lemon = Utils.instantiate_scene_on_world_flipped(XLemonScene, buster_pos.global_position)
		lemon.update_velocity()
		lemon.velocity.x = sign(direction) * lemon.speed
	else:
		var lemon = Utils.instantiate_scene_on_world(XLemonScene, buster_pos.global_position)
		lemon.update_velocity()
		lemon.velocity.x = sign(direction) * lemon.speed
	Sounds.play(Sounds.lemons, 1.0, -20.0)



