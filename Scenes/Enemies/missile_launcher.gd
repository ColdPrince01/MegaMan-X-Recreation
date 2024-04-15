extends Node2D

const JunkSprites = preload("res://Scenes/Enemies/junk_sprites.tscn")
const DamageNumber = preload("res://Unrelated/damage_number.tscn")
const MissileScene = preload("res://Scenes/InheritanceScenes/missile.tscn")
const ExplosionDust = preload("res://Unrelated/explosion_dust_particle.tscn")
const ExplosionDustBig = preload("res://Unrelated/ExplosionDust.tscn")
const ExplosionScrap = preload("res://OtherScenes/explosion_scrap.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var facing_direction = DIRECTION.RIGHT
@export var detection_range := 60 #Detection range in pixels

@onready var sprite = $Sprite
@onready var player_finder = $PlayerFinder
@onready var muzzle_1 = $Muzzle1
@onready var muzzle_2 = $Muzzle2
@onready var flash_timer = $FlashTimer
@onready var stats = $Stats
@onready var fire_rate = $FireRate
@onready var death_player = $DeathPlayer
@onready var hit_box_component = $HitBoxComponent
@onready var hurt_collision = $HurtBoxComponent/HurtCollision
@onready var hit_collision = $HitBoxComponent/HitCollision
@onready var anim_timer = $AnimTimer
@onready var anim_collision = $AnimDetector/AnimCollision
@onready var anim_detector = $AnimDetector



func _ready():
	sprite.flip_h = facing_direction < 1
	player_finder.target_position.x = detection_range
	anim_collision.shape.size.x = detection_range
	anim_collision.position.x *= facing_direction
	player_finder.scale.x = facing_direction
	muzzle_1.position.x *= sign(facing_direction)
	muzzle_2.position.x *= sign(facing_direction)


func _physics_process(delta):
	#If the player is detected with the player detector, play the animation
	#Fire the missile, wait, then go back to an idle state
	if player_finder.is_colliding():
		if fire_rate.time_left <= 0.0:
			fire_missile()
			fire_rate.start()
			await get_tree().create_timer(2.0).timeout
		
			
	else:
		if not player_finder.is_colliding():
			var current_anim = sprite.get_animation()
			if current_anim == "Open":
				pass




func flash():
	sprite.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()


func createDeathExplosion():
	var dust = Utils.instantiate_scene_on_world(JunkSprites, global_position + Vector2(0, -9))
	dust.amount = 10
	


func fire_missile():
	if facing_direction == DIRECTION.RIGHT:
		var missile_one = Utils.instantiate_scene_on_world(MissileScene, muzzle_1.global_position)
		var missile_two = Utils.instantiate_scene_on_world(MissileScene, muzzle_2.global_position)
		missile_one.velocity.x = sign(facing_direction) * missile_one.speed
		missile_two.velocity.x = sign(facing_direction) * missile_one.speed
	else:
		var missile_one = Utils.instantiate_scene_on_world_flipped(MissileScene, muzzle_1.global_position)
		var missile_two = Utils.instantiate_scene_on_world_flipped(MissileScene, muzzle_2.global_position)
		missile_one.velocity.x = sign(facing_direction) * missile_one.speed
		missile_two.velocity.x = sign(facing_direction) * missile_one.speed

func blit_damage_number(number):
	var damage_number_inst = Utils.instantiate_scene_on_world(DamageNumber, global_position) #offset the global_position 
	damage_number_inst.number = number
	

func blit_junk_sprites():
	for junk in range(4):
		var damage_number_inst = Utils.instantiate_scene_on_world(ExplosionScrap, global_position + Vector2(randi_range(-8,8), randi_range(-12,12))) #offset the global_position 

func _on_stats_no_health():
	sprite.stop()
	Sounds.play(Sounds.enemy_die_four, 1.0, -10.0)
	anim_collision.set_deferred("disabled", true)
	hurt_collision.set_deferred("disabled", true)
	hit_collision.set_deferred("disabled", true)
	player_finder.set_deferred("enabled", false)
	var explosion_dust = Utils.instantiate_scene_on_world(ExplosionDust, global_position)
	death_player.play("Death")
	await get_tree().create_timer(2.0).timeout
	var explosion = Utils.instantiate_scene_on_world(ExplosionDustBig, global_position)
	explosion.scale *= 2
	blit_junk_sprites()
	Sounds.play(Sounds.enemy_die_one, 1.0, randi_range(-9.0, 0.0))
	queue_free()
	explosion_dust.queue_free()


func _on_flash_timer_timeout():
	sprite.material.set_shader_parameter("flash_modifier", 0)


func _on_hurt_box_component_hurt(hitbox, damage):
	stats.health -= damage
	Sounds.play(Sounds.small_hit, 1.0, -9.5)
	flash()
	blit_damage_number(damage)
	


func _on_anim_timer_timeout(): #when the timer times out
	anim_collision.set_deferred("disabled", false)  #turn on the collision detector for animations
	if anim_detector.has_overlapping_bodies(): #if the anim detector detects the player (we're assuming its already on the open animation frame)
		anim_collision.set_deferred("disabled", true)
		sprite.play("Open_P")
		anim_timer.start() #start the timer to repeat the check
	else:
		sprite.play("Close")
		




func _on_anim_detector_body_entered(body):
	anim_timer.start()
	sprite.play("Open")
	anim_collision.set_deferred("disabled", true)
