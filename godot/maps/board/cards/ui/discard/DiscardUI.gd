extends Control

signal discarded

var deck = null : set = set_deck

@onready var _cards := $Cards
@onready var _garbage := $Garbage
@onready var _discard_label := $Label

func set_deck(new_deck):
	_cards.reset()
	if new_deck != null:
		new_deck.connect("removed_from_deck",Callable(self,"_on_Deck_removed_from_deck"))
		if _discard_label != null:
			_discard_label.text = "Please discard %s card(s)" % str(new_deck.deck.size() - 5)
		if _cards != null:
			_cards.add_cards_to_ui(new_deck.deck)
	if deck != null:
		deck.disconnect("removed_from_deck",Callable(self,"_on_Deck_removed_from_deck"))
	deck = new_deck


func _ready():
	set_deck(deck)
	_garbage.connect("discarded",Callable(self,"_on_Garbage_discarded"))


func _on_Garbage_discarded(card):
	deck.remove_card(card)


func _on_Deck_removed_from_deck(_card: Card, idx: int):
	_cards.remove_card(idx)
	await _garbage.animate()
	if deck.deck.size() <= 5:
		emit_signal("discarded")
