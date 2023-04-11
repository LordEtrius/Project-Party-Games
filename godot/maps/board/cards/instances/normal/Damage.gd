class_name Damage
extends Card

const SELECTOR = preload(
	"res://maps/board/selectors/item_selector/ItemSelector.tscn"
)
const DAMAGE = 5

func _init():
	title = "Damage"
	description = "Give 5 damage in a other player"


func effect(board: Board, player: BoardPlayer) -> void:
	# Gets all players except the current player
	var players = board.players.filter(
		func(p): return p != player
	)
	# Creates a selector to select a player
	var selector = SELECTOR.instantiate().init(players) as ItemSelector
	# Await for the selector to return a player
	var selected_player := await player.select(selector) as BoardPlayer
	# Applies the damage
	selected_player.hp -= DAMAGE
	# Transitions back to the player
	await TransitionEvent.transition_to(player)
