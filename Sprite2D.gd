extends Sprite2D

func _ready():
	ghosting()


func ghosting():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	queue_free()