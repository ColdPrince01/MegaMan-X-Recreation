extends CharacterBody2D

const MetBullet = preload("res://Scenes/InheritanceScenes/met_bullet.tscn")
const JunkSprites = preload("res://Scenes/Enemies/junk_sprites.tscn")
const DamageNumber = preload("res://Unrelated/damage_number.tscn")
const ExplosionDust = preload("res://Unrelated/ExplosionDust.tscn")
const ExplosionScrap = preload("res://OtherScenes/explosion_scrap.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var hit_box_component = $HitBoxComponent
@onready var hurt_box_component = $HurtBoxComponent
@onready var stats = $Stats
@onready var marker_2d = $Marker2D
@onready var player_finder = $PlayerFinder
@onready var hit_collision = $HitBoxComponent/HitCollision
@onready var hurt_collision = $HurtBoxComponent/HurtCollision
@onready var active_area = $ActiveArea
@onready var active_shape = $ActiveArea/ActiveShape
@onready var fire_direction = $FireDirection
@onready var anim_timer = $AnimTimer
@onready var state_timer = $StateTimer
@onready var flash_timer = $FlashTimer



enum DIRECTION {LEFT = -1, RIGHT = 1}

@onready var player = MainInstances.player

@export var facing_direction = DIRECTION.RIGHT
@export var area_size = 55.0
@export var speed = 75.0
@export var sizeScale : float = 1.0

var player_dir = 1
var self_dir = 1
var spawn_pos : Vector2
var active = false
var velo = Vector2()

func _ready():
	active_shape.shape.radius = area_size
	animated_sprite_2d.scale.x = facing_direction
	marker_2d.position.x = abs(marker_2d.position.x) * facing_direction
	player_finder.target_position.x = area_size

func _physics_process(delta):
	handle_anims()
	get_direction()
	find_player(global_position)
	if player_finder.is_colliding():
		if player_dir == self_dir:
			anim_timer.start()
			if state_timer.time_left <= 0.0:
				spawn_bullets(marker_2d.global_position)
				Sounds.play(Sounds.enemy_bullet)


func get_direction():
	if animated_sprite_2d.flip_h: #if sprite is flipped
		self_dir = -1 #direction is equal to -1
		player_finder.target_position.x = abs(player_finder.target_position.x) * -1
	else:
		self_dir = 1 #otherwise direction is right (sprite is facing right)
		player_finder.target_position.x = abs(player_finder.target_position.x)

	
	return self_dir


func spawn_bullets(spawn_pos):
	var bullet : Node2D
	var world = get_tree().current_scene
	for particle in range(3):
		bullet = MetBullet.instantiate()
		if self_dir == DIRECTION.RIGHT:
			bullet.initialize(spawn_pos, Vector2(1,-0.5).rotated(particle * PI/6), bullet.speed)
		elif self_dir == DIRECTION.LEFT:
			bullet.initialize(spawn_pos, Vector2(-1,0.5).rotated(particle * PI/6), bullet.speed)
		world.add_child.call_deferred(bullet)
	state_timer.start()
	

func blit_junk_sprites():
	for junk in range(4):
		var damage_number_inst = Utils.instantiate_scene_on_world(ExplosionScrap, global_position + Vector2(randi_range(-8,8), randi_range(-12,-6))) #offset the global_position 

# placeholder func()
## 	weight amount : 25
## var number : int
## randomize()
## if number >= 25



func flash():
	animated_sprite_2d.material.set_shader_parameter("flash_modifier", 1)
	flash_timer.start()

func handle_anims():
	if anim_timer.time_left > 0.0:
		animated_sprite_2d.play("Open_P")
	elif anim_timer.time_left <= 0.0:
		animated_sprite_2d.play("Close_P")

func find_player(from):
	if active_area.has_overlapping_bodies():
		marker_2d.position.x = abs(marker_2d.position.x) * self_dir
		animated_sprite_2d.flip_h = player.global_position < global_position
		if player.x_sprite.flip_h:
			player_dir = -1
		else: 
			player_dir = 1
				



func blit_damage_number(number):
	var damage_number_inst = Utils.instantiate_scene_on_world(DamageNumber, global_position + Vector2(0, -12)) #offset the global_position 
	damage_number_inst.number = number
	



func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionDust, global_position + Vector2(0, -10))
	Sounds.play(Sounds.enemy_die_one, 1.0, randi_range(-9.0, 0.0))
	blit_junk_sprites()
	queue_free()




func _on_hurt_box_component_hurt(hitbox, damage):
	if anim_timer.time_left > 0.0: #if the mettool is open, take no damage
		stats.health -= damage
		Sounds.play(Sounds.small_hit, 1.0, -9.5)
		blit_damage_number(damage)
		flash()
	elif anim_timer.time_left <= 0.0:
		stats.health -= 0
		blit_damage_number(0)
		Sounds.play(Sounds.small_deflect)



func _on_visible_on_screen_notifier_2d_screen_exited():
	set_physics_process(false)




func _on_visible_on_screen_notifier_2d_screen_entered():
	set_physics_process(true)


func _on_flash_timer_timeout():
	animated_sprite_2d.material.set_shader_parameter("flash_modifier", 0)
