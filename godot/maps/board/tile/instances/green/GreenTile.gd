@tool
extends Tile

func effect(_board, player):
	player.suffer_damage(8)
	TileEvent.emit_signal("record", "Green tile: %s Loss HP" % player.nick)
	await player.animate_scale()
