class_name TileSelector
extends CharacterBody2D

signal tile_selected(tile: Tile)

@onready var _area_selection := $Area2D as Area2D
@onready var _camera := $BaseCamera
@onready var _movement := $TopDownMovement

func get_camera():
	return _camera


func _input(event):
	if event.is_action_pressed("confirm"):
		var areas := _area_selection.get_overlapping_areas()
		if areas.is_empty():
			return
		var tile = areas[0].get_parent() as Tile
		if not tile.teleportable:
			return
		emit_signal("tile_selected", tile)
		BoardEvent.emit_signal("finished_selection")


func _ready():
	BoardEvent.emit_signal("entered_selection")
	_movement.limit_right = _camera.limit_right
	_movement.limit_left = _camera.limit_left
	_movement.limit_bottom = _camera.limit_bottom
	_movement.limit_top = _camera.limit_top
	print_debug(_movement.limit_right, _movement.limit_left, _movement.limit_top, _movement.limit_bottom)
