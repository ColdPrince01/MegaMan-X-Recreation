extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready():
	Sounds.play(Sounds.enemy_missile, 1.0, -15.0)

