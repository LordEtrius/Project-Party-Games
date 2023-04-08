class_name PrisonerAction
extends SpecialAction

enum OPTIONS {
	NOT_CHOOSED,
	SPARE,
	TAKE
}

func _init():
	super._init()
	sprite = preload("res://assets/tiles/icon_special3.png")


func effect(board: Board, player: BoardPlayer, ui: CanvasLayer) -> void:
	var players = board.players.filter(
		func(p): return p != player
	)
	var selected_player := await player.select_item(
		players
	) as BoardPlayer
	var prisoner_ui = preload("res://maps/board/tile/instances/special/actions/prisoner/PrisonerUI.tscn").instantiate().init(player, selected_player)
	ui.add_child(prisoner_ui)
	var choices = await prisoner_ui.choosed as Array[OPTIONS]
	_apply_result([player, selected_player], choices, prisoner_ui)
	await prisoner_ui.get_tree().create_timer(5).timeout
	ui.remove_child(prisoner_ui)
	prisoner_ui.queue_free()


func _apply_result(players: Array[BoardPlayer], choices: Array[OPTIONS], ui: PrisonerUI) -> void:
	var p1_choice := choices[0]
	var p2_choice := choices[1]
	match p1_choice:
		OPTIONS.SPARE:
			match p2_choice:
				OPTIONS.SPARE:
					ui.show_result("Both players spared, both gained 10 jello coins")
					players[0].score.sub_points += 10
					players[1].score.sub_points += 10
				OPTIONS.TAKE:
					ui.show_result("%s spared, %s took, %s gained 80 jello coins" % [players[0], players[1], players[1]].map(func(p): return p.nick))
					players[1].score.sub_points += 80
		OPTIONS.TAKE:
			match p2_choice:
				OPTIONS.SPARE:
					ui.show_result("%s took, %s spared, %s gained 80 jello coins" % [players[0], players[1], players[0]].map(func(p): return p.nick))
					players[0].score.sub_points += 80
				OPTIONS.TAKE:
					ui.show_result("Both players took, nobody gained jello coin")
