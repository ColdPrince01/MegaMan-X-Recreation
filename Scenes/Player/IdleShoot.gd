extends AttackMachine

var string_name = "IdleShoot, "

func enter() -> void:
	parent.character_animator.play("idle_shoot")
	
	
