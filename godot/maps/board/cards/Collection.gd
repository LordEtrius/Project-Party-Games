extends Node

var _chances_base := {
	basic = 60,
	rare = 80,
	broken = 90,
	legendary = 99
}

var cards = {
#	water = {
#		basic = [Dice],
#		rare = [Dice],
#		broken = [Dice],
#		legendary = [Dice],
#	},
	any = {
		basic = [Dice],
		rare = [Teleport, SubPoint, Burner, CloseAttack, RangedAttack],
		broken = [WhereAmI, Suicide, BloodForBlood],
		legendary = [TeleportToTile, Swap],
	}
}

func get_random_card(pools := [] as Array[String], chances := _chances_base):
	pools.append("any")
	var chance := randi() % 100
	for arity in chances.keys():
		if chance < chances[arity]:
			var filtered_cards = _filter_cards_by_arity(pools, arity) as Array[Card]
			var card_type = Util.array_get_random(filtered_cards)
			return card_type.new() as Card


func _filter_cards_by_arity(pools: Array[String], arity: String) -> Array:
	return pools.map(
		func(pool): return cards[pool][arity]
	).reduce(func(a, b): return a + b, [])
