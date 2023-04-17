class_name BloodForBlood
extends Card

const SELECTOR := preload(
	"res://maps/board/selectors/area_selector/circle/CircleSelector.tscn"
)

const RADIUS := 130
const DAMAGE_OTHER := 16
const DAMAGE_SELF := 8

func _init():
	title = "Blood for Blood"
	description = "Damages the closest enemy by 16 health points and damages you 8"


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

	# Apply damage to closest player
	closest_player.hp -= DAMAGE_OTHER
	# Apply damage to player
	player.hp -= DAMAGE_SELF
	# Transitions back to the player
	await TransitionEvent.transition_to(player)
