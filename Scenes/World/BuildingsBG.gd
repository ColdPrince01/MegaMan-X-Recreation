extends ParallaxLayer


@export var cloud_speed := -15.0

func _process(delta):
	self.motion_offset.x += cloud_speed * delta