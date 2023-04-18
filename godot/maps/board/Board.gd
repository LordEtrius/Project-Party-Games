extends Node2D
class_name Board

@export_group("Game")
@export var max_round: int = 12
@export var max_cards: int = 5

@export_group("Discard")
@export var max_cards_per_round: int = 5
@export var points_gained_per_discard: int = 1

@onready var Title = $UI/Screen/Title
@onready var ScoreUI := $UI/Screen/ScoreUI

@onready var PlanningUI := $UI/Screen/Phases/Planning
@onready var PlayUI := $UI/Screen/Phases/Play
@onready var _discard_ui := $UI/Screen/Phases/DiscardUI
@onready var graph := $Map/Graph
@onready var players := _get_players()

var state = {"actual_player": null}


func _get_players() -> Array[BoardPlayer]:
	var result = [] as Array[BoardPlayer]
	for node in $Players.get_children():
		result.append(node as BoardPlayer)
	return result


func setup_game(players: Array[BoardPlayer]) -> void:
	var start_tile = $Map/Graph/Tiles/Start as Tile

	var i := 0
	for player in players:
		var score_player_ui = preload("res://maps/board/player/score/ScorePlayerUI.tscn").instantiate().init(player)
		score_player_ui.set_anchors_preset(Control.PRESET_FULL_RECT)
		var placeholder = ScoreUI.get_child(i) as Control
		placeholder.add_child(score_player_ui)
		i += 1

	for player in players:
		player.actual_tile = start_tile
		player.graph = graph


func transition_to_pre_turn(player: BoardPlayer) -> void:
	# show title transitions
	var title := "Starting %s's turn" % player.nick
	await Title.play_title(title)


func pre_turn(player: BoardPlayer) -> void:
	# Apply positive energy
	var positive_energy = player.score.positive_energy
	for i in positive_energy:
		player.cards.apply_positive_energy()
	player.score.positive_energy = 2 # TODO: REMOVE THIS '2', ONLY USED FOR TESTING

	# Apply negative energy
	var negative_energy = player.score.negative_energy
	for i in negative_energy:
		player.cards.apply_negative_energy()
	player.score.negative_energy = 0

	await player.play_pre_turn(self)
	await planning_phase(player)
	pass


func planning_phase(player: BoardPlayer) -> void:
	PlanningUI.deck = player.cards
	PlanningUI.show()
	await PlanningUI.pressed_play
	PlanningUI.hide()
	PlanningUI.deck = null


func turn(player: BoardPlayer) -> void:
	PlayUI.show()
	PlayUI.deck = player.cards
	await player.play_turn(self)
	PlayUI.hide()


func transition_to_turn(_player: BoardPlayer) -> void:
	await Title.play_title("Playing turn")


func post_turn(player: BoardPlayer) -> void:
	await discard_phase(player)


func discard_phase(player: BoardPlayer) -> void:
	if player.cards.deck.size() > max_cards_per_round:
		_discard_ui.player = player
		_discard_ui.max_cards = max_cards_per_round
		_discard_ui.points_gained_per_discard = points_gained_per_discard
		_discard_ui.show()
		await _discard_ui.discarded
		_discard_ui.hide()
		_discard_ui.player = null


func game_round(players: Array[BoardPlayer]) -> void:
	for player in players:
		state.actual_player = player
		BoardEvent.emit_signal("turn_started", player)
		TransitionEvent.transition_to(player)
		await transition_to_pre_turn(player)
		await pre_turn(player)
		await transition_to_turn(player)
		await turn(player)
		await post_turn(player)
		await get_tree().create_timer(1).timeout
		BoardEvent.emit_signal("turn_ended")


func _ready():
	setup_game(players)
	for round_i in max_round:
		BoardEvent.emit_signal("round_started", round_i, max_round)
		BoardEvent.emit_signal("special_block", randi())
		await game_round(players)
