extends Card
class_name SubPoint


func _init():
	title = "SubPoints"
	description = "Give sub points"


func effect(board, player):
	player.score.sub_points += 5
	await player.animate_scale()
