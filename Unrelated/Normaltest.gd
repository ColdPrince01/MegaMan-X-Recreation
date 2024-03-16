extends Node2D

@onready var point_light_2d = $PointLight2D
@onready var sprite_2d = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	point_light_2d.global_position = sprite_2d.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	point_light_2d.global_position = get_global_mouse_position()
