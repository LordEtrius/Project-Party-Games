extends Control

signal pressed_play

@onready var Slots := $Turn/Control/Slots
@onready var _cards := $Cards
@onready var PlayButton := $Turn/Control/PlayButton

var deck = null : set = set_deck

func set_deck(new_deck):
	reset()
	if new_deck == null and deck != null:
		# TODO: better way to do this?
		deck.disconnect("added_to_deck",Callable(self,"_on_added_to_deck"))
		deck.disconnect("removed_from_deck",Callable(self,"_on_removed_from_deck"))
		deck.disconnect("added_to_hand",Callable(self,"_on_added_to_hand"))
		deck.disconnect("removed_from_hand",Callable(self,"_on_removed_from_hand"))
	if new_deck != null:
		new_deck.connect("added_to_deck",Callable(self,"_on_added_to_deck"))
		new_deck.connect("removed_from_deck",Callable(self,"_on_removed_from_deck"))
		new_deck.connect("added_to_hand",Callable(self,"_on_added_to_hand"))
		new_deck.connect("removed_from_hand",Callable(self,"_on_removed_from_hand"))
		if _cards != null:
			_cards.add_cards_to_ui(new_deck.deck)
	deck = new_deck


# this functions tells how the UI is reseted
func reset():
	# remove all cards from deck
	if _cards != null:
		_cards.reset()

	# reset all hand slots
	for slot in Slots.get_children():
		slot.reset()


func _ready():
	PlayButton.connect("pressed",Callable(self,"_on_Play_pressed"))
	for slot in Slots.get_children():
		slot.connect("removed_card",Callable(self,"_on_Slot_removed_card"))
		slot.connect("added_card",Callable(self,"_on_Slot_added_card"))
		slot.connect("changed_order",Callable(self,"_on_Slot_changed_order"))
		slot.connect("changed_card",Callable(self,"_on_Slot_changed_card"))


func _on_Slot_removed_card(_card, hand_idx: int):
	deck.remove_from_hand(hand_idx)


func _on_Slot_added_card(card, hand_idx: int):
	deck.pick_card(card, hand_idx)
	SoundFx.card_in01_hand()


func _on_Slot_changed_order(from_idx, to_idx):
	deck.change_hand_order(from_idx, to_idx)
	SoundFx.card_in02_hand()


func _on_Slot_changed_card(_old_card, new_card, hand_idx):
	deck.remove_from_hand(hand_idx)
	deck.pick_card(new_card, hand_idx)
	SoundFx.card_in01_hand()


func _on_Play_pressed():
	emit_signal("pressed_play")


func _on_added_to_deck(card: Card, _idx: int):
	_cards.add_card_to_ui(card)


func _on_removed_from_deck(_card: Card, idx: int):
	_cards.remove_card(idx)


func _on_added_to_hand(_card: Card, _idx: int):
	PlayButton.disabled = false


func _on_removed_from_hand(_card: Card, _idx: int):
	if deck.get_hand().size() == 0:
		PlayButton.disabled = true
