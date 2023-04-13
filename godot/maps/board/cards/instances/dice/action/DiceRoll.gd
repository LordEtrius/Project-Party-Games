extends Node2D

signal rolled_dice(number: int)

@onready var dice = $Sprite2D

var max_tiles := 6
var min_tiles := 1
var speed := 0

var _nro_sort := 1

func _process(_delta):
	speed += 1
	if speed % 2 == 0:
		_nro_sort = Util.randi_from_range(min_tiles, max_tiles)
		dice.frame = _nro_sort - 1 


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_stop_dice()
			return
	
	if event.is_action_pressed("confirm"):
		_stop_dice()
		return


func _stop_dice():
	set_process(false)
	await get_tree().create_timer(1).timeout
	rolled_dice.emit(_nro_sort)
