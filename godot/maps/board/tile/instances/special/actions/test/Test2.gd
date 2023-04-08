class_name Test2
extends SpecialAction

func _init():
	super._init()
	sprite = preload("res://assets/tiles/icon_special2.png")


func effect(_board: Board, player: BoardPlayer, _ui: CanvasLayer) -> void:
	player.score.sub_points += 2