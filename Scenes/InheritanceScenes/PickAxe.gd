extends Projectile

@export var throw_height := -350.0
@export var fall_speed := 375.0
@export var gravity := 900.0

var throw_direction := 1

func update_velocity():
	velocity.x = speed * throw_direction
	velocity.y = throw_height

func _process(delta):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta #updates bullet position every process frame
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, throw_height * 1.5, fall_speed )



