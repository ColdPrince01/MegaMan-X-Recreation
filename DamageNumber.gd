extends Node2D

@onready var label = $Label

var vel = Vector2(randf_range(-70,70), randf_range(-400,-100)) #randomizes velocity between given values
var lifetime = 2 #amount of time text will exist

var number = 0

var blink = 0 #I believe this is the amount of time until the blinking begins, counts upwards during physics process
var blink_intrvl = 0.03

func _ready() -> void:
	label.text = str(number) #at ready, whatever number is gets passed in to be label text's string
	scale *= countZerosInInteger(number) 
	

func _physics_process(delta: float) -> void:
	lifetime -= delta
	position += vel * delta
	vel /= 1.09
#	vel.y += 3
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
	if lifetime < 0:
		queue_free()
	
	
	

func countZerosInInteger(value: int) -> int:
		var zeroCount = 0
		var valueString = str(value)
		
		for i in range(valueString.length()):
			if valueString[i] == "0":
				zeroCount += 2
				print(zeroCount)
		
		return zeroCount
