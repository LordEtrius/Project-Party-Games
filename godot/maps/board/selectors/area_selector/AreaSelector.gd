## The class AreaSelector is a node that can be used to select multiple nodes in a scene. 
## The class is a child of Area2D and uses the get_overlapping_areas() function to get all 
## the nodes that are overlapping with the AreaSelector. 
## The nodes are then emitted in the signal selected(items: Array) . 
## The class also rotates itself to face the mouse position.
## Its main purpose is to be inherited by other classes that will add a CollisionShape
## to tell the AreaSelector what to select.
class_name AreaSelelector
extends Area2D

signal selected(items: Array)

@export var rotate := false

func _process(_delta):
	if rotate:
		var mouse_pos := get_global_mouse_position()
		self.look_at(mouse_pos)


func _input(event):
	if event.is_action_pressed("confirm"):
		var areas := self.get_overlapping_areas().map(
			func(area): return area.owner
		)
		selected.emit(areas)
		BoardEvent.finished_selection.emit()


func _ready():
	BoardEvent.entered_selection.emit()
