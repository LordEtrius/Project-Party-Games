extends Card
class_name TeleportToTile

const SELECTOR := preload("res://maps/board/selectors/tile_selector/TileSelector.tscn")

func _init():
	title = "TeleportToTile"
	description = "Teleport the player to a selected tile"


func effect(board: Board, player: BoardPlayer) -> void:
	# loads the tile selector
	var selector = SELECTOR.instantiate() as TileSelector
	# waits for the player to select a tile
	var tile := await player.select(selector, true) as Tile
	# teleports the player to the selected tile
	await player.teleport_to_tile(tile)
	await player.actual_tile.play_effect(board, player)
