class_name Burner
extends Card

const SELECTOR := preload(
	"res://maps/board/selectors/area_selector/circle/CircleSelector.tscn"
)
const RADIUS = 100

func _init():
	title = "Burner"
	description = "Burns all your cards and deals 5 damage for each card burned to the closest player in the area"


func effect(_board: Board, player: BoardPlayer) -> void:
	# Select the nodes in a circular area
	var selector := SELECTOR.instantiate().init(RADIUS) as CircleSelector
	var nodes_in_area := await player.select(selector) as Array

	# Get all the players in the area
	var players_in_area := nodes_in_area.filter(
		func(node): return node is BoardPlayer and node != player
	)

	# No player in range
	if players_in_area.is_empty():
		TileEvent.emit_signal("record", "No player in range")
		return
	
	# Get closest player
	var closest_player := players_in_area.reduce(
		func(a, b):
			if a.position.distance_to(player.position) < b.position.distance_to(player.position):
				return a
			else:
				return b
	) as BoardPlayer

	# Burn all cards
	closest_player.hp -= 5 * player.deck.deck.size()

	# Clear the deck
	player.deck.deck.clear()
