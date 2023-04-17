extends Node

enum Type { MOVEMENT, OFFENSE, TELEPORTATION, HEALTH, GREED, UTILITY, DEFENSE }
enum Pool { WATER, FIRE, EARTH, AIR, LIGHT, DARK, ANY }
enum Rarity { COMMON, RARE, BROKEN, LEGENDARY }

var chances_base := {
	Rarity.COMMON: 60,
	Rarity.RARE: 80,
	Rarity.BROKEN: 90,
	Rarity.LEGENDARY: 99
}

var cards = {
	Pool.ANY: {
		Type.MOVEMENT: {
			Rarity.COMMON: [Dice],
		},
		Type.OFFENSE: {
			Rarity.BROKEN: [BloodForBlood],
			Rarity.COMMON: [CloseAttack],
			Rarity.RARE: [RangedAttack],
			Rarity.LEGENDARY: [Burner],
		},
		Type.GREED: {
			Rarity.COMMON: [SubPoint],
		},
		Type.HEALTH: {
			Rarity.COMMON: [Suicide]
		},
		Type.TELEPORTATION: {
			Rarity.BROKEN: [WhereAmI],
			Rarity.COMMON: [Teleport],
			Rarity.RARE: [Teleport],
			Rarity.LEGENDARY: [TeleportToTile, Swap],
		}
	},
	# Pool.WATER: {

	# },
}

## Get a random card
func get_random_card(chances := chances_base, pools := [] as Array[Pool]):
	# Adds any to pools array, so it aways take it in consideration
	pools.append(Pool.ANY)

	# Pick a random pool
	var choosed_pool = pools.pick_random()
	var pool = cards[choosed_pool]

	# Pick a random type
	var choosed_type = pool.keys().pick_random()
	var type = pool[choosed_type]

	# Pick a rarity
	var rarity_options = type.keys()
	var choosed_rarity = null
	while choosed_rarity == null:
		var rarity_roll = randi() % 100
		for rarity in chances_base:
			if rarity_roll <= chances[rarity] and rarity in rarity_options:
				choosed_rarity = rarity
				break
	
	# Creates the card, set its categories attributes and returns it
	var card_script = type[choosed_rarity].pick_random()
	var card = card_script.new() as Card
	card.set_categories(choosed_pool, choosed_type, choosed_rarity)
	return card


## Upgrade a card to a better rarity
func upgrade_card(card: Card) -> Card:
	# Get the card type
	var type = cards[card.pool][card.type]

	# Get the next rarity
	var new_rarity = _get_next_rarity(card)

	# Destroy the old card
	card.queue_free()

	# Creates the card, set its categories attributes and returns it
	var new_card_script = type[new_rarity].pick_random()
	var new_card = new_card_script.new() as Card
	new_card.set_categories(card.pool, card.type, new_rarity)
	return new_card


## Downgrade a card to a worse rarity
func downgrade_card(card: Card) -> Card:
	# Get the card type
	var type = cards[card.pool][card.type]

	# Get the previous rarity
	var new_rarity = _get_previous_rarity(card)

	# Destroy the old card
	card.queue_free()

	# Creates the card, set its categories attributes and returns it
	var new_card_script = type[new_rarity].pick_random()
	var new_card = new_card_script.new() as Card
	new_card.set_categories(card.pool, card.type, new_rarity)
	return new_card


## Get the possible upgrades for a card
func get_possible_upgrades(card: Card) -> Array[Card]:
	# Get the card type and the next rarity
	var type = cards[card.pool][card.type]	
	var next_rarity = _get_next_rarity(card)

	# Get the possible upgrades
	var possible_upgrades = type[next_rarity]
	var upgrades = []
	for upgrade in possible_upgrades:
		var new_card = upgrade.new() as Card
		new_card.set_categories(card.pool, card.type, next_rarity)
		upgrades.append(new_card)
	return upgrades


func _get_next_rarity(card: Card) -> Rarity:
	var rarity_options = cards[card.pool][card.type].keys()
	var rarity_index = rarity_options.find(card.rarity)
	var next_rarity = min(rarity_index + 1, rarity_options.size() - 1)
	return rarity_options[next_rarity]


func _get_previous_rarity(card: Card) -> Rarity:
	var rarity_options = cards[card.pool][card.type].keys()
	var rarity_index = rarity_options.find(card.rarity)
	var previous_rarity = max(rarity_index - 1, 0)
	return rarity_options[previous_rarity]
