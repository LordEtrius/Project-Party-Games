class_name Swap
extends Card

const SELECTOR = preload(
	"res://maps/board/selectors/item_selector/ItemSelector.tscn"
)

func _init():
	title = "Swap"
	description = "Swap places with another player"


func effect(board: Board, player: BoardPlayer) -> void:
	# Gets all players except the current player
	var players = board.players.filter(
		func(p): return p != player
	)
	# Creates a selector to select a player
	var selector = SELECTOR.instantiate().init(players) as ItemSelector
	# Await for the selector to return a player
	var selected_player := await player.select(selector) as BoardPlayer
	# Swap the players
	var selected_player_tile = selected_player.actual_tile
	await selected_player.teleport_to_tile(player.actual_tile)
	await TransitionEvent.transition_to(player)
	await player.teleport_to_tile(selected_player_tile)
	await player.actual_tile.play_effect(board, player)
