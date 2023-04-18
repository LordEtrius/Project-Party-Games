extends Control

signal discarded

var player: BoardPlayer = null : set = set_player
var max_cards: int = 5
var points_gained_per_discard: int = 1

@onready var _cards := $Cards
@onready var _garbage := $Garbage
@onready var _discard_label := $Label

func set_player(new_player: BoardPlayer) -> void:
	_cards.reset()
	if new_player != null:
		var player_cards := new_player.cards
		player_cards.connect("removed_from_deck",Callable(self,"_on_removed_from_deck"))
		if _discard_label != null:
			_discard_label.text = "Please discard %s card(s)" % str(player_cards.deck.size() - 5)
		if _cards != null:
			_cards.add_cards_to_ui(player_cards.deck)
	if player != null:
		var old_deck := player.cards
		old_deck.disconnect("removed_from_deck",Callable(self,"_on_removed_from_deck"))
	player = new_player


func _ready():
	set_player(player)
	_garbage.connect("discarded",Callable(self,"_on_Garbage_discarded"))


func _on_Garbage_discarded(card):
	player.cards.remove_from_deck(card)


func _on_removed_from_deck(_card: Card, idx: int):
	player.score.sub_points += points_gained_per_discard
	var player_cards := player.cards
	_cards.remove_card(idx)
	if player_cards.deck.size() <= max_cards:
		_cards.disable_drag()
	await _garbage.animate()
	if player_cards.deck.size() <= max_cards:
		emit_signal("discarded")
