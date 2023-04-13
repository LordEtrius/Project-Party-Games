extends Node2D

signal rolled_dice(number: int)

@onready var dice = $Sprite2D

var max_tiles := 6
var min_tiles := 1
var speed = 0

func _process(delta):
	speed += 1
	if speed % 2 == 0:
		var nro_sort = Util.randi_from_range(min_tiles, max_tiles)
		dice.frame = nro_sort - 1 
		if Input.get_mouse_button_mask() == 1:
			set_process(false)
			await get_tree().create_timer(1).timeout
			rolled_dice.emit(nro_sort)
			
