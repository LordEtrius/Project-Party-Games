class_name Test1
extends SpecialAction

func _init():
	super._init()
	sprite = preload("res://assets/tiles/icon_special1.png")


func effect(_board: Board, player: BoardPlayer, _ui: CanvasLayer) -> void:
	player.score.sub_points += 1