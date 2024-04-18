extends Node2D

const DustEffectScene = preload("res://Scenes/Player/dust_effect.tscn")

@onready var junk_sprite = $JunkSprite
@onready var explosion_trail = $ExplosionTrail

var vel = Vector2(randf_range(-75,75), randf_range(-250,-100)) #randomizes velocity between given values
var lifetime = 2 #amount of time text will exist

var number = 0

var blink = 0 #I believe this is the amount of time until the blinking begins, counts upwards during physics process
var blink_intrvl = 0.03
var gravity := 375.0
var velocity = Vector2()

func _ready() -> void:
	randomize()
	junk_sprite.set_frame(randi_range(0,5)) #Possible experiment to get a random frame from the animation
	

func _process(delta: float) -> void:
	position += vel * delta 
	vel.y += gravity * delta
	clamp(vel.y, -375, 375)
	blink += delta
	
	
	if blink > 1.6:
		blink_intrvl -= delta
		if blink_intrvl <= -0.03:
			blink_intrvl = 0.03
		if blink_intrvl <= 0:
			modulate = Color8(0,0,0,0)
		else:
			modulate = Color.WHITE
	else:
		modulate = Color.WHITE
		
	scale = scale.lerp(Vector2(1,1), delta * 5)
	
	
	
	



func _on_explosion_trail_timeout():
	var dust = Utils.instantiate_scene_on_world(DustEffectScene, global_position)
	dust.scale.x = 0.85
	dust.scale.y = 0.85


func _on_visible_on_screen_notifier_2d_screen_exited():
	await get_tree().create_timer(2.5).timeout
	queue_free()
