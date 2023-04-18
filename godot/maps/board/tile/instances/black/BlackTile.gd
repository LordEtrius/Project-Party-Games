@tool
extends Tile


func effect(_board: Board, player: BoardPlayer):
	var random_card = CardsCollection.get_random_card()
	player.cards.add_to_deck(random_card)
	TileEvent.emit_signal(
		"record", "Black tile: %s gained %s card" % [player.nick, str(random_card)]
	)
	await player.animate_scale()
