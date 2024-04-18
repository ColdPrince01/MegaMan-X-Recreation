extends Node2D

const DamageNumber = preload("res://Unrelated/damage_number.tscn")
const ExplosionDust = preload("res://Unrelated/ExplosionDust.tscn")
const ExplosionScrap = preload("res://OtherScenes/explosion_scrap.tscn")
const Pickaxe = preload("res://Scenes/InheritanceScenes/PickAxe.tscn")


enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var facing_direction = DIRECTION.RIGHT


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player_detector = $PlayerDetector
@onready var stats = $Stats
@onready var flash_timer = $FlashTimer
@onready var attack_timer = $AttackTimer


func _ready():
	animated_sprite_2d.scale.x = facing_direction
	player_detector.target_position.x *= facing_direction


func _physics_process(delta):
	if player_detector.is_colliding() and attack_timer.time_left <= 0.0:
		throw_pick()
		animated_sprite_2d.play("Throw")
		attack_timer.start()

func blit_damage_number(number):
	var damage_number_inst = Utils.instantiate_scene_on_world(DamageNumber, global_position + Vector2(0, -12)) #offset the global_position 
	damage_number_inst.number = number
	

func flash():
	animated_sprite_2d.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()

func blit_junk_sprites():
	for junk in range(4):
		var damage_number_inst = Utils.instantiate_scene_on_world(ExplosionScrap, global_position + Vector2(randi_range(-8,8), randi_range(-12,-6))) #offset the global_position 


func _on_flash_timer_timeout():
	animated_sprite_2d.material.set_shader_parameter("flash_modifier", 0)


func _on_hurt_box_component_hurt(hitbox, damage):
	stats.health -= damage
	Sounds.play(Sounds.small_hit, 1.0, -9.5)
	blit_damage_number(damage)
	flash()

func throw_pick():
	var pick = Utils.instantiate_scene_on_world(Pickaxe, global_position)
	pick.throw_direction = facing_direction
	pick.update_velocity()
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("Stand")


func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionDust, global_position + Vector2(0, -5))
	Sounds.play(Sounds.enemy_die_one, 1.0, randi_range(-9.0, 0.0))
	blit_junk_sprites()
	queue_free()
