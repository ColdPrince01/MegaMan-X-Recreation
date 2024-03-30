class_name CameraLimiter
extends Area2D


enum LimitX {NONE, LEFT, RIGHT} #enumerators for X-Axis limits
enum LimitY {NONE, TOP, BOTTOM} #enumerators for Y-Axis limits

const MAX_VAL = 100000 #camera limit constants for when there are no other limits

#exportable variables for changing camera limits in editor, default to no camera limits
@export var limit_x : LimitX = LimitX.NONE 
@export var limit_y : LimitY = LimitY.NONE

@onready var limit_position = $LimitPosition


func get_limit_top():
	if limit_y != LimitY.TOP: #if the top limit is not of type LimitY.TOP
		return -MAX_VAL #default to MAX_VAL camera limit
	return limit_position.global_position.y #otherwise default to returning the Y-Position of the Marker

func get_limit_bottom():
	if limit_y != LimitY.BOTTOM:
		return MAX_VAL
	return limit_position.global_position.y
	

func get_limit_left():
	if limit_x != LimitX.LEFT:
		return -MAX_VAL
	return limit_position.global_position.x
	

func get_limit_right():
	if limit_x != LimitX.RIGHT:
		return MAX_VAL
	return limit_position.global_position.x
