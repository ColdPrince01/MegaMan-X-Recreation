extends CharacterBody2D

const DamageNumber = preload("res://Unrelated/damage_number.tscn")
const ExplosionDust = preload("res://Unrelated/ExplosionDust.tscn")
const ExplosionScrap = preload("res://OtherScenes/explosion_scrap.tscn")

@export var acceleration = 100.0
@export var max_speed = 75.0
@export var sight_radius = 50.0

@onready var waypoint_path_finding = $WaypointPathFinding
@onready var sprite = $Sprite
@onready var stats = $Stats
@onready var operating_shape = $OperatingArea/OperatingShape



func _ready():
	set_physics_process(false) #at the onset of entering the scene, the enemy will not move unless they can be seen 
	operating_shape.shape.radius = sight_radius


func _physics_process(delta):
	var player = MainInstances.player
	if player is CharacterBody2D: #if the variable passed in is from a character body 2D
		move_toward_target(waypoint_path_finding.pathfinding_next_position, delta) #use the move_toward_target function
		sprite.play("Flight")
	


func move_toward_target(target_position, delta): #function for moving flying enemy towards player, asks for target_position and delta
	var direction = global_position.direction_to(target_position) #creates variable direction and sets it equal tp the global position direction to target position (relative to parent node)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta) # velocity will be set to velocity moving toward its max speed (multiplied by the direction to the node path) at acceleration * delta
	sprite.flip_h = global_position < target_position #if the enemy node's position is to the left of the player then the sprite will be flipped 
	move_and_slide()


func blit_damage_number(number):
	var damage_number_inst = Utils.instantiate_scene_on_world(DamageNumber, global_position + Vector2(0, -12)) #offset the global_position 
	damage_number_inst.number = number
	

func blit_junk_sprites():
	for junk in range(4):
		var damage_number_inst = Utils.instantiate_scene_on_world(ExplosionScrap, global_position + Vector2(randi_range(-8,8), randi_range(-12,-6))) #offset the global_position 



func _on_hurt_box_component_hurt(hitbox, damage):
	stats.health -= damage
	Sounds.play(Sounds.small_hit, 1.0, -9.5)
	blit_damage_number(damage)
	


func _on_stats_no_health():
	Utils.instantiate_scene_on_world(ExplosionDust, global_position + Vector2(0, -10))
	Sounds.play(Sounds.enemy_die_one, 1.0, randi_range(-9.0, 0.0))
	blit_junk_sprites()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	set_physics_process(false)
	await sprite.animation_looped
	sprite.play("Closed")


func _on_operating_area_area_entered(area):
	set_physics_process(true)
	await sprite.animation_finished
	
