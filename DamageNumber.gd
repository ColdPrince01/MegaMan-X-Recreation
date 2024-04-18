extends Node2D

@onready var label = $Label

var vel = Vector2(randf_range(-100,100), randf_range(-400,-100)) #randomizes velocity between given values
var lifetime = 2 #amount of time text will exist

var number = 0

var blink = 0 #I believe this is the amount of time until the blinking begins, counts upwards during physics process
var blink_intrvl = 0.03
var gravity := 375.0
var velocity = Vector2()

func _ready() -> void:
	label.text = str(number) #at ready, whatever number is gets passed in to be label text's string
	scale *= countZerosInInteger(number) 
	

func _process(delta: float) -> void:
	lifetime -= delta
	position += vel * delta
	vel /= 1.09 #every physics step the current velocity is divided by 1.09 until it eventually reaches zero (number stops moving), removing this line will essentially make the numbers explode outwards without stopping.
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
