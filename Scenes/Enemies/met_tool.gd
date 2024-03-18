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

enum DIRECTION {LEFT = -1, RIGHT = 1}

@onready var player = MainInstances.player

@export var facing_direction = DIRECTION.RIGHT

var state 

func _ready():
	player_finder.target_position.x *= facing_direction
	animated_sprite_2d.scale.x = facing_direction
	marker_2d.position.x = abs(marker_2d.position.x) * facing_direction

func _physics_process(delta):
	#If the player can be detected but is facing away from the player finder, open and fire
	
	pass


func handle_anims():
	pass

func _on_stats_no_health():
	queue_free()
