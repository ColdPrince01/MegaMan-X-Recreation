extends Node2D

const XLemonScene = preload("res://Scenes/InheritanceScenes/x_lemon.tscn")
const MegaChargeOne = preload("res://Scenes/InheritanceScenes/mega_charge_one.tscn")
const FullyChargedScene = preload("res://Scenes/InheritanceScenes/fully_charged_buster.tscn")

@onready var buster_pos = $BusterPos
@onready var buster_pos_2 = $BusterPos2

@export var wall_buster := Vector2(15,-17)

@onready var player = MainInstances.player

var original_pos = Vector2(15,-14)
var original_pos_2 = Vector2(-13,-14)

func fire_lemon():
	Sounds.play(Sounds.lemons, 1.0, -12.0)
	buster_pos.position.x = abs(buster_pos.position.x) * player.get_direction().x
	var direction = buster_pos.position.x
	if player.is_wall_sliding and !player.x_sprite.flip_h: #If the player is wall sliding and facing left
		buster_pos_2.position.y = wall_buster.y
		var lemon = Utils.instantiate_scene_on_world_flipped(XLemonScene, buster_pos_2.global_position)
		lemon.update_velocity()
		lemon.velocity.x = (sign(direction) * -1) * lemon.speed #Multiply the direction by -1 since the player sprite is technically not flipped
		buster_pos_2.position.y = original_pos_2.y
	else: #Wall Slide sprite is facing left by default, so if it is instead facing right
		if player.is_wall_sliding and player.x_sprite.flip_h:
			buster_pos.position = wall_buster
			var lemon = Utils.instantiate_scene_on_world(XLemonScene, buster_pos.global_position)
			lemon.update_velocity()
			lemon.velocity.x = (sign(direction) * -1) * lemon.speed #Multiply the direction by -1 since the player sprite is technically not flipped
			buster_pos.position = original_pos
	if player.x_sprite.flip_h: 
		if player.is_wall_sliding: return
		var lemon = Utils.instantiate_scene_on_world_flipped(XLemonScene, buster_pos.global_position)
		lemon.update_velocity()
		lemon.velocity.x = sign(direction) * lemon.speed
	elif not player.x_sprite.flip_h:
		if player.is_wall_sliding: return
		var lemon = Utils.instantiate_scene_on_world(XLemonScene, buster_pos.global_position)
		lemon.update_velocity()
		lemon.velocity.x = sign(direction) * lemon.speed
	

func fire_charge_one():
	Sounds.play(Sounds.charge_one)
	buster_pos.position.x = abs(buster_pos.position.x) * player.get_direction().x
	var direction = buster_pos.position.x
	if player.is_wall_sliding and !player.x_sprite.flip_h: #If the player is wall sliding and facing left
		buster_pos_2.position.y = wall_buster.y
		var lemon = Utils.instantiate_scene_on_world_flipped(MegaChargeOne, buster_pos_2.global_position)
		lemon.update_velocity()
		lemon.velocity.x = (sign(direction) * -1) * lemon.speed #Multiply the direction by -1 since the player sprite is technically not flipped
		buster_pos_2.position.y = original_pos_2.y
	else: #Wall Slide sprite is facing left by default, so if it is instead facing right
		if player.is_wall_sliding and player.x_sprite.flip_h:
			buster_pos.position = wall_buster
			var lemon = Utils.instantiate_scene_on_world(MegaChargeOne, buster_pos.global_position)
			lemon.update_velocity()
			lemon.velocity.x = (sign(direction) * -1) * lemon.speed #Multiply the direction by -1 since the player sprite is technically not flipped
			buster_pos.position = original_pos
	if player.x_sprite.flip_h: 
		if player.is_wall_sliding: return
		var lemon = Utils.instantiate_scene_on_world_flipped(MegaChargeOne, buster_pos.global_position)
		lemon.update_velocity()
		lemon.velocity.x = sign(direction) * lemon.speed
	elif not player.x_sprite.flip_h:
		if player.is_wall_sliding: return
		var lemon = Utils.instantiate_scene_on_world(MegaChargeOne, buster_pos.global_position)
		lemon.update_velocity()
		lemon.velocity.x = sign(direction) * lemon.speed

func fire_charge_two():
	Sounds.play(Sounds.fully_charged)
	buster_pos.position.x = abs(buster_pos.position.x) * player.get_direction().x
	var direction = buster_pos.position.x
	if player.is_wall_sliding and !player.x_sprite.flip_h: #If the player is wall sliding and facing left
		buster_pos_2.position.y = wall_buster.y
		var lemon = Utils.instantiate_scene_on_world_flipped(FullyChargedScene, buster_pos_2.global_position)
		lemon.update_velocity()
		lemon.velocity.x = (sign(direction) * -1) * lemon.speed #Multiply the direction by -1 since the player sprite is technically not flipped
		buster_pos_2.position.y = original_pos_2.y
	else: #Wall Slide sprite is facing left by default, so if it is instead facing right
		if player.is_wall_sliding and player.x_sprite.flip_h:
			buster_pos.position = wall_buster
			var lemon = Utils.instantiate_scene_on_world(FullyChargedScene, buster_pos.global_position)
			lemon.update_velocity()
			lemon.velocity.x = (sign(direction) * -1) * lemon.speed #Multiply the direction by -1 since the player sprite is technically not flipped
			buster_pos.position = original_pos
	if player.x_sprite.flip_h: 
		if player.is_wall_sliding: return
		var lemon = Utils.instantiate_scene_on_world_flipped(FullyChargedScene, buster_pos.global_position)
		lemon.update_velocity()
		lemon.velocity.x = sign(direction) * lemon.speed
	elif not player.x_sprite.flip_h:
		if player.is_wall_sliding: return
		var lemon = Utils.instantiate_scene_on_world(FullyChargedScene, buster_pos.global_position)
		lemon.update_velocity()
		lemon.velocity.x = sign(direction) * lemon.speed
