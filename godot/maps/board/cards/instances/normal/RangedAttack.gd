class_name RangedAttack
extends Card

const SELECTOR2 := preload(
	"res://maps/board/selectors/area_selector/circle/CircleSelector.tscn"
)

const SELECTOR = preload(
	"res://maps/board/selectors/item_selector/ItemSelector.tscn"
)
const RADIUS = 400
const DAMAGE = 3

func _init():
	title = "Ranged Attack"
	description = "Deal 3 damage to a playerr"


func effect(_board: Board, player: BoardPlayer) -> void:
	# Creates a selector to get all the players in range
	var selector2 := SELECTOR2.instantiate().init(RADIUS) as CircleSelector
	var nodes_in_area := await player.select(selector2) as Array	
	
	var players_in_area := nodes_in_area.filter(
		func(node): return node is BoardPlayer and node != player
	)
	
	# No player in range
	if players_in_area.is_empty():
		TileEvent.emit_signal("record", "No player in range")
		return
	else:
		# Creates a selector to select a player
		var selector = SELECTOR.instantiate().init(players_in_area) as ItemSelector
		# Await for the selector to return a player
		var selected_player := await player.select(selector) as BoardPlayer
		# Applies the damage
		selected_player.hp -= DAMAGE
	# Transitions back to the player
	await TransitionEvent.transition_to(player)
