## This class is used to store the cards that the player has in his deck and in his hand
class_name PlayerCards
extends Node

## Emits a signal when a card is added to the deck
signal added_to_deck(card, idx)
## Emits a signal when a card is removed from the deck
signal removed_from_deck(card, idx)
## Emits a signal when a card is added to the hand
signal added_to_hand(card, idx)
## Emits a signal when a card is removed from the hand
signal removed_from_hand(card, idx)

## This stores the cards that the player has in his deck
var deck: Array[Card] = []
## This stores the cards that the player has in his hand
var hand: Array[Card] = [null, null, null, null, null]

## Get the hand without null values
func get_hand() -> Array[Card]:
	var result: Array[Card] = []
	for hand_card in hand:
		if hand_card != null:
			result.append(hand_card)
	return result


## Reset the hand to null values
func reset_hand() -> void:
	hand = [null, null, null, null, null]


## Add a card to the deck
func add_to_deck(card: Card) -> void:
	# Append the card to the deck
	deck.append(card)
	# Emit the signal
	added_to_deck.emit(card, deck.size() - 1)
	

## Remove a card from the deck
func remove_from_deck(card: Card) -> void:
	# Find the card in the deck
	var deck_idx = deck.find(card)
	# If the card is in the deck
	if deck_idx != -1:
		# Remove the card from the deck
		deck.remove_at(deck_idx)
		# Emit the signal
		removed_from_deck.emit(card, deck_idx)


## Remove a card from the hand
func remove_from_hand(idx: int) -> void:
	# If the index is valid
	if idx < hand.size() and idx >= 0:
		# Get the card
		var card = hand[idx]
		# Add it back to the deck
		deck.append(card)
		# Remove it from the hand
		hand[idx] = null
		# Emit the signals
		added_to_deck.emit(card, deck.size() - 1)
		removed_from_hand.emit(card, idx)
	

## Change the order of the cards in the hand
func change_hand_order(from_idx: int, to_idx: int) -> void:
	# If the indexes are valid
	if from_idx < hand.size() and from_idx >= 0 and to_idx < hand.size() and to_idx >= 0:
		# Swap the cards
		var aux = hand[from_idx]
		hand[from_idx] = hand[to_idx]
		hand[to_idx] = aux


## Pick a card from the deck and put it in the hand
func pick_card(card: Card, hand_idx: int) -> void:
	if hand_idx < hand.size() and hand_idx >= 0:
		# Search the card in the deck
		var deck_idx = deck.find(card)
		# If the card is in the deck
		if deck_idx != -1:
			# Remove the card from the deck
			deck.remove_at(deck_idx)
			# Add the card to the hand
			hand[hand_idx] = card
			# Emit the signals
			added_to_hand.emit(card, hand_idx)
			removed_from_deck.emit(card, deck_idx)


## Remove all the cards from the deck
func clear_deck():
	deck.clear()


## Apply positive energy to the cards in the deck
func apply_positive_energy() -> void:
	# If the deck is empty
	if deck.size() == 0:
		CardEvent.record.emit("Deck is empty, adding a random COMMON card")
		_add_common_card()
		return

	# If the deck is full of max rarity cards, add a random COMMON card
	if _all_max_rarity() and not _is_deck_full():
		CardEvent.record.emit("Deck is full of max rarity cards, adding a random COMMON card")
		# Get a random common card
		_add_common_card()
		return
	
	# If the deck is full of cards, apply positive energy to the cards in the hand
	if _is_deck_full() and not _all_max_rarity():
		CardEvent.record.emit("Deck is full of cards, upgrading a random card")
		_upgrade_card()
		return

	# If the deck is 'normal'
	if not _is_deck_full() and not _all_max_rarity():
		var roll = randi() % 2
		if roll == 0:
			_add_common_card()
		else:
			_upgrade_card()
		return


## Apply negative energy to the cards in the deck
func apply_negative_energy() -> void:
	# If the deck is empty, do nothing
	if deck.size() == 0:
		return
	
	# Downgrade a random card
	_downgrade_card()


## Return true if the player's deck is full of max rarity cards
func _all_max_rarity() -> bool:
	return deck.all(func(card): return card.is_max_rarity)


## Return true if the deck is full
func _is_deck_full() -> bool:
	return deck.size() >= 5


## Adds a common card to the deck
func _add_common_card() -> void:
	var random_common_card = CardsCollection.get_random_card({ 
		CardsCollection.Rarity.COMMON: 99 
	})
	add_to_deck(random_common_card)
	CardEvent.record.emit("Gained card %s" % random_common_card)


## Upgrades a random deck card
func _upgrade_card() -> void:
	var card_to_upgrade = deck.filter(func(card): return not card.is_max_rarity).pick_random()
	var new_card = CardsCollection.upgrade_card(card_to_upgrade)
	
	remove_from_deck(card_to_upgrade)
	add_to_deck(new_card)

	CardEvent.record.emit("Upgraded card %s to %s" % [card_to_upgrade, new_card])

## Downgrades a random deck card
func _downgrade_card() -> void:
	# Get all possible cards to downgrade
	var possible_cards = deck.filter(func(card): return not card.is_min_rarity)
	# If there are no possible cards to downgrade, do nothing
	if possible_cards.size() == 0:
		return
	
	# Downgrade a random card
	var card_to_downgrade = possible_cards.pick_random()
	var new_card = CardsCollection.downgrade_card(card_to_downgrade)
	
	remove_from_deck(card_to_downgrade)
	add_to_deck(new_card)

	CardEvent.record.emit("Downgraded card %s" % card_to_downgrade)
	
