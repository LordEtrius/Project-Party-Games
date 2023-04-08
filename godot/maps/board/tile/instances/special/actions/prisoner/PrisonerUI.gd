class_name PrisonerUI
extends Control

signal choosed(choices: Array[PrisonerAction.OPTIONS])

var player1: BoardPlayer
var player2: BoardPlayer

var _choices: Array[PrisonerAction.OPTIONS] = [PrisonerAction.OPTIONS.NOT_CHOOSED, PrisonerAction.OPTIONS.NOT_CHOOSED]

@onready var _player1_label = $PanelContainer/VBoxContainer/MarginContainer/Game/Player1/Label
@onready var _player2_label = $PanelContainer/VBoxContainer/MarginContainer/Game/Player2/Label


func init(player1: BoardPlayer, player2: BoardPlayer) -> PrisonerUI:
	self.player1 = player1
	self.player2 = player2
	return self


func _input(event):
	if _choices[0] == PrisonerAction.OPTIONS.NOT_CHOOSED:
		if event.is_action_pressed("prisoner_spare_1") || event.is_action_pressed("prisoner_take_1"):
			if event.is_action_pressed("prisoner_spare_1"):
				_choices[0] = PrisonerAction.OPTIONS.SPARE
			else:
				_choices[0] = PrisonerAction.OPTIONS.TAKE
	_update_ui()
	if _choices[1] == PrisonerAction.OPTIONS.NOT_CHOOSED:
		if event.is_action_pressed("prisoner_spare_2") || event.is_action_pressed("prisoner_take_2"):
			if event.is_action_pressed("prisoner_spare_2"):
				_choices[1] = PrisonerAction.OPTIONS.SPARE
			else:
				_choices[1] = PrisonerAction.OPTIONS.TAKE
	_update_ui()


func _update_ui():
	if _choices[0] != PrisonerAction.OPTIONS.NOT_CHOOSED:
		$PanelContainer/VBoxContainer/MarginContainer/Game/Player1/VBoxContainer/Label.hide()
		$PanelContainer/VBoxContainer/MarginContainer/Game/Player1/VBoxContainer/Label2.hide()
		$PanelContainer/VBoxContainer/MarginContainer/Game/Player1/VBoxContainer/Label3.show()
	if _choices[1] != PrisonerAction.OPTIONS.NOT_CHOOSED:
		$PanelContainer/VBoxContainer/MarginContainer/Game/Player2/VBoxContainer/Label.hide()
		$PanelContainer/VBoxContainer/MarginContainer/Game/Player2/VBoxContainer/Label2.hide()
		$PanelContainer/VBoxContainer/MarginContainer/Game/Player2/VBoxContainer/Label3.show()
	
	if _choices.all(func(choice): return choice != PrisonerAction.OPTIONS.NOT_CHOOSED):
		await get_tree().create_timer(.5).timeout
		choosed.emit(_choices)


func show_result(result: String):
	$PanelContainer/VBoxContainer/MarginContainer/Game/Player1/VBoxContainer/Label3.text = "%s %s" % [player1.nick, _choice_to_str(_choices[0])]
	$PanelContainer/VBoxContainer/MarginContainer/Game/Player1/VBoxContainer/Label3.text = "%s %s" % [player2.nick, _choice_to_str(_choices[1])]
	$PanelContainer/VBoxContainer/MarginContainer/Game/Image/Description.text = result


func _choice_to_str(choice: PrisonerAction.OPTIONS) -> String:
	match choice:
		PrisonerAction.OPTIONS.SPARE:
			return "spared"
		PrisonerAction.OPTIONS.TAKE:
			return "took"
	return ""

func _set_labels() -> void:
	_player1_label.text = player1.nick
	_player2_label.text = player2.nick


func _ready():
	_set_labels()
