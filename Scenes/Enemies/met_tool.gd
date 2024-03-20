extends CharacterBody2D


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
@onready var timer = $Timer
@onready var timer_2 = $Timer2

enum DIRECTION {LEFT = -1, RIGHT = 1}

@onready var player = MainInstances.player

@export var facing_direction = DIRECTION.RIGHT

var state 

func _ready():
	player_finder.target_position.x *= facing_direction
	animated_sprite_2d.scale.x = facing_direction
	marker_2d.position.x = abs(marker_2d.position.x) * facing_direction

func _physics_process(delta):
	
	
	animated_sprite_2d.flip_h = player.global_position < global_position
	
	
	var normal_point = player_finder.get_collision_normal()
	if active_area.has_overlapping_bodies():
		find_player(global_position)
		facing_direction = animated_sprite_2d.scale.x
		if facing_direction == player.get_direction().x:
			timer.start()
		#If the player can be detected but is facing away from the player finder, open and fire
	pass
	
	move_and_slide()
	print(facing_direction)

func find_player(from):
	player_finder.global_position = from
	player_finder.target_position = player.global_position - from
	player_finder.force_raycast_update()


func handle_anims():
	animated_sprite_2d.play("Open")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("Open_P")

func handle_anims_2():
	#test function
	animated_sprite_2d.play("Close")

func _on_stats_no_health():
	queue_free()


func _on_timer_timeout():
	handle_anims()
	timer_2.start()


func _on_timer_2_timeout():
	handle_anims_2()
