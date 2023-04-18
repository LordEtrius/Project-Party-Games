class_name Card
extends Node

signal will_play_effect
signal played_effect

var type: CardsCollection.Type = CardsCollection.Type.MOVEMENT
var pool: CardsCollection.Pool = CardsCollection.Pool.ANY
var rarity: CardsCollection.Rarity = CardsCollection.Rarity.COMMON
var is_max_rarity: bool = false
var is_min_rarity: bool = false

var title: String = ""
var description: String = ""

## This function must be called before the card is used
## to set the card's categories
func set_categories(_pool: CardsCollection.Pool, _type: CardsCollection.Type, _rarity: CardsCollection.Rarity):
	pool = _pool
	type = _type
	rarity = _rarity


func _to_string() -> String:
	return self.title


func record(_board: Board, player: BoardPlayer):
	return "%s played %s" % [player.nick, title]


func effect(_board: Board, _player: BoardPlayer) -> void:
	pass


func play_effect(board: Board, player: BoardPlayer) -> void:
	emit_signal("will_play_effect")
	CardEvent.emit_signal("will_play_effect")
	CardEvent.emit_signal("record", record(board, player))
	await effect(board, player)
	CardEvent.emit_signal("played_effect")
	emit_signal("played_effect")
