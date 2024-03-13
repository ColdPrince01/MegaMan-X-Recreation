extends Node2D

const XLemonScene = preload("res://Scenes/InheritanceScenes/x_lemon.tscn")


@onready var buster_pos = $BusterPos
@onready var buster_pos_2 = $BusterPos2

var parent = Player



func fire_lemon():
	var lemon = Utils.instantiate_scene_on_world(XLemonScene, buster_pos.global_position)
	lemon.update_velocity()
