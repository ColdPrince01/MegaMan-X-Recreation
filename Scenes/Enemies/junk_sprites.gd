extends CPUParticles2D

@onready var smoke = $Smoke

func _ready():
	pass

func _physics_process(delta):
	smoke.global_position = self.global_position


func _on_timer_timeout():
	queue_free()
