class_name PrisonerAction
extends SpecialAction

const SELECTOR = preload(
	"res://maps/board/selectors/item_selector/ItemSelector.tscn"
)
const PRISONER_UI = preload(
	"res://maps/board/tile/instances/special/actions/prisoner/PrisonerUI.tscn"
)
const JELLO_BOTH := 10
const JELLO_TAKE := 80

enum OPTIONS {
	NOT_CHOOSED,
	SPARE,
	TAKE
}

func _init():
	super._init()
	sprite = preload("res://assets/tiles/icon_special3.png")


func effect(board: Board, player: BoardPlayer, ui: CanvasLayer) -> void:
	# Gets all players except the current player
	var players = board.players.filter(
		func(p): return p != player
	)
	# Creates a selector to select a player
	var selector = SELECTOR.instantiate().init(players) as ItemSelector
	# Await for the selector to return a player
	var selected_player := await player.select(selector) as BoardPlayer
	
	# Creates a ui to show the prisoner dilemma
	var prisoner_ui = PRISONER_UI.instantiate().init(player, selected_player)
	ui.add_child(prisoner_ui)
	# Await for the ui to return the choices
	var choices = await prisoner_ui.choosed as Array[OPTIONS]
	# Apply the result
	_apply_result([player, selected_player], choices, prisoner_ui)
	
	# Wait for 5 seconds and remove the ui
	await prisoner_ui.get_tree().create_timer(5).timeout
	ui.remove_child(prisoner_ui)
	prisoner_ui.queue_free()

# Apply the result of the prisoner dilemma
# @param players: The players that are involved in the dilemma
# @param choices: The choices of the players
# @param ui: The ui that is used to show the result
func _apply_result(players: Array[BoardPlayer], choices: Array[OPTIONS], ui: PrisonerUI) -> void:
	var p1_choice := choices[0]
	var p2_choice := choices[1]
	match p1_choice:
		OPTIONS.SPARE:
			match p2_choice:
				OPTIONS.SPARE:
					# Both players spared, both gained JELLO_BOTH jello coins 
					ui.show_result("Both players spared, both gained %s jello coins" % JELLO_BOTH)
					players[0].score.sub_points += JELLO_BOTH
					players[1].score.sub_points += JELLO_BOTH
				OPTIONS.TAKE:
					ui.show_result(
						"%s spared, %s took, %s gained 80 jello coins" % 
						[players[0], players[1], players[1]].map(func(p): return p.nick)
					)
					players[1].score.sub_points += JELLO_TAKE
		OPTIONS.TAKE:
			match p2_choice:
				OPTIONS.SPARE:
					ui.show_result(
						"%s took, %s spared, %s gained 80 jello coins" % 
						[players[0], players[1], players[0]].map(func(p): return p.nick)
					)
					players[0].score.sub_points += JELLO_TAKE
				OPTIONS.TAKE:
					ui.show_result("Both players took, nobody gained jello coin")
