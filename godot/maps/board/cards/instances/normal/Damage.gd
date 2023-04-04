class_name Damage
extends Card


func _init():
	title = "Damage"
	description = "Give 5 damage in a other player"


func effect(board: Board, player: BoardPlayer) -> void:
	var players = board.players.filter(
		func(p): return p != player
	)
	var selected_player := await player.select_item(
		players
	) as BoardPlayer
	selected_player.hp -= 5
