class_name Teleport
extends Card

const SELECTOR = preload(
	"res://maps/board/selectors/item_selector/ItemSelector.tscn"
)

func _init():
	title = "Teleport"
	description = "Teleport to another player tile"


func effect(board: Board, player: BoardPlayer) -> void:
	# Gets all players except the current player
	var players = board.players.filter(
		func(p): return p != player
	)
	# Creates a selector to select a player
	var selector = SELECTOR.instantiate().init(players) as ItemSelector
	# Await for the selector to return a player
	var selected_player := await player.select(selector) as BoardPlayer
	# Teleport to the selected player tile
	var selected_player_tile = selected_player.actual_tile
	await TransitionEvent.transition_to(player)
	await player.teleport_to_tile(selected_player_tile)
	await player.actual_tile.play_effect(board, player)

