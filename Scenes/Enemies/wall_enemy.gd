extends Node2D

const MetBullet = preload("res://Scenes/InheritanceScenes/met_bullet.tscn")
const DamageNumber = preload("res://Unrelated/damage_number.tscn")
const ExplosionDust = preload("res://Unrelated/ExplosionDust.tscn")
const ExplosionScrap = preload("res://OtherScenes/explosion_scrap.tscn")

@onready var sprite = $Sprite
@onready var stats = $Stats
@onready var player_detector = $PlayerDetector
@onready var detector_shape = $PlayerDetector/DetectorShape
@onready var attack_timer = $AttackTimer
@onready var flash_timer = $FlashTimer

enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var facing_direction = DIRECTION.RIGHT

var self_dir = 1

func _ready():
	sprite.scale.x = facing_direction
	


func get_direction():
	if sprite.flip_h: #if sprite is flipped
		self_dir = -1 #direction is equal to -1
	else:
		self_dir = 1 #otherwise direction is right (sprite is facing right)

	
	return self_dir

func spawn_bullets(spawn_pos):
	var bullet : Node2D
	var world = get_tree().current_scene
	for particle in range(3):
		bullet = MetBullet.instantiate()
		if self.rotation_degrees == 0:
			bullet.initialize(spawn_pos + Vector2(6,0), Vector2(1,-0.5).rotated(particle * PI/6), bullet.speed)
		elif self.rotation_degrees > 0:
			bullet.initialize(spawn_pos + Vector2(-6,0), Vector2(-1,0.5).rotated(particle * PI/6), bullet.speed)
		world.add_child.call_deferred(bullet)
	attack_timer.start()

func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()



func _on_player_detector_area_entered(area):
	if attack_timer.time_left <= 0.0:
		sprite.play("Shoot")
		spawn_bullets(global_position)
		detector_shape.set_deferred("disabled", true)
		Sounds.play(Sounds.enemy_bullet)
		await sprite.animation_finished
		sprite.play("Reset")

func blit_junk_sprites():
	for junk in range(4):
		var damage_number_inst = Utils.instantiate_scene_on_world(ExplosionScrap, global_position + Vector2(randi_range(-8,8), randi_range(-12,-6))) #offset the global_position 

func _on_flash_timer_timeout():
	sprite.material.set_shader_parameter("flash_modifier", 0)

func blit_damage_number(number):
	var damage_number_inst = Utils.instantiate_scene_on_world(DamageNumber, global_position + Vector2(0, -12)) #offset the global_position 
	damage_number_inst.number = number
	

func _on_hurt_box_component_hurt(hitbox, damage):
	stats.health -= damage
	flash()
	blit_damage_number(damage)
	Sounds.play(Sounds.small_hit, 1.0, -9.5)


func _on_attack_timer_timeout():
	detector_shape.set_deferred("disabled", false)


func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionDust, global_position)
	Sounds.play(Sounds.enemy_die_one, 1.0, randi_range(-9.0, 0.0))
	blit_junk_sprites()
	queue_free()
